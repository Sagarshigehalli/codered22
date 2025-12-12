import 'package:flutter/material.dart';
import '../services/sms_parser.dart';

class UserDataProvider extends ChangeNotifier {
  double totalBalance = 0.0;
  double lockedAmount = 0.0;
  Map<String, dynamic> lockedBreakdown = {};
  double dailyLimit = 500.0;
  double todaySpent = 0.0;
  double earningsPerMinute = 0.0;
  String indiaWealthRank = "Top 10%";
  List<String> recentTags = ['Groceries', 'Restro', 'Bar', 'Bus', 'Snacks'];
  List<Map<String, dynamic>> recentTransactions = [];
  double detectedMonthlyIncome = 0.0;
  double detectedMonthlyExpense = 0.0;

  double get freeToSpend => totalBalance - lockedAmount;
  double get remainingDailyLimit => dailyLimit - todaySpent;

  String get maaMood {
    if (todaySpent > dailyLimit) return "Angry";
    if (todaySpent > (dailyLimit * 0.8)) return "Worried";
    return "Happy";
  }

  String get maaMessage {
    if (todaySpent > dailyLimit) return "Bas kar! No more spending today.";
    if (todaySpent > (dailyLimit * 0.8))
      return "Watch it. You are working for free now.";
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
    if (ratio > 0.7)
      return "Beta, 70% on bills? You are working just to pay others!";
    if (ratio > 0.5)
      return "Be careful. Half your money is gone before you blink.";
    return "Good job! You are living within your means.";
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
        if (item['name'].toString().toLowerCase() == tag.toLowerCase())
          return true;
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

  Future<void> processParsedMessages(List<Map<String, dynamic>> rawMessageObjects) async {
    List<Map<String, dynamic>> parsedTxns = [];
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
      }
    }

    parsedTxns.sort((a, b) => b['time'].compareTo(a['time']));
    recentTransactions = parsedTxns;
    detectedMonthlyIncome = totalCredit3Months / 3;
    detectedMonthlyExpense = totalDebit3Months / 3;

    if (detectedMonthlyIncome == 0) detectedMonthlyIncome = 0;
    if (detectedMonthlyExpense == 0) detectedMonthlyExpense = 0;
    notifyListeners();
  }

  void finalizeUnsalariedProfile({
    required double confirmedIncome,
    required double workHours,
    required double rent,
    required double utilities,
    required double emi,
  }) {
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
    recentTransactions = [
      {"merchant": "Client Payment", "amount": "+ ₹15,000", "time": "Yesterday", "category": "Income", "isNegative": false},
    ];
    notifyListeners();
  }

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
}