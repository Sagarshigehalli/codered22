class SmsParserEngine {
  // STRICT DEBIT PATTERN:
  // Matches: "Rs.12.00 paid thru A/C XX5246 on 10-5-25... to DEPOT MANAGER"
  static final RegExp _strictDebitPattern = RegExp(
    r'(?:Rs\.?|INR)\s*([\d,]+(?:\.\d{2})?)\s+paid\s+thru\s+(?:A/C|Account)\s+([A-Z0-9]+)\s+on\s+.*?\s+to\s+([A-Za-z0-9\s]+?)(?:,|\.|UPI|Ref)',
    caseSensitive: false,
  );

  // STRICT CREDIT PATTERN:
  // Matches: "Your a/c no. XX5246 has been credited with Rs.50.00..."
  static final RegExp _strictCreditPattern = RegExp(
    r'Your\s+a/c\s+no\.\s+([A-Za-z0-9]+)\s+has\s+been\s+credited\s+with\s+Rs\.?\s*([\d,]+(?:\.\d{2})?)',
    caseSensitive: false,
  );

  // Helper to find sender in credit messages
  static final RegExp _fromPattern = RegExp(
    r'from\s+a/c\s+no\.\s+([A-Za-z0-9]+)',
    caseSensitive: false,
  );

  static Map<String, dynamic>? parse(String messageBody, DateTime timestamp) {
    double amount = 0.0;
    String type = "";
    String category = "General";
    String merchant = "";
    String account = "XXXX";

    // 1. Try Debit Match
    var match = _strictDebitPattern.firstMatch(messageBody);
    if (match != null) {
      String amountStr = match.group(1)!.replaceAll(',', '');
      amount = double.tryParse(amountStr) ?? 0.0;
      account = match.group(2) ?? "XXXX";
      merchant = match.group(3)?.trim() ?? "Unknown Merchant";
      type = "Expense";
      category = "Expense";
    } else {
      // 2. Try Credit Match
      match = _strictCreditPattern.firstMatch(messageBody);
      if (match != null) {
        account = match.group(1) ?? "XXXX";
        String amountStr = match.group(2)!.replaceAll(',', '');
        amount = double.tryParse(amountStr) ?? 0.0;
        type = "Income";
        category = "Income";
        
        // Try to find sender
        var fromMatch = _fromPattern.firstMatch(messageBody);
        if (fromMatch != null) {
          merchant = "Transfer from ${fromMatch.group(1)}";
        } else {
          merchant = "Deposit / Transfer";
        }
      } else {
        // 3. No match found
        return null;
      }
    }

    // Uppercase for consistency in stats
    merchant = merchant.toUpperCase();

    // Auto-categorize based on keywords
    if (merchant.contains("SWIGGY") ||
        merchant.contains("ZOMATO") ||
        merchant.contains("FOOD")) category = "Food";
    if (merchant.contains("UBER") ||
        merchant.contains("OLA") ||
        merchant.contains("PETROL") ||
        merchant.contains("DEPOT")) category = "Transport";
    if (merchant.contains("NETFLIX") || merchant.contains("SPOTIFY"))
      category = "Subscription";
    if (merchant.contains("RENT") || merchant.contains("BESCOM"))
      category = "Bills";

    return {
      "merchant": merchant.isEmpty ? "Unknown" : merchant,
      "amount": type == "Income"
          ? "+ ₹${amount.toStringAsFixed(0)}"
          : "- ₹${amount.toStringAsFixed(0)}",
      "numericAmount": amount,
      "time": timestamp.toString().substring(0, 10), // Format: YYYY-MM-DD
      "category": category,
      "isNegative": type == "Expense",
      "type": type,
      "account": account,
    };
  }
}