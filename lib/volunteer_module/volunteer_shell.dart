import 'package:flutter/material.dart';

import 'attendance/clock_in_out_screen.dart';
import 'certificates/certificates_screen.dart';
import 'dashboard/volunteer_dashboard_screen.dart';
import 'digital_id/digital_id_screen.dart';
import 'events/events_list_screen.dart';
import 'training/training_list_screen.dart';

// Layout breakpoints
const _kWide = 900.0; // full labelled sidebar
const _kMid  = 600.0; // icon-only rail
//  < 600    → bottom navigation bar

class VolunteerShell extends StatefulWidget {
  const VolunteerShell({super.key});

  @override
  State<VolunteerShell> createState() => _VolunteerShellState();
}

class _VolunteerShellState extends State<VolunteerShell> {
  int _selectedIndex = 0;

  static const _navItems = [
    _NavItem(
      outlinedIcon: Icons.dashboard_outlined,
      filledIcon:   Icons.dashboard,
      label:        'Dashboard',
      shortLabel:   'Home',
    ),
    _NavItem(
      outlinedIcon: Icons.event_outlined,
      filledIcon:   Icons.event,
      label:        'Browse Events',
      shortLabel:   'Events',
    ),
    _NavItem(
      outlinedIcon: Icons.qr_code_scanner,
      filledIcon:   Icons.qr_code_scanner,
      label:        'Clock In',
      shortLabel:   'Clock In',
    ),
    _NavItem(
      outlinedIcon: Icons.school_outlined,
      filledIcon:   Icons.school,
      label:        'Training',
      shortLabel:   'Training',
    ),
    _NavItem(
      outlinedIcon: Icons.workspace_premium_outlined,
      filledIcon:   Icons.workspace_premium,
      label:        'Certificates',
      shortLabel:   'Certs',
    ),
    _NavItem(
      outlinedIcon: Icons.badge_outlined,
      filledIcon:   Icons.badge,
      label:        'Digital ID',
      shortLabel:   'ID',
    ),
  ];

  // IndexedStack keeps each screen alive so state is preserved when switching
  static const _screens = <Widget>[
    VolunteerDashboardScreen(),
    EventsListScreen(),
    ClockInOutScreen(),
    TrainingListScreen(),
    CertificatesScreen(),
    DigitalIdScreen(),
  ];

  void _select(int i) => setState(() => _selectedIndex = i);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    // ── Full sidebar ───────────────────────────────────────────────────────────
    if (width >= _kWide) {
      return Scaffold(
        body: Row(
          children: [
            _VolunteerSidebar(
              items: _navItems,
              selectedIndex: _selectedIndex,
              onItemSelected: _select,
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _screens,
              ),
            ),
          ],
        ),
      );
    }

    // ── Icon rail (tablet) ─────────────────────────────────────────────────────
    if (width >= _kMid) {
      return Scaffold(
        body: Row(
          children: [
            _VolunteerRail(
              items: _navItems,
              selectedIndex: _selectedIndex,
              onItemSelected: _select,
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _screens,
              ),
            ),
          ],
        ),
      );
    }

    // ── Bottom navigation bar (mobile) ─────────────────────────────────────────
    // Bottom nav sits completely outside the inner screens' AppBars so there
    // is no overlap with titles or any other AppBar content.
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _select,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xff1565C0),
        unselectedItemColor: Colors.grey.shade500,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: _navItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.outlinedIcon),
                activeIcon: Icon(item.filledIcon),
                label: item.shortLabel,
              ),
            )
            .toList(),
      ),
    );
  }
}

// ─── Nav item data ────────────────────────────────────────────────────────────

class _NavItem {
  final IconData outlinedIcon;
  final IconData filledIcon;
  final String label;
  final String shortLabel; // used in the mobile bottom nav
  const _NavItem({
    required this.outlinedIcon,
    required this.filledIcon,
    required this.label,
    required this.shortLabel,
  });
}

// ─── Full sidebar (≥ 900px) ───────────────────────────────────────────────────

class _VolunteerSidebar extends StatelessWidget {
  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const _VolunteerSidebar({
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff1565C0), Color(0xff42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Color(0xff1565C0), size: 32),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Volunteer Portal',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '24 Asia Foundation',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Nav items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              children: [
                for (int i = 0; i < items.length; i++)
                  _SidebarTile(
                    item: items[i],
                    isSelected: selectedIndex == i,
                    onTap: () => onItemSelected(i),
                  ),
              ],
            ),
          ),

          // Footer
          Divider(height: 1, color: Colors.grey.shade200),
          Padding(
            padding: const EdgeInsets.all(10),
            child: _SidebarTile(
              item: const _NavItem(
                outlinedIcon: Icons.logout,
                filledIcon:   Icons.logout,
                label:        'Sign Out',
                shortLabel:   'Sign Out',
              ),
              isSelected: false,
              onTap: () {
                // TODO: FirebaseAuth.instance.signOut()
              },
              accentColor: Colors.red.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Icon rail (600–899px) ────────────────────────────────────────────────────

class _VolunteerRail extends StatelessWidget {
  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const _VolunteerRail({
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xff1565C0);

    return Container(
      width: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          // Mini header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(0, 48, 0, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff1565C0), Color(0xff42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xff1565C0), size: 22),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Rail items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 4),
              children: [
                for (int i = 0; i < items.length; i++)
                  Tooltip(
                    message: items[i].label,
                    preferBelow: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => onItemSelected(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: selectedIndex == i
                                ? blue.withValues(alpha: 0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            selectedIndex == i
                                ? items[i].filledIcon
                                : items[i].outlinedIcon,
                            size: 22,
                            color: selectedIndex == i
                                ? blue
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Sign out
          Divider(height: 1, color: Colors.grey.shade200),
          Tooltip(
            message: 'Sign Out',
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // TODO: FirebaseAuth.instance.signOut()
                },
                child: Container(
                  width: 52,
                  height: 52,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  child:
                      Icon(Icons.logout, size: 22, color: Colors.red.shade400),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─── Sidebar tile ─────────────────────────────────────────────────────────────

class _SidebarTile extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? accentColor;

  const _SidebarTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xff1565C0);
    final activeColor = accentColor ?? blue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          hoverColor: blue.withValues(alpha: 0.05),
          splashColor: blue.withValues(alpha: 0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: isSelected
                  ? activeColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? item.filledIcon : item.outlinedIcon,
                  size: 20,
                  color: isSelected ? activeColor : Colors.grey.shade500,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected ? activeColor : Colors.grey.shade700,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: activeColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
