import 'package:flutter/material.dart';

import 'attendance_details_screen.dart';

class AttendanceHistoryScreen
    extends StatelessWidget {
  const AttendanceHistoryScreen(
      {super.key});

  @override
  Widget build(BuildContext context) {
    final records = [
      {
        "event": "Beach Cleanup",
        "date": "12 Jun 2026",
        "hours": "4 Hours"
      },
      {
        "event": "Food Distribution",
        "date": "10 Jun 2026",
        "hours": "3 Hours"
      },
      {
        "event": "Tree Planting",
        "date": "08 Jun 2026",
        "hours": "5 Hours"
      },
      {
        "event": "Community Teaching",
        "date": "05 Jun 2026",
        "hours": "6 Hours"
      },
    ];

    return Scaffold(
      backgroundColor:
          const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text(
            "Attendance History"),
      ),

      body: Column(
        children: [

          Padding(
            padding:
                const EdgeInsets.all(16),
            child: TextField(
              decoration:
                  InputDecoration(
                hintText:
                    "Search Event...",
                prefixIcon:
                    const Icon(Icons.search),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          15),
                ),
              ),
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              children: [

                FilterChip(
                  label:
                      const Text("All"),
                  selected: true,
                  onSelected: (_) {},
                ),

                const SizedBox(width: 10),

                FilterChip(
                  label: const Text(
                      "Completed"),
                  selected: false,
                  onSelected: (_) {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: ListView.builder(
              itemCount: records.length,
              itemBuilder:
                  (context, index) {
                final item =
                    records[index];

                return Card(
                  margin:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading:
                        const CircleAvatar(
                      child:
                          Icon(Icons.event),
                    ),
                    title: Text(
                        item["event"]!),
                    subtitle: Text(
                        item["date"]!),
                    trailing: Text(
                        item["hours"]!),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AttendanceDetailsScreen(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}