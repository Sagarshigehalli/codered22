import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/utils.dart';
import 'payment_details.dart';

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white), elevation: 0),
      body: Stack(
        children: [
          Center(child: Container(width: 280, height: 280, decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE07A5F), width: 3), borderRadius: BorderRadius.circular(24)), child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.qr_code_2, size: 120, color: Colors.white24), SizedBox(height: 16), Text("Scanning...", style: TextStyle(color: Colors.white54, letterSpacing: 2))])).animate(onPlay: (c) => c.repeat(reverse: true)).boxShadow(duration: 1.seconds)),
          Align(alignment: Alignment.bottomCenter, child: Padding(padding: const EdgeInsets.all(40.0), child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), onPressed: () { Navigator.pushReplacement(context, MaaPageRoute(page: const PaymentDetailsPage())); }, child: const Text("Simulate QR Scan", style: TextStyle(fontWeight: FontWeight.bold))))),
        ],
      ),
    );
  }
}