import 'package:flutter/material.dart';

class VolunteerHomeScreen extends StatefulWidget {
  const VolunteerHomeScreen({super.key});

  @override
  State<VolunteerHomeScreen> createState() => _VolunteerHomeScreenState();
}

class _VolunteerHomeScreenState extends State<VolunteerHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0.9, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(colors: [color.withOpacity(.9), color]),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 42, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1565C0),
        title: const Text(
          "Volunteer Portal",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff1565C0), Color(0xff42A5F5)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Welcome Back 👋",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Ready to make an impact today?",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  statCard("Hours", "87", Icons.timer),
                  statCard("Events", "12", Icons.event),
                  statCard("Certs", "5", Icons.workspace_premium),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.15,
                children: [
                  buildMenuCard(
                    icon: Icons.dashboard,
                    title: "Dashboard",
                    subtitle: "Overview & Analytics",
                    color: Colors.blue,
                    onTap: () {},
                  ),

                  buildMenuCard(
                    icon: Icons.event,
                    title: "Browse Events",
                    subtitle: "Upcoming Opportunities",
                    color: Colors.green,
                    onTap: () {},
                  ),

                  buildMenuCard(
                    icon: Icons.qr_code_scanner,
                    title: "Clock In",
                    subtitle: "Attendance Tracking",
                    color: Colors.orange,
                    onTap: () {},
                  ),

                  buildMenuCard(
                    icon: Icons.school_outlined,
                    title: "Training",
                    subtitle: "Courses & Learning",
                    color: Colors.purple,
                    onTap: () {},
                  ),

                  buildMenuCard(
                    icon: Icons.workspace_premium,
                    title: "Certificates",
                    subtitle: "Achievements",
                    color: Colors.teal,
                    onTap: () {},
                  ),

                  buildMenuCard(
                    icon: Icons.badge_outlined,
                    title: "Digital ID",
                    subtitle: "Volunteer Identity",
                    color: Colors.red,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Recent Activity",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 15),

                  ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text("Joined Beach Cleanup"),
                    subtitle: Text("2 hours ago"),
                  ),

                  ListTile(
                    leading: Icon(Icons.school, color: Colors.blue),
                    title: Text("Completed Orientation"),
                    subtitle: Text("Yesterday"),
                  ),

                  ListTile(
                    leading: Icon(Icons.card_giftcard, color: Colors.orange),
                    title: Text("Earned Volunteer Badge"),
                    subtitle: Text("Last week"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
