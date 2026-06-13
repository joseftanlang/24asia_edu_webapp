import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1565C0),
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit profile coming soon')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xff1565C0), Color(0xff42A5F5)]),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 56, color: Colors.blue),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Volunteer Name",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text("volunteer@email.com", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Chip(
                    label: const Text("Active Volunteer", style: TextStyle(color: Colors.white, fontSize: 12)),
                    backgroundColor: Colors.green.shade600,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _infoCard([
                    _infoTile(Icons.phone, "Phone", "+60 12-345 6789"),
                    _infoTile(Icons.location_on, "Location", "Kuala Lumpur, Malaysia"),
                    _infoTile(Icons.cake, "Member Since", "January 2026"),
                  ]),
                  const SizedBox(height: 12),
                  _infoCard([
                    _infoTile(Icons.timer, "Total Hours", "87 hrs"),
                    _infoTile(Icons.event, "Events Joined", "12"),
                    _infoTile(Icons.workspace_premium, "Certificates", "5"),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
      ),
      child: Column(children: children),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
