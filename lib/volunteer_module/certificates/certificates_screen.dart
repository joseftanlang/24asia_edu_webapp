import 'package:flutter/material.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  static const _certs = [
    {'title': 'Volunteer Orientation', 'date': 'Jan 2026', 'issuer': '24 Asia Foundation'},
    {'title': 'First Aid Basics', 'date': 'Mar 2026', 'issuer': 'Red Cross'},
    {'title': 'Beach Cleanup Leadership', 'date': 'Apr 2026', 'issuer': '24 Asia Foundation'},
    {'title': 'Community Hero Award', 'date': 'May 2026', 'issuer': 'City Council'},
    {'title': 'Event Coordinator', 'date': 'Jun 2026', 'issuer': '24 Asia Foundation'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1565C0),
        title: const Text("Certificates", style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _certs.length,
        itemBuilder: (context, index) {
          final c = _certs[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                child: const Icon(Icons.workspace_premium, color: Colors.teal),
              ),
              title: Text(c['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text("Issued: ${c['date']}"),
                  Text(c['issuer']!, style: const TextStyle(color: Colors.grey)),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.download_outlined, color: Colors.teal),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Downloading ${c['title']}...')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
