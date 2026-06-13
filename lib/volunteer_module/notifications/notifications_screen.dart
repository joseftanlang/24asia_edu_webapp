import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _notifications = [
    {'icon': Icons.event, 'title': 'New Event Available', 'body': 'Beach Cleanup on 15 Jun', 'time': '2 min ago', 'read': false},
    {'icon': Icons.workspace_premium, 'title': 'Certificate Issued', 'body': 'Event Coordinator cert ready', 'time': '1 hr ago', 'read': false},
    {'icon': Icons.check_circle, 'title': 'Attendance Confirmed', 'body': 'Food Distribution – 10 Jun', 'time': '3 hrs ago', 'read': true},
    {'icon': Icons.school, 'title': 'Training Reminder', 'body': 'Complete First Aid Basics', 'time': 'Yesterday', 'read': true},
    {'icon': Icons.campaign, 'title': 'Announcement', 'body': 'Monthly volunteer meetup on 20 Jun', 'time': '2 days ago', 'read': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1565C0),
        title: const Text("Notifications", style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Mark all read", style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final n = _notifications[index];
          final isUnread = n['read'] == false;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: isUnread ? Colors.blue.shade50 : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: CircleAvatar(
                backgroundColor: isUnread ? Colors.blue.shade100 : Colors.grey.shade100,
                child: Icon(n['icon'] as IconData, color: isUnread ? Colors.blue : Colors.grey),
              ),
              title: Text(
                n['title'] as String,
                style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.normal),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(n['body'] as String),
                  const SizedBox(height: 2),
                  Text(n['time'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              trailing: isUnread
                  ? const CircleAvatar(radius: 5, backgroundColor: Colors.blue)
                  : null,
            ),
          );
        },
      ),
    );
  }
}
