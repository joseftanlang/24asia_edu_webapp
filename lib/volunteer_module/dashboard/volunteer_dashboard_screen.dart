import 'package:flutter/material.dart';

// ─── Models ──────────────────────────────────────────────────────────────────

class VolunteerStats {
  final int hours;
  final int events;
  final int certificates;
  const VolunteerStats({
    required this.hours,
    required this.events,
    required this.certificates,
  });

  // TODO: factory VolunteerStats.fromMap(Map<String, dynamic> map) =>
  //   VolunteerStats(
  //     hours: map['totalHours'] as int,
  //     events: map['eventsAttended'] as int,
  //     certificates: map['certificates'] as int,
  //   );
}

class UpcomingEvent {
  final String title;
  final String date;
  final String location;
  final String role;
  const UpcomingEvent({
    required this.title,
    required this.date,
    required this.location,
    required this.role,
  });

  // TODO: factory UpcomingEvent.fromMap(Map<String, dynamic> map) =>
  //   UpcomingEvent(
  //     title: map['eventTitle'] as String,
  //     date: (map['eventDate'] as Timestamp).toDate().toString(),
  //     location: map['location'] as String,
  //     role: map['role'] as String,
  //   );
}

class TimelineEntry {
  final String title;
  final String subtitle;
  final String date;
  final IconData icon;
  final Color color;
  const TimelineEntry({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.icon,
    required this.color,
  });

  // TODO: factory TimelineEntry.fromMap(Map<String, dynamic> map) — derive
  //   icon and color from map['type'] (e.g. 'event', 'certificate', 'training')
}

class _DashboardData {
  final VolunteerStats stats;
  final List<UpcomingEvent> upcoming;
  final List<TimelineEntry> timeline;
  _DashboardData({
    required this.stats,
    required this.upcoming,
    required this.timeline,
  });
}

// ─── Service (swap each method body for Firebase when ready) ──────────────────

class VolunteerDashboardService {
  static Future<VolunteerStats> fetchStats(String userId) async {
    // TODO (Firebase):
    // final doc = await FirebaseFirestore.instance
    //   .collection('volunteers')
    //   .doc(userId)
    //   .get();
    // return VolunteerStats.fromMap(doc.data()!);
    await Future.delayed(const Duration(milliseconds: 500));
    return const VolunteerStats(hours: 87, events: 12, certificates: 5);
  }

  static Future<List<UpcomingEvent>> fetchUpcomingEvents(String userId) async {
    // TODO (Firebase):
    // final snap = await FirebaseFirestore.instance
    //   .collection('registrations')
    //   .where('userId', isEqualTo: userId)
    //   .where('eventDate', isGreaterThan: Timestamp.now())
    //   .orderBy('eventDate')
    //   .limit(5)
    //   .get();
    // return snap.docs.map((d) => UpcomingEvent.fromMap(d.data())).toList();
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      UpcomingEvent(
        title: 'Beach Cleanup',
        date: '15 Jun 2026',
        location: 'Community Park',
        role: 'General Volunteer',
      ),
      UpcomingEvent(
        title: 'Food Distribution',
        date: '18 Jun 2026',
        location: 'City Hall',
        role: 'Team Lead',
      ),
      UpcomingEvent(
        title: 'Tree Planting',
        date: '22 Jun 2026',
        location: 'Riverside',
        role: 'General Volunteer',
      ),
    ];
  }

  static Future<List<TimelineEntry>> fetchTimeline(String userId) async {
    // TODO (Firebase):
    // final snap = await FirebaseFirestore.instance
    //   .collection('activityLog')
    //   .where('userId', isEqualTo: userId)
    //   .orderBy('timestamp', descending: true)
    //   .limit(10)
    //   .get();
    // return snap.docs.map((d) => TimelineEntry.fromMap(d.data())).toList();
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      TimelineEntry(
        title: 'Joined Beach Cleanup',
        subtitle: 'Completed · 4 hrs',
        date: '12 Jun 2026',
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      TimelineEntry(
        title: 'Certificate Issued',
        subtitle: 'Event Coordinator',
        date: '10 Jun 2026',
        icon: Icons.workspace_premium,
        color: Colors.teal,
      ),
      TimelineEntry(
        title: 'Completed Training',
        subtitle: 'First Aid Basics',
        date: '05 Jun 2026',
        icon: Icons.school,
        color: Colors.blue,
      ),
      TimelineEntry(
        title: 'Joined Food Distribution',
        subtitle: 'Completed · 3 hrs',
        date: '02 Jun 2026',
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      TimelineEntry(
        title: 'Earned Badge',
        subtitle: 'Volunteer Hero',
        date: '28 May 2026',
        icon: Icons.military_tech,
        color: Colors.orange,
      ),
    ];
  }
}

// ─── Screen ──────────────────────────────────────────────────────────────────

class VolunteerDashboardScreen extends StatefulWidget {
  const VolunteerDashboardScreen({super.key});

  @override
  State<VolunteerDashboardScreen> createState() =>
      _VolunteerDashboardScreenState();
}

class _VolunteerDashboardScreenState extends State<VolunteerDashboardScreen> {
  late Future<_DashboardData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_DashboardData> _load() async {
    // TODO: replace with FirebaseAuth.instance.currentUser!.uid
    const userId = 'current_user_id';
    final results = await Future.wait([
      VolunteerDashboardService.fetchStats(userId),
      VolunteerDashboardService.fetchUpcomingEvents(userId),
      VolunteerDashboardService.fetchTimeline(userId),
    ]);
    return _DashboardData(
      stats: results[0] as VolunteerStats,
      upcoming: results[1] as List<UpcomingEvent>,
      timeline: results[2] as List<TimelineEntry>,
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
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: "Refresh",
            onPressed: () => setState(() => _future = _load()),
          ),
        ],
      ),
      body: FutureBuilder<_DashboardData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(
                    'Failed to load dashboard',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => setState(() => _future = _load()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return _buildBody(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildBody(_DashboardData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Stats ─────────────────────────────────────────────────────────
          Row(
            children: [
              _kpiCard(
                data.stats.hours.toString(),
                "Hours",
                Icons.timer,
                Colors.blue,
              ),
              _kpiCard(
                data.stats.events.toString(),
                "Events",
                Icons.event,
                Colors.green,
              ),
              _kpiCard(
                data.stats.certificates.toString(),
                "Certs",
                Icons.workspace_premium,
                Colors.teal,
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Upcoming Events ────────────────────────────────────────────────
          const Text(
            "Upcoming Events",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (data.upcoming.isEmpty)
            _emptyState("No upcoming events", Icons.event_busy)
          else
            ...data.upcoming.map(_upcomingCard),

          const SizedBox(height: 28),

          // ── Timeline ───────────────────────────────────────────────────────
          const Text(
            "Your Timeline",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (data.timeline.isEmpty)
            _emptyState("No activity yet", Icons.timeline)
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade200, blurRadius: 10),
                ],
              ),
              child: Column(
                children: [
                  for (int i = 0; i < data.timeline.length; i++)
                    _timelineItem(
                      data.timeline[i],
                      isLast: i == data.timeline.length - 1,
                    ),
                ],
              ),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _kpiCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade200, blurRadius: 10),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _upcomingCard(UpcomingEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: const Icon(Icons.event, color: Colors.blue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      event.date,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.place, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      event.location,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Chip(
            label: Text(
              event.role,
              style: const TextStyle(fontSize: 10),
            ),
            backgroundColor: Colors.blue.shade50,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _timelineItem(TimelineEntry entry, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot + connector line
          Column(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: entry.color.withValues(alpha: 0.15),
                child: Icon(entry.icon, size: 18, color: entry.color),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey.shade200,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20, top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.subtitle,
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.date,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(String message, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          Text(message, style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}
