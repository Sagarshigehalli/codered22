// File: lib/screens/locked/locked_funds_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class LockedFundsPage extends StatelessWidget {
  const LockedFundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);
    final breakdown = userData.lockedBreakdown;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F2),
      appBar: AppBar(
        title: Text(
          "Maa's Safe",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF264653),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF264653)),
      ),
      body: breakdown.isEmpty
          ? Center(
              child: Text(
                "No locked funds yet.",
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: breakdown.keys.map((category) {
                final bucket = breakdown[category];
                final double total = bucket['totalAllocated'];
                final List items = bucket['items'];
                double used = 0;
                for (var i in items) used += i['amount'];

                double progress = total == 0 ? 0 : used / total;
                Color statusColor = progress >= 1.0
                    ? Colors.red
                    : const Color(0xFF2A9D8F);

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE07A5F).withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: const Color(0xFF264653),
                            ),
                          ),
                          Text(
                            "₹${total.toStringAsFixed(0)}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: const Color(0xFFE07A5F),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress > 1 ? 1 : progress,
                              backgroundColor: Colors.grey[100],
                              color: statusColor,
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Allocated: ₹${used.toStringAsFixed(0)} / ₹${total.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      children: [
                        const Divider(),
                        if (items.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "No bills added yet.",
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ...items.asMap().entries.map((entry) {
                          int idx = entry.key;
                          Map item = entry.value;
                          bool hasUpi = item['upi'] != null;
                          bool isPaid = item['paid'];

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9F7F2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.receipt_long,
                                color: Color(0xFF264653),
                              ),
                            ),
                            title: Text(
                              item['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "₹${item['amount'].toStringAsFixed(0)}",
                              style: const TextStyle(
                                color: Color(0xFFE07A5F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: isPaid
                                ? const Chip(
                                    label: Text(
                                      "Paid",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.green,
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: hasUpi
                                          ? const Color(0xFF264653)
                                          : Colors.grey[300],
                                      foregroundColor: hasUpi
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    onPressed: () {
                                      if (!hasUpi) {
                                        _showUpiDialog(context, category, idx);
                                      } else {
                                        Provider.of<UserDataProvider>(
                                          context,
                                          listen: false,
                                        ).paySubExpense(category, idx);
                                      }
                                    },
                                    child: Text(hasUpi ? "Pay Now" : "Setup"),
                                  ),
                          );
                        }),
                        if (used < total)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextButton.icon(
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text("Add Bill Split"),
                              onPressed: () => _showAddDialog(
                                context,
                                category,
                                total - used,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

  void _showUpiDialog(BuildContext context, String category, int index) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Setup Autopay"),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            labelText: "Enter UPI ID",
            hintText: "e.g. landlord@upi",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.isNotEmpty) {
                Provider.of<UserDataProvider>(
                  context,
                  listen: false,
                ).setupAutopay(category, index, ctrl.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, String category, double remaining) {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Add to $category"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Remaining budget: ₹$remaining",
              style: const TextStyle(color: Colors.grey),
            ),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: "Label (e.g. Garage)",
              ),
            ),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final amt = double.tryParse(amountCtrl.text) ?? 0;
              if (amt > 0 && amt <= remaining) {
                Provider.of<UserDataProvider>(
                  context,
                  listen: false,
                ).addSubExpense(category, nameCtrl.text, amt);
                Navigator.pop(ctx);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Invalid amount or exceeds limit"),
                  ),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}