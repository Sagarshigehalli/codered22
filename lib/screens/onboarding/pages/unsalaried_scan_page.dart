import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../../providers/user_provider.dart';

class UnsalariedScanPage extends StatefulWidget {
  final VoidCallback onComplete;
  const UnsalariedScanPage({super.key, required this.onComplete});
  @override
  State<UnsalariedScanPage> createState() => _UnsalariedScanPageState();
}

class _UnsalariedScanPageState extends State<UnsalariedScanPage> {
  final SmsQuery _query = SmsQuery();
  bool isScanning = false;
  double progress = 0.0;

  Future<void> _startRealScan() async {
    setState(() { isScanning = true; progress = 0.0; });
    var status = await Permission.sms.request();
    if (status.isGranted) {
      List<SmsMessage> messages = await _query.querySms(kinds: [SmsQueryKind.inbox]);
      List<Map<String, dynamic>> rawMessages = messages.where((m) {
        String addr = (m.address ?? "").toUpperCase();
        return addr.contains("CAN") || addr.contains("CNRB") || addr.contains("BANK") || addr.contains("HDFC") || addr.contains("SBI") || addr.contains("ICICI");
      }).map((m) => {"body": m.body ?? "", "date": m.date ?? DateTime.now(), "sender": m.address ?? ""}).toList();

      if (mounted) {
        if (rawMessages.isEmpty) {
          rawMessages = _generateCanaraMockData();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No real bank SMS found. Using Demo Data.")));
        }
        final userData = Provider.of<UserDataProvider>(context, listen: false);
        await userData.processParsedMessages(rawMessages);
        widget.onComplete();
      }
    } else if (status.isPermanentlyDenied) {
      setState(() => isScanning = false);
      if (mounted) openAppSettings();
    } else {
      setState(() => isScanning = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("SMS Permission required to scan transactions.")));
    }
  }

  List<Map<String, dynamic>> _generateCanaraMockData() {
    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month, 7);
    final startDate = DateTime(now.year, now.month - 3, 7);
    List<Map<String, dynamic>> messages = [];
    final random = Random();
    for (DateTime d = startDate; d.isBefore(endDate); d = d.add(const Duration(days: 1))) {
      if (d.day == 1) {
        messages.add({"date": d, "body": "Your a/c no. XX4567 has been credited with Rs.65,000.00 on ${d.day}/${d.month}/${d.year} from a/c no. XX0000 (UPI Ref no 123456)-Canara Bank"});
      }
      if (d.day == 5) {
        messages.add({"date": d, "body": "Rs.18000.00 paid thru A/C XX4567 on ${d.day}-${d.month}-${d.year % 100} 10:00:00 to LANDLORD RENT, UPI Ref 123456789. If not done, SMS BLOCKUPI to 9901771222.-Canara Bank"});
      }
      if (random.nextDouble() > 0.7) {
        int amount = 200 + random.nextInt(500);
        String merchant = ["SWIGGY", "ZOMATO", "UBER", "BLUESMART", "DOMINOS", "PETROL BUNK"][random.nextInt(6)];
        messages.add({"date": d, "body": "Rs.$amount.00 paid thru A/C XX4567 on ${d.day}-${d.month}-${d.year % 100} 14:30:00 to $merchant, UPI Ref 987654321. If not done, SMS BLOCKUPI to 9901771222.-Canara Bank"});
      }
    }
    return messages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFE07A5F), width: 3)), child: Center(child: isScanning ? const Icon(Icons.search, size: 80, color: Color(0xFFE07A5F)).animate(onPlay: (c) => c.repeat()).rotate() : const Icon(Icons.sms_outlined, size: 80, color: Colors.grey))),
              const SizedBox(height: 32),
              Text(isScanning ? "Maa is reading your SMS..." : "Allow Maa to read SMS?", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(isScanning ? "Extracting Canara Bank transaction history." : "We parse bank messages locally. No data leaves your phone.", textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              if (isScanning) LinearProgressIndicator(value: null, color: const Color(0xFFE07A5F)) else ElevatedButton.icon(onPressed: _startRealScan, icon: const Icon(Icons.check), label: const Text("Scan SMS Inbox"), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF264653), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 56))),
            ],
          ),
        ),
      ),
    );
  }
}