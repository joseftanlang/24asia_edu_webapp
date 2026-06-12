import 'package:flutter/material.dart';

import 'attendance_history_screen.dart';

class AttendanceDetailsScreen
    extends StatelessWidget {
  const AttendanceDetailsScreen(
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffF5F7FA),

      appBar: AppBar(
        title:
            const Text("Attendance Details"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),

            const SizedBox(height: 20),

            const Text(
              "Attendance Recorded",
              style: TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                        20),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(
                        20),
                child: Column(
                  children: const [

                    ListTile(
                      title: Text(
                          "Volunteer"),
                      trailing:
                          Text("Josef Tan"),
                    ),

                    Divider(),

                    ListTile(
                      title:
                          Text("Event"),
                      trailing: Text(
                          "Beach Cleanup"),
                    ),

                    Divider(),

                    ListTile(
                      title:
                          Text("Attendance ID"),
                      trailing: Text(
                          "ATT-2026-001"),
                    ),

                    Divider(),

                    ListTile(
                      title:
                          Text("Check In"),
                      trailing:
                          Text("08:05 AM"),
                    ),

                    Divider(),

                    ListTile(
                      title:
                          Text("Status"),
                      trailing:
                          Text("Active"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                        20),
              ),
              child: const Center(
                child: Icon(
                  Icons.qr_code_2,
                  size: 120,
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text(
                  "View History",
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const AttendanceHistoryScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                child: const Text(
                  "Back Dashboard",
                ),
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) =>
                        route.isFirst,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}