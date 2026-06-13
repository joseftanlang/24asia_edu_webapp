import 'package:flutter/material.dart';

class EventsListScreen extends StatelessWidget {
  const EventsListScreen({super.key});

  static const _events = [
    {'title': 'Beach Cleanup', 'date': '15 Jun 2026', 'location': 'Community Park', 'spots': '8 spots left'},
    {'title': 'Food Distribution', 'date': '18 Jun 2026', 'location': 'City Hall', 'spots': '3 spots left'},
    {'title': 'Tree Planting', 'date': '22 Jun 2026', 'location': 'Riverside', 'spots': '12 spots left'},
    {'title': 'Community Teaching', 'date': '25 Jun 2026', 'location': 'School Hall A', 'spots': '5 spots left'},
    {'title': 'Senior Care Visit', 'date': '28 Jun 2026', 'location': 'Sunrise Home', 'spots': '6 spots left'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1565C0),
        title: const Text("Browse Events", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search events...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final e = _events[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: const Icon(Icons.event, color: Colors.green),
                    ),
                    title: Text(e['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(e['date']!),
                        Text(e['location']!, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(e['spots']!, style: const TextStyle(fontSize: 11)),
                      backgroundColor: Colors.green.shade50,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening ${e['title']}...')),
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
