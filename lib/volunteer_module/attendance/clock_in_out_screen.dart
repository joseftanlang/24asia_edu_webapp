import 'package:flutter/material.dart';

import 'attendance_history_screen.dart';
import 'qr_scanner_screen.dart';

class ClockInOutScreen extends StatefulWidget {
  const ClockInOutScreen({super.key});

  @override
  State<ClockInOutScreen> createState() =>
      _ClockInOutScreenState();
}

class _ClockInOutScreenState
    extends State<ClockInOutScreen> {
  bool isCheckedIn = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    final isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor:
          const Color(0xffF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            const Color(0xff1565C0),
        title: const Text(
          "Attendance Center",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            //--------------------------------
            // STATUS CARD
            //--------------------------------

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(24),
                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xff1565C0),
                    Color(0xff42A5F5),
                  ],
                ),
              ),
              child: Column(
                children: [

                  CircleAvatar(
                    radius: 40,
                    backgroundColor:
                        Colors.white,
                    child: Icon(
                      isCheckedIn
                          ? Icons.check_circle
                          : Icons.pending,
                      size: 50,
                      color: isCheckedIn
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    isCheckedIn
                        ? "Checked In"
                        : "Not Checked In",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Beach Cleanup Program",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Community Park",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            //--------------------------------
            // STATS
            //--------------------------------

            isDesktop
                ? Row(
                    children: [
                      _statCard(
                        "42",
                        "Sessions",
                        Icons.event,
                      ),
                      _statCard(
                        "98%",
                        "Attendance",
                        Icons.analytics,
                      ),
                      _statCard(
                        "87",
                        "Hours",
                        Icons.timer,
                      ),
                      _statCard(
                        "12 Jun",
                        "Last Visit",
                        Icons.history,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          _statCard(
                            "42",
                            "Sessions",
                            Icons.event,
                          ),
                          _statCard(
                            "98%",
                            "Attendance",
                            Icons.analytics,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _statCard(
                            "87",
                            "Hours",
                            Icons.timer,
                          ),
                          _statCard(
                            "12 Jun",
                            "Last Visit",
                            Icons.history,
                          ),
                        ],
                      ),
                    ],
                  ),

            const SizedBox(height: 25),

            //--------------------------------
            // ACTION BUTTONS
            //--------------------------------

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon:
                    const Icon(Icons.qr_code),
                label: const Text(
                  "Scan QR To Clock In",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green,
                  foregroundColor:
                      Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const QRScannerScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.logout,
                ),
                label: const Text(
                  "Clock Out",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red,
                  foregroundColor:
                      Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isCheckedIn = false;
                  });

                  ScaffoldMessenger.of(
                          context)
                      .showSnackBar(
                    const SnackBar(
                      content:
                          Text("Clocked Out"),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            //--------------------------------
            // STREAK
            //--------------------------------

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                        20),
              ),
              child: Column(
                children: const [
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "12 Event Streak",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Keep participating to maintain your streak.",
                    textAlign:
                        TextAlign.center,
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            //--------------------------------
            // RECENT ATTENDANCE
            //--------------------------------

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                        20),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Recent Attendance",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  _attendanceTile(
                    "Beach Cleanup",
                    "12 June 2026",
                    "4 Hours",
                  ),

                  _attendanceTile(
                    "Food Distribution",
                    "10 June 2026",
                    "3 Hours",
                  ),

                  _attendanceTile(
                    "Tree Planting",
                    "08 June 2026",
                    "5 Hours",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            //--------------------------------
            // HISTORY BUTTON
            //--------------------------------

            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                icon:
                    const Icon(Icons.history),
                label: const Text(
                  "View Attendance History",
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
          ],
        ),
      ),
    );
  }

  Widget _attendanceTile(
    String title,
    String date,
    String hours,
  ) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.event),
      ),
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(hours),
    );
  }

  Widget _statCard(
    String value,
    String title,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        margin:
            const EdgeInsets.symmetric(
                horizontal: 5),
        padding:
            const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.blue,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}