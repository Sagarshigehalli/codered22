import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/sms_parser.dart';

class UserDataProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  // --- DASHBOARD REAL DATA STATES ---
  bool isLoadingDashboard = false;
  double thisMonthSpend = 0.0;
  double lastMonthSpend = 0.0;
  double debtPaid = 0.0;
  double savingsRate = 0.0;
  Map<String, double> spendingBreakdown = {}; 

  // --- AI INSIGHT STATES ---
  String? aiRemark;
  String? aiAdvice;
  String? aiSentiment; // 'happy', 'neutral', 'angry', 'worried'
  bool isAiLoading = false;

  // --- CORE FINANCIAL DATA ---
  double totalBalance = 0.0;
  double lockedAmount = 0.0;
  Map<String, dynamic> lockedBreakdown = {};
  double dailyLimit = 500.0;
  double todaySpent = 0.0;
  double earningsPerMinute = 0.0;
  String indiaWealthRank = "Top 10%";

  // --- PROFILE STATS ---
  int currentStreak = 5;
  int maxStreak = 12;
  double totalSavedInStreak = 1250.0;
  double totalLifetimeSavings = 45000.0;
  String financialGrade = "A-"; 
  
  List<Map<String, dynamic>> monthlySavingsHistory = [
    {"month": "Jul", "amount": 2000.0},
    {"month": "Aug", "amount": 3500.0},
    {"month": "Sep", "amount": 1500.0},
    {"month": "Oct", "amount": 4200.0},
    {"month": "Nov", "amount": 3800.0},
    {"month": "Dec", "amount": 5000.0},
  ];

  // --- TAGS & TRANSACTIONS ---
  List<String> recentTags = ['Groceries', 'Restro', 'Bar', 'Bus', 'Snacks'];
  List<Map<String, dynamic>> recentTransactions = [];
  double detectedMonthlyIncome = 0.0;
  double detectedMonthlyExpense = 0.0;

  // --- STUDENT STATS ---
  Map<String, double> frequentDestinations = {}; 
  Map<String, double> expenseDistribution = {}; 
  List<Map<String, dynamic>> top3HighestSpends = []; 

  // --- GETTERS ---
  double get freeToSpend => totalBalance - lockedAmount;
  double get remainingDailyLimit => dailyLimit - todaySpent;

  String get maaMood {
    if (aiSentiment != null) return aiSentiment!;
    // Fallback Logic
    if (todaySpent > dailyLimit) return "Angry";
    if (todaySpent > (dailyLimit * 0.8)) return "Worried";
    return "Happy";
  }

  String get maaMessage {
    if (aiAdvice != null && aiRemark != null) {
      return "$aiRemark\n$aiAdvice";
    }
    // Fallback Logic
    if (todaySpent > dailyLimit) return "Bas kar! No more spending today.";
    if (todaySpent > (dailyLimit * 0.8)) return "Watch it. You are working for free now.";
    return "I am proud of you beta. Keep saving.";
  }

  String get financialHealthStatus {
    if (totalBalance == 0) return "Unknown";
    double ratio = lockedAmount / totalBalance;
    if (ratio > 0.7) return "Critical";
    if (ratio > 0.5) return "Risky";
    return "Healthy";
  }

  String get financialHealthMessage {
    if (totalBalance == 0) return "Maa needs more info to judge.";
    double ratio = lockedAmount / totalBalance;
    if (ratio > 0.7) return "Beta, 70% on bills? You are working just to pay others!";
    if (ratio > 0.5) return "Be careful. Half your money is gone before you blink.";
    return "Good job! You are living within your means.";
  }

  // --- 1. UPDATED: FETCH AI INSIGHTS (With 5s Timeout) ---
  Future<void> fetchMaaInsight(String tag, double amount) async {
    isAiLoading = true;
    notifyListeners();

    // NOTE: On real devices, 10.0.2.2 usually fails. 
    // Ideally use your PC's local IP (e.g. 192.168.1.X)
    final url = Uri.parse('http://10.145.45.242:8000/maa_insights'); 

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "tag": tag,
          "amount": amount,
          "spending_habits": null 
        }),
      ).timeout(const Duration(seconds: 5)); // Stop waiting after 5 seconds

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        aiRemark = data['remark'];
        aiAdvice = data['advice'];
        aiSentiment = data['sentiment']; 
        notifyListeners();
      } else {
        debugPrint("AI API Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("AI Connection Error (Continuing app flow): $e");
    } finally {
      // Ensure loading stops so the button works again
      isAiLoading = false;
      notifyListeners();
    }
  }

  // --- 2. FETCH DASHBOARD DATA ---
  Future<void> fetchDashboardData() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    isLoadingDashboard = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('trnsactions')
          .select()
          .eq('user_id', user.id);

      final List<dynamic> data = response;
      
      final profileRes = await _supabase
          .from('usr_profiles')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      double monthlyIncome = 0.0;
      if (profileRes != null) {
        monthlyIncome = (profileRes['monthly_income'] ?? profileRes['pocket_money'] ?? 0).toDouble();
      }

      double currentMonthTotal = 0.0;
      double prevMonthTotal = 0.0;
      double currentDebtPaid = 0.0;
      Map<String, double> categoryMap = {};

      final now = DateTime.now();
      
      for (var txn in data) {
        DateTime? date;
        try {
          date = DateTime.parse(txn['transaction_date'].toString());
        } catch (e) {
          continue; 
        }

        double amount = (txn['amount'] ?? 0).toDouble();
        String type = txn['type'] ?? 'Expense';
        String category = txn['category'] ?? 'General';

        if (type == 'Expense') {
          if (date.month == now.month && date.year == now.year) {
            currentMonthTotal += amount;
            categoryMap[category] = (categoryMap[category] ?? 0) + amount;
            if (category.toLowerCase().contains('emi') || category.toLowerCase().contains('debt')) {
              currentDebtPaid += amount;
            }
          }
          else if (date.month == (now.month - 1) && date.year == now.year) {
            prevMonthTotal += amount;
          }
        }
      }

      thisMonthSpend = currentMonthTotal;
      lastMonthSpend = prevMonthTotal;
      debtPaid = currentDebtPaid;
      spendingBreakdown = categoryMap;

      if (monthlyIncome > 0) {
        savingsRate = ((monthlyIncome - currentMonthTotal) / monthlyIncome) * 100;
        if (savingsRate < 0) savingsRate = 0; 
      } else {
        savingsRate = 0;
      }

    } catch (e) {
      debugPrint("Error fetching dashboard data: $e");
    } finally {
      isLoadingDashboard = false;
      notifyListeners();
    }
  }

  // --- 3. PARSE SMS & SAVE TO SUPABASE ---
  Future<void> processParsedMessages(
    List<Map<String, dynamic>> rawMessageObjects,
  ) async {
    final user = _supabase.auth.currentUser;
    
    List<Map<String, dynamic>> parsedTxns = [];
    List<Map<String, dynamic>> txnsToInsert = []; 
    
    double totalCredit3Months = 0.0;
    double totalDebit3Months = 0.0;

    for (var msgObj in rawMessageObjects) {
      String body = msgObj['body'];
      DateTime date = msgObj['date'];

      var data = SmsParserEngine.parse(body, date);

      if (data != null) {
        parsedTxns.add(data);
        double amt = data['numericAmount'];

        if (data['type'] == 'Income') {
          totalCredit3Months += amt;
        } else {
          totalDebit3Months += amt;
        }

        if (user != null) {
          txnsToInsert.add({
            'user_id': user.id,
            'merchant': data['merchant'],
            'amount': amt,
            'type': data['type'], 
            'category': data['category'],
            'transaction_date': data['time'],
            'account': data['account'],
            'created_at': DateTime.now().toIso8601String(),
          });
        }
      }
    }

    if (txnsToInsert.isNotEmpty) {
      try {
        await _supabase.from('trnsactions').insert(txnsToInsert);
      } catch (e) {
        debugPrint("Error saving transactions: $e");
      }
    }

    parsedTxns.sort((a, b) => b['time'].compareTo(a['time']));
    recentTransactions = parsedTxns;

    detectedMonthlyIncome = totalCredit3Months / 3;
    detectedMonthlyExpense = totalDebit3Months / 3;

    if (detectedMonthlyIncome == 0) detectedMonthlyIncome = 0;
    if (detectedMonthlyExpense == 0) detectedMonthlyExpense = 0;

    _calculateStudentStats(parsedTxns);
    
    if (user != null) fetchDashboardData(); 

    notifyListeners();
  }

  // --- 4. STUDENT STATS LOGIC ---
  void _calculateStudentStats(List<Map<String, dynamic>> txns) {
    frequentDestinations = {};
    expenseDistribution = {};
    top3HighestSpends = []; 

    Map<String, List<double>> merchantAmounts = {};
    Map<String, double> merchantTotals = {};

    for (var tx in txns) {
      if (tx['type'] == 'Expense') {
        String merchant = tx['merchant'];
        double amount = tx['numericAmount'];

        if (merchant.contains("DEBIT") ||
            merchant.contains("WITHDRAWAL") ||
            merchant.contains("UPI") ||
            merchant == "UNKNOWN") {
          continue;
        }

        if (!merchantAmounts.containsKey(merchant)) {
          merchantAmounts[merchant] = [];
        }
        merchantAmounts[merchant]!.add(amount);

        merchantTotals[merchant] = (merchantTotals[merchant] ?? 0) + amount;
      }
    }

    merchantAmounts.forEach((merchant, amounts) {
      if (amounts.length > 1) {
        double avg = amounts.reduce((a, b) => a + b) / amounts.length;
        frequentDestinations[merchant] = avg;
      }
    });

    var sortedTotals = merchantTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    double otherTotal = 0;
    for (int i = 0; i < sortedTotals.length; i++) {
      if (i < 5) {
        expenseDistribution[sortedTotals[i].key] = sortedTotals[i].value;
      } else {
        otherTotal += sortedTotals[i].value;
      }
    }
    if (otherTotal > 0) {
      expenseDistribution["Others"] = otherTotal;
    }

    var expenses = txns
        .where((tx) =>
            tx['type'] == 'Expense' &&
            !tx['merchant'].toString().contains("DEBIT") &&
            !tx['merchant'].toString().contains("WITHDRAWAL"))
        .toList();
    expenses.sort((a, b) => b['numericAmount'].compareTo(a['numericAmount']));
    top3HighestSpends = expenses.take(3).toList();
  }

  // --- 5. PROFILE FINALIZATION (HELPER METHODS) ---
  Future<void> finalizeUnsalariedProfile({
    required double confirmedIncome,
    required double workHours,
    required double rent,
    required double utilities,
    required double emi,
  }) async {
    totalBalance = confirmedIncome;
    lockedAmount = rent + utilities + emi;

    lockedBreakdown = {
      "Rent": {"totalAllocated": rent, "items": []},
      "Utilities": {"totalAllocated": utilities, "items": []},
      "EMI/Debts": {"totalAllocated": emi, "items": []},
    };

    dailyLimit = (totalBalance - lockedAmount) / 30;
    if (dailyLimit < 0) dailyLimit = 0;

    double monthlyMinutes = workHours * 4 * 60;
    earningsPerMinute = (monthlyMinutes > 0) ? (confirmedIncome / monthlyMinutes) : 0.0;

    if (confirmedIncome > 100000) indiaWealthRank = "Top 2%";
    else if (confirmedIncome > 50000) indiaWealthRank = "Top 10%";
    else indiaWealthRank = "Top 30%";

    final user = _supabase.auth.currentUser;
    if (user != null) {
      try {
        await _supabase.from('usr_profiles').upsert({
          'user_id': user.id,
          'user_type': workHours == 0 ? 'student' : 'unsalaried', 
          'monthly_income': workHours > 0 ? confirmedIncome : 0,
          'pocket_money': workHours == 0 ? confirmedIncome : 0,
          'rent': rent,
          'utilities': utilities,
          'emi': emi,
          'work_hours': workHours,
          'updated_at': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        debugPrint("Error saving profile: $e");
      }
    }

    notifyListeners();
  }

  void setStudentProfile({required double pocketMoney}) {
    finalizeUnsalariedProfile(
      confirmedIncome: pocketMoney,
      workHours: 0,
      rent: 0,
      utilities: 0,
      emi: 0,
    );
    indiaWealthRank = "Student Tier";
    earningsPerMinute = 0; 
    notifyListeners();
  }

  void setSalariedProfile({
    required double income,
    required double rent,
    required double utilities,
    required double emi,
    required double weeklyHours,
  }) {
    finalizeUnsalariedProfile(
      confirmedIncome: income,
      workHours: weeklyHours,
      rent: rent,
      utilities: utilities,
      emi: emi,
    );
  }

  void setUnsalariedProfile() {
    totalBalance = 45000.0;
    lockedAmount = 20000.0;
    lockedBreakdown = {
      "Rent": {
        "totalAllocated": 12000.0,
        "items": [
          {"name": "House Rent", "amount": 12000.0, "upi": "owner@upi", "paid": false},
        ],
      },
      "Utilities": {"totalAllocated": 3000.0, "items": []},
      "Savings": {"totalAllocated": 5000.0, "items": []},
    };
    dailyLimit = 800.0;
    earningsPerMinute = 4.5;
    indiaWealthRank = "Top 15%";
    recentTransactions = [{"merchant": "Client Payment", "amount": "+ ₹15,000", "time": "Yesterday", "category": "Income", "isNegative": false}];
    notifyListeners();
  }

  // --- 6. ADDITIONAL HELPERS ---
  bool addSubExpense(String category, String name, double amount) {
    final bucket = lockedBreakdown[category];
    double currentUsed = 0;
    for (var item in bucket['items']) {
      currentUsed += (item['amount'] as num).toDouble();
    }
    if (currentUsed + amount <= bucket['totalAllocated']) {
      bucket['items'].add({"name": name, "amount": amount, "upi": null, "paid": false});
      notifyListeners();
      return true;
    }
    return false;
  }

  void setupAutopay(String category, int index, String upiId) {
    lockedBreakdown[category]['items'][index]['upi'] = upiId;
    notifyListeners();
  }

  void paySubExpense(String category, int index) {
    final item = lockedBreakdown[category]['items'][index];
    if (item['paid'] == false) {
      double amount = (item['amount'] as num).toDouble();
      item['paid'] = true;
      totalBalance -= amount;
      lockedAmount -= amount;
      recentTransactions.insert(0, {
        "merchant": "${item['name']} ($category)",
        "amount": "- ₹${amount.toStringAsFixed(0)}",
        "time": "Just Now",
        "category": "Bill",
        "isNegative": true,
      });
      notifyListeners();
    }
  }

  bool requiresIntervention(double amount) {
    if (amount > freeToSpend) return true;
    if ((todaySpent + amount) > dailyLimit) return true;
    return false;
  }

  void executeTransaction(double amount, String tag) {
    bool deductedFromLocked = false;
    for (var catKey in lockedBreakdown.keys) {
      var cat = lockedBreakdown[catKey];
      for (var item in cat['items']) {
        if (item['name'].toString().toLowerCase() == tag.toLowerCase()) {
          double currentAmount = (item['amount'] as num).toDouble();
          if (currentAmount >= amount) {
            item['amount'] = currentAmount - amount;
            lockedAmount -= amount;
            totalBalance -= amount;
            deductedFromLocked = true;
          } else {
            double remainder = amount - currentAmount;
            item['amount'] = 0.0;
            lockedAmount -= currentAmount;
            totalBalance -= amount;
            todaySpent += remainder;
            deductedFromLocked = true;
          }
          break;
        }
      }
      if (deductedFromLocked) break;
    }
    if (!deductedFromLocked) {
      totalBalance -= amount;
      todaySpent += amount;
    }
    recentTransactions.insert(0, {
      "merchant": tag,
      "amount": "- ₹${amount.toStringAsFixed(0)}",
      "time": "Just Now",
      "category": deductedFromLocked ? "Locked Fund" : "General",
      "isNegative": true,
    });
    notifyListeners();
  }

  String getTagScolding(String tag) {
    switch (tag.toLowerCase()) {
      case 'groceries': return "Buy vegetables, not chips. Health is wealth.";
      case 'restro': return "Why eat out? I made Dal Makhani at home.";
      case 'bar': return "Alcohol burns your liver and your wallet. Bad habit!";
      case 'bus': return "Good. Public transport saves money. I approve.";
      case 'snacks': return "You just ate lunch. Do you really need this samosa?";
      default: return "Do you really need to spend this hard-earned money?";
    }
  }

  double getBalanceForTag(String tag) {
    for (var cat in lockedBreakdown.values) {
      for (var item in cat['items']) {
        if (item['name'].toString().toLowerCase() == tag.toLowerCase()) {
          return (item['amount'] as num).toDouble();
        }
      }
    }
    return freeToSpend;
  }

  bool isLockedTag(String tag) {
    if (lockedBreakdown.containsKey(tag)) return true;
    for (var cat in lockedBreakdown.values) {
      for (var item in cat['items']) {
        if (item['name'].toString().toLowerCase() == tag.toLowerCase()) return true;
      }
    }
    return false;
  }

  void addTag(String tag) {
    if (!recentTags.contains(tag)) {
      recentTags.insert(0, tag);
      if (recentTags.length > 5) recentTags.removeLast();
      notifyListeners();
    }
  }
}