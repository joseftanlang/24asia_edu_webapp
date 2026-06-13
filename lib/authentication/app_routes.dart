import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool notifications = true;
  bool twoFactor = true;
  String selectedLanguage = 'English';
  String selectedTheme = 'Light';
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xff1565C0),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff1565C0), Color(0xff42A5F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Hero(
                        tag: "profile",
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Josef Tan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Gold Volunteer",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Volunteer Level 8",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: LinearProgressIndicator(
                          value: .80,
                          minHeight: 12,
                          borderRadius: BorderRadius.circular(20),
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "80% Progress to Level 9",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Volunteer ID Card with Flip
                  volunteerIdCard(isDesktop),
                  const SizedBox(height: 25),
                  
                  // Stats Section
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isDesktop ? 4 : 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      statCard("187", "Hours", Icons.timer, Colors.orange),
                      statCard("42", "Events", Icons.event, Colors.green),
                      statCard("15", "Certificates", Icons.workspace_premium, Colors.purple),
                      statCard("98%", "Attendance", Icons.analytics, Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 25),
                  
                  // Personal Information with Flip Card
                  sectionTitle("Personal Information", Icons.person),
                  SizedBox(
                    height: 520, // Fixed height to prevent unbounded constraints
                    child: FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      front: personalInfoFront(),
                      back: personalInfoBack(),
                      speed: 500,
                      flipOnTouch: true,
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Skills Section
                  sectionTitle("Skills & Expertise", Icons.psychology),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      skillChip("Leadership", Colors.blue),
                      skillChip("First Aid", Colors.red),
                      skillChip("Public Speaking", Colors.orange),
                      skillChip("Teaching", Colors.green),
                      skillChip("Event Management", Colors.purple),
                      skillChip("Community Outreach", Colors.teal),
                      skillChip("Project Planning", Colors.indigo),
                      skillChip("Fundraising", Colors.pink),
                    ],
                  ),
                  const SizedBox(height: 25),
                  
                  // Badges Section
                  sectionTitle("Achievements", Icons.emoji_events),
                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        badgeCard("Environmental Hero", Icons.eco, Colors.green, "Plant 100 trees"),
                        badgeCard("100 Hours Club", Icons.star, Colors.orange, "Completed 100+ hours"),
                        badgeCard("Volunteer Mentor", Icons.school, Colors.blue, "Mentored 20+ juniors"),
                        badgeCard("Perfect Attendance", Icons.check_circle, Colors.purple, "No absences in 6 months"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Emergency Contact with Flip Card
                  sectionTitle("Emergency Contact", Icons.emergency),
                  SizedBox(
                    height: 350, // Fixed height for emergency contact
                    child: FlipCard(
                      direction: FlipDirection.VERTICAL,
                      front: emergencyContactFront(),
                      back: emergencyContactBack(),
                      speed: 500,
                      flipOnTouch: true,
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Account Settings - Fixed ListTile Material issue
                  sectionTitle("Account Settings", Icons.settings),
                  Material(
                    elevation: 0,
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: notifications,
                          title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: const Text("Receive alerts and updates"),
                          secondary: Icon(Icons.notifications, color: notifications ? Colors.blue : Colors.grey),
                          onChanged: (v) {
                            setState(() {
                              notifications = v;
                            });
                          },
                        ),
                        const Divider(),
                        SwitchListTile(
                          value: darkMode,
                          title: const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: const Text("Toggle application theme"),
                          secondary: Icon(Icons.dark_mode, color: darkMode ? Colors.blue : Colors.grey),
                          onChanged: (v) {
                            setState(() {
                              darkMode = v;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Privacy Section
                  sectionTitle("Privacy & Security", Icons.security),
                  Material(
                    elevation: 0,
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: twoFactor,
                          title: const Text("Two Factor Authentication", style: TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: const Text("Extra login protection"),
                          secondary: Icon(Icons.security, color: twoFactor ? Colors.blue : Colors.grey),
                          onChanged: (v) {
                            setState(() {
                              twoFactor = v;
                            });
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.devices, color: Colors.blue),
                          title: const Text("Manage Devices", style: TextStyle(fontWeight: FontWeight.w500)),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {},
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.history, color: Colors.blue),
                          title: const Text("Login History", style: TextStyle(fontWeight: FontWeight.w500)),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Support Section
                  sectionTitle("Support Center", Icons.support_agent),
                  Material(
                    elevation: 0,
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    child: Column(
                      children: [
                        supportTile(Icons.help, "FAQ", Colors.blue),
                        supportTile(Icons.mail, "Contact Us", Colors.green),
                        supportTile(Icons.bug_report, "Report Problem", Colors.orange),
                        supportTile(Icons.description, "Terms & Conditions", Colors.purple),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout", style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  //--------------------------------
  // VOLUNTEER ID CARD WITH FLIP
  //--------------------------------
  Widget volunteerIdCard(bool isDesktop) {
    return SizedBox(
      height: 380,
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        front: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff1565C0), Color(0xff2196F3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.volunteer_activism, color: Colors.blue, size: 30),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Active",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.blue),
              ),
              const SizedBox(height: 15),
              const Text(
                "JOSEF TAN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Gold Volunteer",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIdDetail("ID: VOL-2026-0001", Icons.qr_code),
                  const SizedBox(width: 15),
                  _buildIdDetail("Level: 8", Icons.arrow_upward),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSmallStat("Hours", "187"),
                    _buildSmallStat("Events", "42"),
                    _buildSmallStat("Rating", "4.9"),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tap to flip for more details",
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ),
        back: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff0D47A1), Color(0xff1565C0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
                  const Spacer(),
                  Icon(Icons.volunteer_activism, color: Colors.white70),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Member Since",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const Text(
                "January 2024",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                "Next Review Date",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const Text(
                "January 2025",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Divider(color: Colors.white24),
              const SizedBox(height: 10),
              const Text(
                "Emergency Contact: +65 91234567",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              const Text(
                "Blood Type: O+",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              const Spacer(),
              const Text(
                "Tap to flip back",
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ),
        speed: 500,
        flipOnTouch: true,
      ),
    );
  }
  
  //--------------------------------
  // PERSONAL INFO FRONT
  //--------------------------------
  Widget personalInfoFront() {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blue, size: 30),
                const SizedBox(width: 10),
                const Text(
                  "Basic Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("Tap to edit", style: TextStyle(fontSize: 12, color: Colors.blue)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildInfoRow("User ID", "VOL-2026-0001", Icons.qr_code),
            const SizedBox(height: 12),
            _buildInfoRow("Email", "josef.tan@email.com", Icons.email),
            const SizedBox(height: 12),
            _buildInfoRow("Phone Number", "+65 91234567", Icons.phone),
            const SizedBox(height: 12),
            _buildInfoRow("Blood Type", "O+", Icons.bloodtype),
            const SizedBox(height: 20),
            const Text(
              "✨ Tap anywhere to view more details",
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  //--------------------------------
  // PERSONAL INFO BACK
  //--------------------------------
  Widget personalInfoBack() {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.info, color: Colors.blue, size: 30),
                const SizedBox(width: 10),
                const Text(
                  "Additional Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(Icons.edit_note, color: Colors.blue.shade300),
              ],
            ),
            const SizedBox(height: 15),
            _buildInfoRow("Address", "Singapore", Icons.home),
            const SizedBox(height: 12),
            _buildInfoRow("IC Number", "S1234567A", Icons.badge),
            const SizedBox(height: 12),
            _buildInfoRow("Occupation", "Software Engineer", Icons.work),
            const SizedBox(height: 12),
            _buildInfoRow("Birthday", "01 Jan 2000", Icons.cake),
            const SizedBox(height: 12),
            _buildInfoRow("Race", "Chinese", Icons.diversity_3),
            const SizedBox(height: 12),
            _buildInfoRow("Religion", "Buddhist", Icons.church),
            const SizedBox(height: 12),
            _buildInfoRow("Citizenship", "Singaporean", Icons.flag),
            const SizedBox(height: 15),
            const Text(
              "👆 Tap to flip back",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
  
  //--------------------------------
  // EMERGENCY CONTACT FRONT
  //--------------------------------
  Widget emergencyContactFront() {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Icon(Icons.emergency, color: Colors.red, size: 30),
                SizedBox(width: 10),
                Text(
                  "Primary Contact",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildContactRow(Icons.person, "Contact Name", "Michael Tan"),
            const SizedBox(height: 12),
            _buildContactRow(Icons.people, "Relationship", "Father"),
            const SizedBox(height: 12),
            _buildContactRow(Icons.phone, "Phone", "+65 91234567"),
            const SizedBox(height: 12),
            _buildContactRow(Icons.home, "Address", "Singapore"),
            const SizedBox(height: 20),
            const Text(
              "🚨 Tap for secondary contact",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
  
  //--------------------------------
  // EMERGENCY CONTACT BACK
  //--------------------------------
  Widget emergencyContactBack() {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Icon(Icons.emergency, color: Colors.orange, size: 30),
                SizedBox(width: 10),
                Text(
                  "Secondary Contact",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildContactRow(Icons.person, "Contact Name", "Sarah Tan"),
            const SizedBox(height: 12),
            _buildContactRow(Icons.people, "Relationship", "Mother"),
            const SizedBox(height: 12),
            _buildContactRow(Icons.phone, "Phone", "+65 98765432"),
            const SizedBox(height: 12),
            _buildContactRow(Icons.home, "Address", "Singapore"),
            const SizedBox(height: 20),
            const Text(
              "👆 Tap to flip back",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
  
  //--------------------------------
  // HELPER WIDGETS
  //--------------------------------
  Widget _buildIdDetail(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
  
  Widget _buildSmallStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
  
  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade400),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ),
        Expanded(
          flex: 3,
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ),
      ],
    );
  }
  
  Widget _buildContactRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade400, size: 24),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue.shade700, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff1a1a2e)),
          ),
        ],
      ),
    );
  }
  
  Widget statCard(String value, String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff1a1a2e)),
          ),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
  
  Widget skillChip(String skill, Color color) {
    return Chip(
      label: Text(skill),
      avatar: Icon(Icons.star, size: 18, color: color),
      backgroundColor: color.withOpacity(.1),
      labelStyle: TextStyle(color: color),
      side: BorderSide.none,
    );
  }
  
  Widget badgeCard(String title, IconData icon, Color color, String description) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget supportTile(IconData icon, String title, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }
  
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
                // Add logout logic here
              },
              child: const Text("Logout", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}