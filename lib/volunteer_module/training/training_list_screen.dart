import 'package:flutter/material.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

class TrainingCourse {
  final String id;
  final String title;
  final String description;
  final String date;
  final String location;
  final int availableSlots;
  final int totalSlots;
  final String category;
  final String duration;

  const TrainingCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.availableSlots,
    required this.totalSlots,
    required this.category,
    required this.duration,
  });

  // TODO (Firebase):
  // factory TrainingCourse.fromMap(String id, Map<String, dynamic> map) =>
  //   TrainingCourse(
  //     id:             id,
  //     title:          map['title']          as String,
  //     description:    map['description']    as String,
  //     date:           DateFormat('dd MMM yyyy')
  //                       .format((map['date'] as Timestamp).toDate()),
  //     location:       map['location']       as String,
  //     availableSlots: map['availableSlots'] as int,
  //     totalSlots:     map['totalSlots']     as int,
  //     category:       map['category']       as String,
  //     duration:       map['duration']       as String,
  //   );
}

// ─── Service ──────────────────────────────────────────────────────────────────

class TrainingService {
  static Future<List<TrainingCourse>> fetchCourses() async {
    // TODO (Firebase):
    // final snap = await FirebaseFirestore.instance
    //   .collection('trainingCourses')
    //   .orderBy('date')
    //   .get();
    // return snap.docs
    //   .map((d) => TrainingCourse.fromMap(d.id, d.data()))
    //   .toList();
    await Future.delayed(const Duration(milliseconds: 600));
    return const [
      TrainingCourse(
        id: '1',
        title: 'First Aid & Emergency Response',
        description:
            'Learn how to respond confidently during emergencies. Covers CPR, bleeding control, choking response, and basic triage so you can act fast when it counts.',
        date: '20 Jun 2026',
        location: 'Training Hall A',
        availableSlots: 8,
        totalSlots: 20,
        category: 'Safety',
        duration: '3 hrs',
      ),
      TrainingCourse(
        id: '2',
        title: 'Volunteer Leadership & Communication',
        description:
            'Build the skills to lead a team of volunteers effectively. Topics include conflict resolution, public speaking, delegation, and motivating others.',
        date: '22 Jun 2026',
        location: 'Seminar Room B',
        availableSlots: 3,
        totalSlots: 15,
        category: 'Leadership',
        duration: '4 hrs',
      ),
      TrainingCourse(
        id: '3',
        title: 'Environmental Stewardship',
        description:
            'Understand how your volunteering actions impact the environment. Learn sustainable practices, waste reduction strategies, and eco-friendly event management.',
        date: '25 Jun 2026',
        location: 'Riverside Community Centre',
        availableSlots: 15,
        totalSlots: 25,
        category: 'Environment',
        duration: '6 hrs',
      ),
      TrainingCourse(
        id: '4',
        title: 'Child Protection & Safeguarding',
        description:
            'A mandatory course for anyone working with children. Covers recognising signs of abuse, reporting procedures, and maintaining safe boundaries.',
        date: '28 Jun 2026',
        location: 'Online — Zoom',
        availableSlots: 0,
        totalSlots: 12,
        category: 'Safety',
        duration: '2 hrs',
      ),
      TrainingCourse(
        id: '5',
        title: 'Community Health Awareness',
        description:
            'Empower your community with basic health knowledge. Nutrition, hygiene, disease prevention, and how to run a simple health screening booth.',
        date: '30 Jun 2026',
        location: 'City Hall Annex',
        availableSlots: 6,
        totalSlots: 18,
        category: 'Health',
        duration: '3 hrs',
      ),
      TrainingCourse(
        id: '6',
        title: 'Event Planning & Coordination',
        description:
            'Everything you need to run a smooth volunteer event — from logistics and budgeting to day-of coordination and post-event reporting.',
        date: '5 Jul 2026',
        location: 'Foundation HQ',
        availableSlots: 11,
        totalSlots: 20,
        category: 'General',
        duration: '5 hrs',
      ),
      TrainingCourse(
        id: '7',
        title: 'Mental Health First Aid',
        description:
            'Recognise the early signs of mental health struggles in fellow volunteers and community members. Learn how to listen, support, and refer appropriately.',
        date: '8 Jul 2026',
        location: 'Wellness Centre',
        availableSlots: 4,
        totalSlots: 16,
        category: 'Health',
        duration: '4 hrs',
      ),
    ];
  }

  static Future<void> signUp(String courseId, String userId) async {
    // TODO (Firebase):
    // final batch = FirebaseFirestore.instance.batch();
    //
    // final regRef = FirebaseFirestore.instance.collection('registrations').doc();
    // batch.set(regRef, {
    //   'courseId': courseId,
    //   'userId':   userId,
    //   'type':     'training',
    //   'signedUpAt': FieldValue.serverTimestamp(),
    // });
    //
    // final courseRef = FirebaseFirestore.instance
    //   .collection('trainingCourses').doc(courseId);
    // batch.update(courseRef, {'availableSlots': FieldValue.increment(-1)});
    //
    // await batch.commit();
    await Future.delayed(const Duration(milliseconds: 300));
  }
}

// ─── Screen ──────────────────────────────────────────────────────────────────

class TrainingListScreen extends StatefulWidget {
  const TrainingListScreen({super.key});

  @override
  State<TrainingListScreen> createState() => _TrainingListScreenState();
}

class _TrainingListScreenState extends State<TrainingListScreen> {
  late Future<List<TrainingCourse>> _future;

  // Tracks which courses this user has signed up for (local state)
  final _signedUp = <String>{};
  // Local slot count overrides after signup (so the UI reflects the decrement)
  final _localSlots = <String, int>{};

  final _searchController = TextEditingController();
  String _search = '';
  String _category = 'All';

  @override
  void initState() {
    super.initState();
    _future = TrainingService.fetchCourses();
    _searchController.addListener(
      () => setState(() => _search = _searchController.text),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TrainingCourse> _filter(List<TrainingCourse> all) => all.where((c) {
        final q = _search.toLowerCase();
        final matchSearch = q.isEmpty ||
            c.title.toLowerCase().contains(q) ||
            c.description.toLowerCase().contains(q) ||
            c.location.toLowerCase().contains(q);
        final matchCat = _category == 'All' || c.category == _category;
        return matchSearch && matchCat;
      }).toList();

  List<String> _categories(List<TrainingCourse> all) =>
      ['All', ...{for (final c in all) c.category}];

  void _signUpFor(TrainingCourse course) {
    setState(() {
      _signedUp.add(course.id);
      _localSlots[course.id] =
          (_localSlots[course.id] ?? course.availableSlots) - 1;
    });

    // TODO: TrainingService.signUp(course.id, FirebaseAuth.instance.currentUser!.uid);

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.green.shade50,
              child: const Icon(Icons.check_circle,
                  color: Colors.green, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'You\'re signed up!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Successfully registered for\n"${course.title}".',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, height: 1.5),
            ),
            const SizedBox(height: 4),
            Text(
              '${course.date}  ·  ${course.location}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1565C0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it'),
            ),
          ),
        ],
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
        title:
            const Text('Training', style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<List<TrainingCourse>>(
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
                  const Icon(Icons.error_outline,
                      size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('Failed to load courses',
                      style:
                          TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        setState(() => _future = TrainingService.fetchCourses()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final all = snapshot.data!;
          final categories = _categories(all);
          final filtered = _filter(all);

          return Column(
            children: [
              _buildSearchBar(),
              _buildCategoryChips(categories),
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmpty()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) => _CourseCard(
                          course: filtered[i],
                          isSignedUp:
                              _signedUp.contains(filtered[i].id),
                          slotOverride:
                              _localSlots[filtered[i].id],
                          onSignUp: () => _signUpFor(filtered[i]),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: const Color(0xff1565C0),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search courses...',
          hintStyle:
              TextStyle(color: Colors.white.withValues(alpha: 0.6)),
          prefixIcon:
              const Icon(Icons.search, color: Colors.white70),
          suffixIcon: _search.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => _searchController.clear(),
                )
              : null,
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(List<String> categories) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((cat) {
            final selected = _category == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(cat),
                selected: selected,
                onSelected: (_) => setState(() => _category = cat),
                selectedColor: const Color(0xff1565C0),
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.grey.shade700,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
                backgroundColor: Colors.grey.shade100,
                side: BorderSide.none,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 56, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text('No courses found',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16)),
        ],
      ),
    );
  }
}

// ─── Course card ──────────────────────────────────────────────────────────────

class _CourseCard extends StatelessWidget {
  final TrainingCourse course;
  final bool isSignedUp;
  final int? slotOverride;
  final VoidCallback onSignUp;

  const _CourseCard({
    required this.course,
    required this.isSignedUp,
    required this.onSignUp,
    this.slotOverride,
  });

  static Color _categoryColor(String cat) => switch (cat) {
        'Safety'      => Colors.orange,
        'Leadership'  => Colors.purple,
        'Environment' => Colors.green,
        'Health'      => Colors.red,
        _             => const Color(0xff1565C0),
      };

  @override
  Widget build(BuildContext context) {
    final slots = slotOverride ?? course.availableSlots;
    final isFull = slots <= 0;
    final catColor = _categoryColor(course.category);

    final slotsColor = isFull
        ? Colors.red
        : slots <= course.totalSlots * 0.2
            ? Colors.orange
            : Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Coloured left accent strip
              Container(width: 5, color: catColor),

              // Card body
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category + slots
                      Row(
                        children: [
                          _Pill(label: course.category, color: catColor),
                          const Spacer(),
                          Icon(Icons.group_outlined,
                              size: 14, color: slotsColor),
                          const SizedBox(width: 4),
                          Text(
                            isFull
                                ? 'Class Full'
                                : '$slots slot${slots == 1 ? '' : 's'} left',
                            style: TextStyle(
                              color: slotsColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Title
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Description
                      Text(
                        course.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          height: 1.45,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Date / location / duration chips
                      Wrap(
                        spacing: 14,
                        runSpacing: 4,
                        children: [
                          _InfoChip(
                              Icons.calendar_today_outlined, course.date),
                          _InfoChip(Icons.place_outlined, course.location),
                          _InfoChip(Icons.timer_outlined, course.duration),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Sign-up button
                      SizedBox(
                        width: double.infinity,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 280),
                          child: isSignedUp
                              ? _SignedUpBadge(key: const ValueKey('done'))
                              : _SignUpButton(
                                  key: const ValueKey('cta'),
                                  isFull: isFull,
                                  onPressed: isFull ? null : onSignUp,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Small reusable widgets ───────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  const _Pill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(text,
            style:
                TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ],
    );
  }
}

class _SignedUpBadge extends StatelessWidget {
  const _SignedUpBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 18),
          SizedBox(width: 8),
          Text(
            'Signed Up',
            style: TextStyle(
                color: Colors.green, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final bool isFull;
  final VoidCallback? onPressed;
  const _SignUpButton({super.key, required this.isFull, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff1565C0),
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey.shade200,
        disabledForegroundColor: Colors.grey.shade500,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 13),
        elevation: 0,
      ),
      child: Text(isFull ? 'Class Full' : 'Sign Up'),
    );
  }
}
