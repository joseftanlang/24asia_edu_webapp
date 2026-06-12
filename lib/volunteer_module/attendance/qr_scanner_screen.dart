import 'package:flutter/material.dart';

import 'attendance_details_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() =>
      _QRScannerScreenState();
}

class _QRScannerScreenState
    extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _confirmAttendance() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const AttendanceDetailsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("QR Scanner"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),

          const Text(
            "Scan Event QR Code",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Position QR inside frame",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 40),

          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [

                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                  ),

                  AnimatedBuilder(
                    animation: controller,
                    builder: (_, child) {
                      return Positioned(
                        top:
                            controller.value *
                                250,
                        child: Container(
                          width: 250,
                          height: 3,
                          color: Colors.green,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          Container(
            margin:
                const EdgeInsets.all(20),
            padding:
                const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(
                      20),
            ),
            child: Column(
              children: [

                const ListTile(
                  leading:
                      Icon(Icons.event),
                  title: Text(
                      "Beach Cleanup"),
                  subtitle: Text(
                      "15 June 2026"),
                ),

                const ListTile(
                  leading:
                      Icon(Icons.place),
                  title:
                      Text("Community Park"),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _confirmAttendance,
                    child: const Text(
                      "Confirm Attendance",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}