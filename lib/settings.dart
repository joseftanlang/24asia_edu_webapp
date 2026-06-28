import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
//import './database/firebase_handler.dart';
import './database/postgres_wrapper.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isLoading = true;

  // Editing state variables
  String _editEmail = '';
  String _editPhone = '';
  String _editBloodType = '';

  // State variables for fetched data
  String volunteerName = 'JOSEF TAN';
  String role = 'Gold Volunteer';
  String volunteerId = 'VOL-2026-0001';
  int level = 8;
  String memberSince = 'January 2024';
  String nextReviewDate = 'January 2025';

  int hours = 187;
  int events = 42;
  int certificates = 15;
  int attendance = 98;

  String email = 'josef.tan@email.com';
  String phone = '+65 91234567';
  String bloodType = 'O+';
  String address = 'Singapore';
  String icNumber = 'S1234567A';
  String occupation = 'Software Engineer';
  String birthday = '01 Jan 2000';
  String race = 'Chinese';
  String religion = 'Buddhist';
  String citizenship = 'Singaporean';

  // Primary Contact
  String primaryContactName = 'Michael Tan';
  String primaryContactRelationship = 'Father';
  String primaryContactPhone = '+65 91234567';
  String primaryContactAddress = 'Singapore';

  // Secondary Contact
  String secondaryContactName = 'Sarah Tan';
  String secondaryContactRelationship = 'Mother';
  String secondaryContactPhone = '+65 98765432';
  String secondaryContactAddress = 'Singapore';

  bool notifications = true;
  bool darkMode = false;
  bool twoFactor = true;

  List<String> skills = [];
  /*  'Leadership',
    'First Aid',
    'Public Speaking',
    'Teaching',
    'Event Management',
    'Community Outreach',
    'Project Planning',
    'Fundraising',
  ];*/
  List<Color> skillColors = [];
  List<String> badges = [];
  List<Map<String, dynamic>> badgeDetails = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    debugPrint("FETCHING SETTINGS");
    final data = await HybridDatabaseHandler.instance
        .fetchOrCreateUserSettings();
    debugPrint("FETCHED SETTINGS");
    if (data != null && mounted) {
      //debugPrint("FULLNAME");
      //debugPrint(data['fullName']);
      setState(() {
        volunteerName = data['fullName']?.toString() ?? 'Not set';
        role = data['role']?.toString() ?? 'Not set';
        volunteerId = data['volunteerId']?.toString() ?? 'Not set';
        level = (data['level'] as num?)?.toInt() ?? 0;
        memberSince = data['memberSince']?.toString() ?? 'Not set';
        nextReviewDate = data['nextReviewDate']?.toString() ?? 'Not set';

        hours = (data['hours'] as num?)?.toInt() ?? 0;
        events = (data['events'] as num?)?.toInt() ?? 0;
        certificates = (data['certificates'] as num?)?.toInt() ?? 0;
        attendance = (data['attendance'] as num?)?.toInt() ?? 0;

        email = data['email']?.toString() ?? 'Not set';
        phone = data['mobile']?.toString() ?? 'Not set';
        bloodType = data['bloodGroup']?.toString() ?? 'Not set';
        address = data['address']?.toString() ?? 'Not set';
        icNumber = data['icNumber']?.toString() ?? 'Not set';
        occupation = data['occupation']?.toString() ?? 'Not set';
        birthday = data['birthday']?.toString() ?? 'Not set';
        race = data['race']?.toString() ?? 'Not set';
        religion = data['religion']?.toString() ?? 'Not set';
        citizenship = data['citizenship']?.toString() ?? 'Not set';

        primaryContactName =
            data['primaryContactName']?.toString() ?? 'Not set';
        primaryContactRelationship =
            data['primaryContactRelationship']?.toString() ?? 'Not set';
        primaryContactPhone =
            data['primaryContactPhone']?.toString() ?? 'Not set';
        primaryContactAddress =
            data['primaryContactAddress']?.toString() ?? 'Not set';

        secondaryContactName =
            data['secondaryContactName']?.toString() ?? 'Not set';
        secondaryContactRelationship =
            data['secondaryContactRelationship']?.toString() ?? 'Not set';
        secondaryContactPhone =
            data['secondaryContactPhone']?.toString() ?? 'Not set';
        secondaryContactAddress =
            data['secondaryContactAddress']?.toString() ?? 'Not set';

        notifications = data['notifications'] as bool? ?? true;
        darkMode = data['darkMode'] as bool? ?? false;
        twoFactor = data['twoFactorAuth'] as bool? ?? true;

        skills = List<String>.from(data['skills'] as List? ?? []);
        badges = List<String>.from(data['badges'] as List? ?? []);

        /*volunteerName = data['fullName'] ?? 'JOSEF TAN';
        role = data['role'] ?? 'Gold Volunteer';
        volunteerId = data['volunteerId'] ?? 'VOL-2026-0001';
        level = data['level'] ?? 8;
        memberSince = data['memberSince'] ?? 'January 2024';
        nextReviewDate = data['nextReviewDate'] ?? 'January 2025';

        hours = data['hours'] ?? 187;
        events = data['events'] ?? 42;
        certificates = data['certificates'] ?? 15;
        attendance = data['attendance'] ?? 98;

        email = data['email'] ?? 'josef.tan@email.com';
        phone = data['primaryContactPhone'] ?? '+65 91234567';
        bloodType = data['bloodGroup'] ?? 'O+';
        address = data['address'] ?? 'Singapore';
        icNumber = data['icNumber'] ?? 'S1234567A';
        occupation = data['occupation'] ?? 'Software Engineer';
        birthday = data['birthday'] ?? '01 Jan 2000';
        race = data['race'] ?? 'Chinese';
        religion = data['religion'] ?? 'Buddhist';
        citizenship = data['citizenship'] ?? 'Singaporean';

        primaryContactName = data['primaryContactName'] ?? 'Michael Tan';
        primaryContactRelationship =
            data['primaryContactRelationship'] ?? 'Father';
        primaryContactPhone = data['primaryContactPhone'] ?? '+65 91234567';
        primaryContactAddress = data['primaryContactAddress'] ?? 'Singapore';

        secondaryContactName = data['secondaryContactName'] ?? 'Sarah Tan';
        secondaryContactRelationship =
            data['secondaryContactRelationship'] ?? 'Mother';
        secondaryContactPhone = data['secondaryContactPhone'] ?? '+65 98765432';
        secondaryContactAddress =
            data['secondaryContactAddress'] ?? 'Singapore';

        notifications = data['notifications'] ?? true;
        darkMode = data['darkMode'] ?? false;
        twoFactor = data['twoFactorAuth'] ?? true;

        skills = List<String>.from(data['skills'] ?? skills);
        badges = List<Map<String, dynamic>>.from(data['badges'] ?? []);*/
      });
      // badges to badgedetails
      await _badgesToDetails();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _badgesToDetails() async {
    try {
      // 1. Create a list of Futures by mapping over your string IDs
      final List<Future<Map<String, dynamic>>> futuresList = badges.map((
        achid,
      ) async {
        return await HybridDatabaseHandler.instance.getAchievementInfo(achid);
      }).toList();

      // 2. Fire all network requests at the same time and wait for them all to finish
      final List<Map<String, dynamic>> rawResults = await Future.wait(
        futuresList,
      );

      // 3. Filter out any null maps (in case an ID didn't exist in Firebase)
      /*final List<Map<String, dynamic>> cleanDetails = rawResults
          .where((badge) => badge != null)
          .cast<Map<String, dynamic>>()
          .toList();*/

      debugPrint("BADGEDETAILS");
      debugPrint(badgeDetails.toString());

      setState(() {
        badgeDetails = rawResults;
      });
    } catch (e) {
      debugPrint("Failed to load badge details: $e");
    }
  }

  Future<void> _skillsToColors() async {
    try {
      // 1. Create a list of Futures by mapping over your string IDs
      final List<Future<Color>> futuresList = skills.map((s) async {
        return await HybridDatabaseHandler.instance.getSkillColor(s);
      }).toList();

      // 2. Fire all network requests at the same time and wait for them all to finish
      final List<Color> rawResults = await Future.wait(futuresList);

      // 3. Filter out any null maps (in case an ID didn't exist in Firebase)
      /*final List<Map<String, dynamic>> cleanDetails = rawResults
          .where((badge) => badge != null)
          .cast<Map<String, dynamic>>()
          .toList();*/

      debugPrint("BADGEDETAILS");
      debugPrint(badgeDetails.toString());

      setState(() {
        skillColors = rawResults;
      });
    } catch (e) {
      debugPrint("Failed to load badge details: $e");
    }
  }

  // Opens the edit dialog
  void _openEditBasicInfoDialog() {
    setState(() {
      _editEmail = email;
      _editPhone = phone;
      _editBloodType = bloodType;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Edit Basic Information"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: _editEmail),
                decoration: const InputDecoration(labelText: "Email"),
                onChanged: (val) => _editEmail = val,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: TextEditingController(text: _editPhone),
                decoration: const InputDecoration(labelText: "Phone Number"),
                onChanged: (val) => _editPhone = val,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: TextEditingController(text: _editBloodType),
                decoration: const InputDecoration(labelText: "Blood Type"),
                onChanged: (val) => _editBloodType = val,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(onPressed: _saveBasicInfo, child: const Text("Save")),
        ],
      ),
    );
  }

  // Saves to Firebase & updates local state
  Future<void> _saveBasicInfo() async {
    if (_editEmail.isEmpty || _editPhone.isEmpty || _editBloodType.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("All fields are required")));
      return;
    }

    try {
      // Update local state
      debugPrint(
        "$email $_editEmail $phone $_editPhone $bloodType $_editBloodType",
      );
      setState(() {
        email = _editEmail;
        phone = _editPhone;
        bloodType = _editBloodType;
      });

      // Save to Firebase
      await HybridDatabaseHandler.instance.updateSetting('email', _editEmail);
      await HybridDatabaseHandler.instance.updateSetting('mobile', _editPhone);
      await HybridDatabaseHandler.instance.updateSetting(
        'bloodGroup',
        _editBloodType,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Basic info updated successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          volunteerIdCard(
            isDesktop,
            volunteerName,
            role,
            volunteerId,
            level,
            memberSince,
            nextReviewDate,
            bloodType,
          ),
          const SizedBox(height: 25),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isDesktop ? 4 : 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              statCard(hours.toString(), "Hours", Icons.timer, Colors.orange),
              statCard(events.toString(), "Events", Icons.event, Colors.green),
              statCard(
                certificates.toString(),
                "Certificates",
                Icons.workspace_premium,
                Colors.purple,
              ),
              statCard(
                "$attendance%",
                "Attendance",
                Icons.analytics,
                Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 25),

          sectionTitle("Personal Information", Icons.person),
          Center(
            //height: 520,
            child: FlipCard(
              direction: FlipDirection.HORIZONTAL,
              front: personalInfoFront(
                Theme.of(context).secondaryHeaderColor,
                volunteerId,
                email,
                phone,
                bloodType,
                address,
                icNumber,
                occupation,
                birthday,
                race,
                religion,
                citizenship,
                () => _openEditBasicInfoDialog(),
              ),
              back: personalInfoBack(
                Theme.of(context).secondaryHeaderColor,
                address,
                icNumber,
                occupation,
                birthday,
                race,
                religion,
                citizenship,
              ),
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
            children: skills.isEmpty
                ? [const Chip(label: Text("No skills added"))]
                : [
                    for (int i = 0; i < skills.length; i++)
                      skillChip(skills[i], skillColors[i]),
                  ],
            //: skills.map((skill) => skillChip(skill, Colors.blue)).toList(),
          ),
          const SizedBox(height: 25),

          sectionTitle("Achievements", Icons.emoji_events),
          SizedBox(
            height: 180,
            child: badgeDetails.isEmpty
                ? const Center(child: Text("No achievements yet"))
                : ListView(
                    scrollDirection: Axis.horizontal,
                    children: badgeDetails.map((badge) {
                      return badgeCard(
                        badge['title'] as String? ?? '',
                        badge['icon'] ?? Icons.star,
                        badge['color'] ?? Colors.orange,
                        badge['description'] as String? ?? '',
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 25),

          sectionTitle("Emergency Contact", Icons.emergency),
          Center(
            //height: 350,
            child: FlipCard(
              direction: FlipDirection.VERTICAL,
              front: emergencyContactFront(
                Theme.of(context).secondaryHeaderColor,
                primaryContactName,
                primaryContactRelationship,
                primaryContactPhone,
                primaryContactAddress,
              ),
              back: emergencyContactBack(
                Theme.of(context).secondaryHeaderColor,
                secondaryContactName,
                secondaryContactRelationship,
                secondaryContactPhone,
                secondaryContactAddress,
              ),
              speed: 500,
              flipOnTouch: true,
            ),
          ),
          const SizedBox(height: 25),

          sectionTitle("Account Settings", Icons.settings),
          Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                SwitchListTile(
                  value: notifications,
                  title: const Text(
                    "Notifications",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text("Receive alerts and updates"),
                  secondary: Icon(
                    Icons.notifications,
                    color: notifications ? Colors.blue : Colors.grey,
                  ),
                  onChanged: (v) {
                    setState(() => notifications = v);
                    HybridDatabaseHandler.instance.updateSetting(
                      'notifications',
                      v,
                    );
                  },
                ),
                const Divider(),
                SwitchListTile(
                  value: darkMode,
                  title: const Text(
                    "Dark Mode",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text("Toggle application theme"),
                  secondary: Icon(
                    Icons.dark_mode,
                    color: darkMode ? Colors.blue : Colors.grey,
                  ),
                  onChanged: (v) {
                    setState(() => darkMode = v);
                    HybridDatabaseHandler.instance.updateSetting('darkMode', v);
                  },
                ),
                const Divider(),
                SwitchListTile(
                  value: twoFactor,
                  title: const Text(
                    "Two Factor Authentication",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text("Extra login protection"),
                  secondary: Icon(
                    Icons.security,
                    color: twoFactor ? Colors.blue : Colors.grey,
                  ),
                  onChanged: (v) {
                    setState(() => twoFactor = v);
                    HybridDatabaseHandler.instance.updateSetting(
                      'twoFactorAuth',
                      v,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          sectionTitle("Support Center", Icons.support_agent),
          Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                supportTile(Icons.help, "FAQ", Colors.blue),
                supportTile(Icons.mail, "Contact Us", Colors.green),
                supportTile(Icons.bug_report, "Report Problem", Colors.orange),
                supportTile(
                  Icons.description,
                  "Terms & Conditions",
                  Colors.purple,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          /*SizedBox(
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
              onPressed: () => _showLogoutDialog(context),
            ),
          ),
          const SizedBox(height: 50),*/
        ],
      ),
    );
  }
}

Widget volunteerIdCard(
  bool isDesktop,
  String name,
  String role,
  String volId,
  int level,
  String memberSince,
  String nextReview,
  String bloodType,
) {
  debugPrint("START");
  debugPrint(name);
  debugPrint(role);
  debugPrint(volId);
  debugPrint(level.toString());
  debugPrint(memberSince);
  debugPrint(nextReview);
  debugPrint(bloodType);
  debugPrint("END");
  return SizedBox(
    height: 380,
    child: FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 60, 122, 193),
              Color.fromARGB(255, 112, 177, 230),
            ],
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
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.volunteer_activism,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Active",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
            Text(
              name.toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              role,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIdDetail("ID: $volId", Icons.qr_code),
                const SizedBox(width: 15),
                _buildIdDetail("Level: $level", Icons.arrow_upward),
              ],
            ),
            const SizedBox(height: 20),
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
                const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 30,
                ),
                const Spacer(),
                Icon(Icons.volunteer_activism, color: Colors.white70),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Member Since",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              memberSince,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Next Review Date",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              nextReview,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Divider(color: Colors.white24),
            const SizedBox(height: 10),
            Text(
              "Blood Type: $bloodType",
              style: const TextStyle(color: Colors.white, fontSize: 13),
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

Widget personalInfoFront(
  Color bgc,
  String volId,
  String email,
  String phone,
  String blood,
  String addr,
  String ic,
  String occ,
  String bday,
  String race,
  String rel,
  String cit,
  VoidCallback onEdit,
) {
  return Material(
    elevation: 0,
    borderRadius: BorderRadius.circular(20),
    color: bgc,
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
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
                tooltip: "Edit Basic Info",
              ),
              /*Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Tap to edit",
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),*/
            ],
          ),
          const SizedBox(height: 15),
          _buildInfoRow("User ID", volId, Icons.qr_code),
          const SizedBox(height: 12),
          _buildInfoRow("Email", email, Icons.email),
          const SizedBox(height: 12),
          _buildInfoRow("Phone Number", phone, Icons.phone),
          const SizedBox(height: 12),
          _buildInfoRow("Blood Type", blood, Icons.bloodtype),
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

Widget personalInfoBack(
  Color bgc,
  String addr,
  String ic,
  String occ,
  String bday,
  String race,
  String rel,
  String cit,
) {
  return Material(
    elevation: 0,
    borderRadius: BorderRadius.circular(20),
    color: bgc,
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
          _buildInfoRow("Address", addr, Icons.home),
          const SizedBox(height: 12),
          _buildInfoRow("IC Number", ic, Icons.badge),
          const SizedBox(height: 12),
          _buildInfoRow("Occupation", occ, Icons.work),
          const SizedBox(height: 12),
          _buildInfoRow("Birthday", bday, Icons.cake),
          const SizedBox(height: 12),
          _buildInfoRow("Race", race, Icons.diversity_3),
          const SizedBox(height: 12),
          _buildInfoRow("Religion", rel, Icons.church),
          const SizedBox(height: 12),
          _buildInfoRow("Citizenship", cit, Icons.flag),
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

Widget emergencyContactFront(
  Color bgc,
  String name,
  String rel,
  String phone,
  String addr,
) {
  return Material(
    elevation: 0,
    borderRadius: BorderRadius.circular(20),
    color: bgc,
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
          _buildContactRow(Icons.person, "Contact Name", name),
          const SizedBox(height: 12),
          _buildContactRow(Icons.people, "Relationship", rel),
          const SizedBox(height: 12),
          _buildContactRow(Icons.phone, "Phone", phone),
          const SizedBox(height: 12),
          _buildContactRow(Icons.home, "Address", addr),
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

Widget emergencyContactBack(
  Color bgc,
  String name,
  String rel,
  String phone,
  String addr,
) {
  return Material(
    elevation: 0,
    borderRadius: BorderRadius.circular(20),
    color: bgc,
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
          _buildContactRow(Icons.person, "Contact Name", name),
          const SizedBox(height: 12),
          _buildContactRow(Icons.people, "Relationship", rel),
          const SizedBox(height: 12),
          _buildContactRow(Icons.phone, "Phone", phone),
          const SizedBox(height: 12),
          _buildContactRow(Icons.home, "Address", addr),
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
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
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
        child: Text(
          title,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
      Expanded(
        flex: 3,
        child: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
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
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
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
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xff1a1a2e),
          ),
        ),
      ],
    ),
  );
}

/*
Widget statCard(String value, String title, IconData icon, Color color) {
  return Container(
    decoration: BoxDecoration(
      //color: Colors.white,
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
*/
Widget statCard(String value, String title, IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(12), // important
    decoration: BoxDecoration(
      //color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xff1a1a2e),
            ),
          ),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
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
      color: color.withOpacity(0.1), //Colors.white,
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

          /*ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              // Add logout logic here
            },
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),*/
          const SignOutButton(),
        ],
      );
    },
  );
}
