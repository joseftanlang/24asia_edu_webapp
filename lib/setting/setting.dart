import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class SettingsScreens extends StatefulWidget {
  const SettingsScreens({super.key});

  @override
  State<SettingsScreens> createState() => _SettingsScreensState();
}

class _SettingsScreensState extends State<SettingsScreens> {
  bool darkMode = false;
  bool notifications = true;
  bool twoFactor = true;
  
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
                            color: Colors.blue,
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
                  SizedBox(
                    height: 400,
                    child: FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      front: _buildVolunteerCardFront(),
                      back: _buildVolunteerCardBack(),
                      flipOnTouch: true,
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Stats
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
                    height: 500,
                    child: FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      front: _buildPersonalInfoFront(),
                      back: _buildPersonalInfoBack(),
                      flipOnTouch: true,
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Skills
                  sectionTitle("Skills & Expertise", Icons.psychology),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      skillChip("Leadership"),
                      skillChip("First Aid"),
                      skillChip("Public Speaking"),
                      skillChip("Teaching"),
                      skillChip("Event Management"),
                      skillChip("Community Outreach"),
                      skillChip("Project Planning"),
                      skillChip("Fundraising"),
                    ],
                  ),
                  const SizedBox(height: 25),
                  
                  // Badges
                  sectionTitle("Achievements", Icons.emoji_events),
                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        badgeCard("Environmental Hero", Icons.eco, Colors.green),
                        badgeCard("100 Hours Club", Icons.star, Colors.orange),
                        badgeCard("Volunteer Mentor", Icons.school, Colors.blue),
                        badgeCard("Perfect Attendance", Icons.check_circle, Colors.purple),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Emergency Contact with Flip Card
                  sectionTitle("Emergency Contact", Icons.emergency),
                  SizedBox(
                    height: 350,
                    child: FlipCard(
                      direction: FlipDirection.VERTICAL,
                      front: _buildEmergencyFront(),
                      back: _buildEmergencyBack(),
                      flipOnTouch: true,
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Account Settings - FIXED: Using Container instead of DecoratedBox
                  sectionTitle("Account Settings", Icons.settings),
                  Container(
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
                      children: [
                        SwitchListTile(
                          value: notifications,
                          title: const Text("Notifications"),
                          subtitle: const Text("Receive alerts and updates"),
                          onChanged: (v) {
                            setState(() {
                              notifications = v;
                            });
                          },
                        ),
                        const Divider(),
                        SwitchListTile(
                          value: darkMode,
                          title: const Text("Dark Mode"),
                          subtitle: const Text("Toggle application theme"),
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
                  
                  // Privacy - FIXED
                  sectionTitle("Privacy & Security", Icons.security),
                  Container(
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
                      children: [
                        SwitchListTile(
                          value: twoFactor,
                          title: const Text("Two Factor Authentication"),
                          subtitle: const Text("Extra login protection"),
                          onChanged: (v) {
                            setState(() {
                              twoFactor = v;
                            });
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.devices),
                          title: const Text("Manage Devices"),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {},
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.history),
                          title: const Text("Login History"),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Support - FIXED
                  sectionTitle("Support Center", Icons.support_agent),
                  Container(
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
                      children: [
                        ListTile(
                          leading: const Icon(Icons.help),
                          title: const Text("FAQ"),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {},
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.mail),
                          title: const Text("Contact Us"),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {},
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.bug_report),
                          title: const Text("Report Problem"),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {},
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.description),
                          title: const Text("Terms & Conditions"),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Logout
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
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
  // VOLUNTEER CARD FRONT
  //--------------------------------
  Widget _buildVolunteerCardFront() {
    return Container(
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.volunteer_activism, color: Colors.white, size: 60),
            const SizedBox(height: 20),
            const Text(
              "JOSEF TAN",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Gold Volunteer • Level 8",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("187", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Hours", style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("42", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Events", style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("98%", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Rating", style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Tap to flip",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
  
  //--------------------------------
  // VOLUNTEER CARD BACK
  //--------------------------------
  Widget _buildVolunteerCardBack() {
    return Container(
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.qr_code, color: Colors.white, size: 80),
              const SizedBox(height: 20),
              const Text(
                "VOL-2026-0001",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _infoRow("Member Since", "January 2024"),
              _infoRow("Emergency Contact", "+65 91234567"),
              _infoRow("Blood Type", "O+"),
              const SizedBox(height: 20),
              const Text(
                "Tap to flip back",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  //--------------------------------
  // PERSONAL INFO FRONT
  //--------------------------------
  Widget _buildPersonalInfoFront() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person, color: Colors.blue, size: 30),
              SizedBox(width: 10),
              Text(
                "Basic Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _infoTile("User ID", "VOL-2026-0001"),
          _infoTile("Email", "josef@email.com"),
          _infoTile("Phone", "+65 91234567"),
          _infoTile("Blood Type", "O+"),
          const Spacer(),
          const Center(
            child: Text(
              "Tap to see more details",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
  
  //--------------------------------
  // PERSONAL INFO BACK
  //--------------------------------
  Widget _buildPersonalInfoBack() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info, color: Colors.blue, size: 30),
              SizedBox(width: 10),
              Text(
                "Additional Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _infoTile("Address", "Singapore"),
          _infoTile("IC Number", "S1234567A"),
          _infoTile("Occupation", "Software Engineer"),
          _infoTile("Birthday", "01 Jan 2000"),
          _infoTile("Race", "Chinese"),
          _infoTile("Citizenship", "Singaporean"),
          const Spacer(),
          const Center(
            child: Text(
              "Tap to flip back",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
  
  //--------------------------------
  // EMERGENCY FRONT
  //--------------------------------
  Widget _buildEmergencyFront() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 20),
          _contactTile("Contact Name", "Michael Tan"),
          _contactTile("Relationship", "Father"),
          _contactTile("Phone", "+65 91234567"),
          _contactTile("Address", "Singapore"),
          const Spacer(),
          const Center(
            child: Text(
              "Tap for secondary contact",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
  
  //--------------------------------
  // EMERGENCY BACK
  //--------------------------------
  Widget _buildEmergencyBack() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 20),
          _contactTile("Contact Name", "Sarah Tan"),
          _contactTile("Relationship", "Mother"),
          _contactTile("Phone", "+65 98765432"),
          _contactTile("Address", "Singapore"),
          const Spacer(),
          const Center(
            child: Text(
              "Tap to flip back",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
  
  //--------------------------------
  // HELPER WIDGETS
  //--------------------------------
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  
  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
  
  Widget _contactTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
  
  Widget sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(title),
        ],
      ),
    );
  }
  
  Widget skillChip(String skill) {
    return Chip(
      label: Text(skill),
      avatar: const Icon(Icons.star, size: 18),
    );
  }
  
  Widget badgeCard(String title, IconData icon, Color color) {
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
          CircleAvatar(
            radius: 35,
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}