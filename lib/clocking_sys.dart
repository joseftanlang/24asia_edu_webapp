import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class ClockInOutPage extends StatefulWidget {
  const ClockInOutPage({super.key});

  @override
  State<ClockInOutPage> createState() => _ClockInOutPageState();
}

class _ClockInOutPageState extends State<ClockInOutPage> with SingleTickerProviderStateMixin {
  // Clock States
  bool isClockedIn = false;
  DateTime? clockInTime;
  DateTime? clockOutTime;
  String? lastScanData;
  String activeTab = 'scan'; // 'scan', 'history', 'stats'
  
  // Statistics
  int totalHoursThisWeek = 0;
  int totalDaysWorked = 0;
  double attendanceRate = 98.5;
  
  // Break Tracking
  bool isOnBreak = false;
  DateTime? breakStartTime;
  Duration totalBreakDuration = Duration.zero;
  
  // Location Tracking
  String? currentLocation;
  String? currentShiftType;
  
  // History
  List<AttendanceRecord> attendanceHistory = [];
  List<BreakRecord> breakHistory = [];
  
  // Animation
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  // Scanner Controller
  MobileScannerController? scannerController;
  
  @override
  void initState() {
    super.initState();
    _loadSampleData();
    _calculateStatistics();
    scannerController = MobileScannerController();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(_pulseController);
  }
  
  void _loadSampleData() {
    final now = DateTime.now();
    attendanceHistory = [
      AttendanceRecord(
        id: '1',
        date: now.subtract(const Duration(days: 0)),
        clockIn: DateTime(now.year, now.month, now.day, 8, 30),
        clockOut: DateTime(now.year, now.month, now.day, 17, 15),
        status: 'Completed',
        location: 'Main Office',
        shiftType: 'Morning',
        overtime: Duration(minutes: 45),
      ),
      AttendanceRecord(
        id: '2',
        date: now.subtract(const Duration(days: 1)),
        clockIn: DateTime(now.year, now.month, now.day - 1, 9, 0),
        clockOut: DateTime(now.year, now.month, now.day - 1, 18, 0),
        status: 'Completed',
        location: 'Community Center',
        shiftType: 'Morning',
        overtime: Duration.zero,
      ),
      AttendanceRecord(
        id: '3',
        date: now.subtract(const Duration(days: 2)),
        clockIn: DateTime(now.year, now.month, now.day - 2, 8, 45),
        clockOut: DateTime(now.year, now.month, now.day - 2, 16, 30),
        status: 'Completed',
        location: 'School',
        shiftType: 'Afternoon',
        overtime: Duration.zero,
      ),
      AttendanceRecord(
        id: '4',
        date: now.subtract(const Duration(days: 3)),
        clockIn: DateTime(now.year, now.month, now.day - 3, 9, 15),
        clockOut: null,
        status: 'Incomplete',
        location: 'Hospital',
        shiftType: 'Evening',
        overtime: Duration.zero,
      ),
    ];
    
    breakHistory = [
      BreakRecord(
        startTime: DateTime.now().subtract(const Duration(hours: 2)),
        endTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        duration: const Duration(minutes: 30),
      ),
      BreakRecord(
        startTime: DateTime.now().subtract(const Duration(hours: 5)),
        endTime: DateTime.now().subtract(const Duration(hours: 4, minutes: 15)),
        duration: const Duration(minutes: 45),
      ),
    ];
  }
  
  void _calculateStatistics() {
    final completedShifts = attendanceHistory.where((r) => r.status == 'Completed').length;
    totalDaysWorked = completedShifts;
    
    int totalMinutes = 0;
    for (var record in attendanceHistory) {
      if (record.clockOut != null) {
        totalMinutes += record.clockOut!.difference(record.clockIn).inMinutes;
      }
    }
    totalHoursThisWeek = totalMinutes ~/ 60;
    
    attendanceRate = (completedShifts / attendanceHistory.length * 100);
  }
  
  void onBarcodeDetected(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null && code != lastScanData) {
        setState(() {
          lastScanData = code;
        });
        _processQRData(code);
      }
    }
  }
  
  void _processQRData(String qrData) {
    // Parse QR data - can contain location, shift type, etc.
    // Format: "LOCATION_NAME|SHIFT_TYPE|ACTION"
    final parts = qrData.split('|');
    final action = parts.length > 2 ? parts[2] : qrData;
    final location = parts.isNotEmpty ? parts[0] : 'Unknown Location';
    final shiftType = parts.length > 1 ? parts[1] : 'Regular';
    
    if (action.contains('CLOCK_IN') || (!isClockedIn && action.contains('VOLUNTEER'))) {
      _clockIn(location: location, shiftType: shiftType);
    } else if (action.contains('CLOCK_OUT') || (isClockedIn && action.contains('VOLUNTEER'))) {
      _clockOut();
    } else if (action.contains('BREAK_START') && isClockedIn && !isOnBreak) {
      _startBreak();
    } else if (action.contains('BREAK_END') && isOnBreak) {
      _endBreak();
    } else {
      _showSnackBar('Invalid QR Code', Colors.red, icon: Icons.error);
    }
  }
  
  void _clockIn({required String location, required String shiftType}) {
    setState(() {
      clockInTime = DateTime.now();
      isClockedIn = true;
      currentLocation = location;
      currentShiftType = shiftType;
    });
    
    final newRecord = AttendanceRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      clockIn: clockInTime!,
      clockOut: null,
      status: 'In Progress',
      location: location,
      shiftType: shiftType,
      overtime: Duration.zero,
    );
    
    setState(() {
      attendanceHistory.insert(0, newRecord);
    });
    
    _showSnackBar(
      '✓ Clocked in successfully at ${_formatTime(clockInTime!)}',
      Colors.green,
      icon: Icons.login,
    );
    
    _showLocationInfo(location, shiftType);
  }
  
  void _clockOut() {
    setState(() {
      clockOutTime = DateTime.now();
      isClockedIn = false;
      
      if (attendanceHistory.isNotEmpty && attendanceHistory[0].clockOut == null) {
        attendanceHistory[0].clockOut = clockOutTime;
        attendanceHistory[0].status = 'Completed';
        
        // Calculate overtime (if worked more than 8 hours)
        final workedDuration = clockOutTime!.difference(attendanceHistory[0].clockIn);
        if (workedDuration.inHours > 8) {
          attendanceHistory[0].overtime = Duration(minutes: workedDuration.inMinutes - (8 * 60));
        }
      }
      
      currentLocation = null;
      currentShiftType = null;
      
      if (isOnBreak) {
        _endBreak();
      }
    });
    
    final workedDuration = clockOutTime!.difference(clockInTime!);
    final hours = workedDuration.inHours;
    final minutes = workedDuration.inMinutes % 60;
    
    _showSnackBar(
      '✓ Clocked out successfully!\nTotal: $hours hrs $minutes mins',
      Colors.blue,
      icon: Icons.logout,
    );
    
    _calculateStatistics();
  }
  
  void _startBreak() {
    setState(() {
      isOnBreak = true;
      breakStartTime = DateTime.now();
    });
    
    _showSnackBar('☕ Break started at ${_formatTime(breakStartTime!)}', Colors.orange, icon: Icons.free_breakfast);
  }
  
  void _endBreak() {
    final breakEnd = DateTime.now();
    final breakDuration = breakEnd.difference(breakStartTime!);
    
    setState(() {
      isOnBreak = false;
      totalBreakDuration += breakDuration;
      
      breakHistory.add(BreakRecord(
        startTime: breakStartTime!,
        endTime: breakEnd,
        duration: breakDuration,
      ));
      
      breakStartTime = null;
    });
    
    _showSnackBar(
      '✓ Break ended. Duration: ${breakDuration.inMinutes} mins',
      Colors.green,
      icon: Icons.check_circle,
    );
  }
  
  void _showLocationInfo(String location, String shiftType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📍 Location: $location', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('🕒 Shift: $shiftType'),
          ],
        ),
        backgroundColor: Colors.blue.shade700,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  void _showSnackBar(String message, Color color, {IconData? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon ?? (color == Colors.green ? Icons.check_circle : Icons.info), color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
  
  String _formatTime(DateTime time) {
    return DateFormat('HH:mm:ss').format(time);
  }
  
  String _formatDate(DateTime date) {
    return DateFormat('EEEE, MMM d, yyyy').format(date);
  }
  
  String _formatShortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }
  
  Duration _calculateDuration(DateTime start, DateTime end) {
    return end.difference(start);
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    scannerController?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 180,
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time, color: Colors.white70),
                          const SizedBox(width: 10),
                          const Text(
                            'Attendance Tracker',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          DateFormat('EEEE, MMM d').format(DateTime.now()),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Current Status Card
                  _buildStatusCard(),
                  const SizedBox(height: 20),
                  
                  // Quick Actions
                  _buildQuickActions(),
                  const SizedBox(height: 20),
                  
                  // Stats Cards
                  _buildStatsRow(),
                  const SizedBox(height: 20),
                  
                  // Tab Selector
                  _buildTabSelector(),
                  const SizedBox(height: 15),
                  
                  // Tab Content
                  activeTab == 'scan' ? _buildScannerTab() :
                  activeTab == 'history' ? _buildHistoryTab() :
                  _buildStatsTab(),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatusCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isClockedIn
                ? [Colors.green.shade700, Colors.green.shade500]
                : isOnBreak
                    ? [Colors.orange.shade700, Colors.orange.shade500]
                    : [Colors.blue.shade700, Colors.blue.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: (isClockedIn ? Colors.green : Colors.blue).withOpacity(.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Animated background
            Positioned(
              right: -20,
              top: -20,
              child: ScaleTransition(
                scale: _pulseAnimation,
                child: Icon(
                  isClockedIn ? Icons.check_circle : Icons.access_time,
                  size: 120,
                  color: Colors.white.withOpacity(.1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          isClockedIn 
                              ? (isOnBreak ? Icons.free_breakfast : Icons.work)
                              : Icons.access_time,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isClockedIn 
                                  ? (isOnBreak ? 'On Break' : 'Clocked In')
                                  : 'Not Clocked In',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            if (isClockedIn && clockInTime != null)
                              Text(
                                'Since: ${_formatTime(clockInTime!)}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                          ],
                        ),
                      ),
                      if (isClockedIn && !isOnBreak)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_calculateDuration(clockInTime!, DateTime.now()).inHours}h',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      if (isOnBreak && breakStartTime != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_calculateDuration(breakStartTime!, DateTime.now()).inMinutes}m',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Location and Shift Info
                  if (currentLocation != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              currentLocation!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          if (currentShiftType != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                currentShiftType!,
                                style: TextStyle(color: Colors.blue.shade700, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.login,
            label: 'Clock In',
            color: Colors.green,
            onTap: isClockedIn ? null : () => _clockIn(location: 'Manual Entry', shiftType: 'Regular'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.logout,
            label: 'Clock Out',
            color: Colors.red,
            onTap: !isClockedIn || isOnBreak ? null : _clockOut,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.free_breakfast,
            label: isOnBreak ? 'End Break' : 'Break',
            color: Colors.orange,
            onTap: !isClockedIn ? null : (isOnBreak ? _endBreak : _startBreak),
          ),
        ),
      ],
    );
  }
  
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: onTap != null ? Colors.white : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
          boxShadow: onTap != null
              ? [
                  BoxShadow(
                    color: color.withOpacity(.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(icon, color: onTap != null ? color : Colors.grey, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: onTap != null ? color : Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Hours',
            '$totalHoursThisWeek',
            'this week',
            Icons.timer,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Days Worked',
            '$totalDaysWorked',
            'this month',
            Icons.calendar_today,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Attendance',
            '${attendanceRate.toStringAsFixed(1)}%',
            'rate',
            Icons.trending_up,
            Colors.purple,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
  
  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTabItem('Scan', 'scan', Icons.qr_code_scanner),
          _buildTabItem('History', 'history', Icons.history),
          _buildTabItem('Statistics', 'stats', Icons.bar_chart),
        ],
      ),
    );
  }
  
  Widget _buildTabItem(String title, String tab, IconData icon) {
    final isActive = activeTab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => activeTab = tab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xff1565C0) : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isActive ? Colors.white : Colors.grey, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildScannerTab() {
    return Column(
      children: [
        // Camera Scanner
        Container(
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Stack(
              children: [
                MobileScanner(
                  controller: scannerController,
                  onDetect: onBarcodeDetected,
                ),
                // Scanner overlay guide
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(40),
                  child: const Center(
                    child: Text(
                      'Scan QR Code',
                      style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        // Instructions Card
        Container(
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
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 10),
                  Text(
                    'How to use QR Scanner',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildInstructionItem('1', 'Point camera at QR code', Icons.qr_code_scanner),
              _buildInstructionItem('2', 'Auto-detects Clock In/Out', Icons.autorenew),
              _buildInstructionItem('3', 'Records location & shift info', Icons.location_on),
              _buildInstructionItem('4', 'Track breaks with special QR', Icons.free_breakfast),
            ],
          ),
        ),
        
        if (lastScanData != null)
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Last Scan:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(lastScanData!, style: TextStyle(color: Colors.green.shade700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildInstructionItem(String number, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
  
  Widget _buildHistoryTab() {
    if (attendanceHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 20),
            Text('No attendance records yet', style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attendanceHistory.length,
      itemBuilder: (context, index) {
        final record = attendanceHistory[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: ExpansionTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: record.status == 'Completed' ? Colors.green.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  record.status == 'Completed' ? Icons.check : Icons.warning,
                  color: record.status == 'Completed' ? Colors.green : Colors.orange,
                ),
              ),
              title: Text(
                _formatDate(record.date),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${record.location} • ${record.shiftType}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (record.status == 'Completed')
                    Text(
                      '${_calculateDuration(record.clockIn, record.clockOut!).inHours}h ${_calculateDuration(record.clockIn, record.clockOut!).inMinutes % 60}m',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  Text(
                    record.status,
                    style: TextStyle(
                      color: record.status == 'Completed' ? Colors.green : Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildDetailRow('Clock In', _formatTime(record.clockIn), Icons.login),
                      const SizedBox(height: 10),
                      _buildDetailRow(
                        'Clock Out',
                        record.clockOut != null ? _formatTime(record.clockOut!) : '--:--',
                        Icons.logout,
                      ),
                      const SizedBox(height: 10),
                      _buildDetailRow('Location', record.location, Icons.location_on),
                      const SizedBox(height: 10),
                      _buildDetailRow('Shift', record.shiftType, Icons.schedule),
                      if (record.overtime.inMinutes > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: _buildDetailRow(
                            'Overtime',
                            '${record.overtime.inHours}h ${record.overtime.inMinutes % 60}m',
                            Icons.timer,
                            highlight: true,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildDetailRow(String label, String value, IconData icon, {bool highlight = false}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: TextStyle(color: Colors.grey.shade600)),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: highlight ? Colors.orange.shade700 : Colors.black87,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatsTab() {
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
          const Text(
            'Weekly Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildWeeklyChart(),
          const SizedBox(height: 30),
          const Text(
            'Detailed Analytics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildAnalyticsCard('Average Daily Hours', '6.5 hours', Icons.av_timer, Colors.blue),
          _buildAnalyticsCard('Most Active Day', 'Wednesday', Icons.celebration, Colors.green),
          _buildAnalyticsCard('Break Time Total', '${totalBreakDuration.inHours}h ${totalBreakDuration.inMinutes % 60}m', Icons.free_breakfast, Colors.orange),
          _buildAnalyticsCard('Completion Rate', '${attendanceRate.toStringAsFixed(1)}%', Icons.analytics, Colors.purple),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.orange.shade700),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Next Milestone', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${100 - totalHoursThisWeek} more hours to reach 100 hours!'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWeeklyChart() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final hours = [6.5, 7.0, 8.0, 7.5, 6.0, 4.0, 0.0];
    
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(days.length, (index) {
          final hour = hours[index];
          final height = (hour / 8) * 150;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('${hour}h', style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 5),
              Container(
                width: 35,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade700],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 8),
              Text(days[index], style: const TextStyle(fontSize: 12)),
            ],
          );
        }),
      ),
    );
  }
  
  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade600)),
                Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Data Models
class AttendanceRecord {
  String id;
  DateTime date;
  DateTime clockIn;
  DateTime? clockOut;
  String status;
  String location;
  String shiftType;
  Duration overtime;
  
  AttendanceRecord({
    required this.id,
    required this.date,
    required this.clockIn,
    this.clockOut,
    required this.status,
    required this.location,
    required this.shiftType,
    required this.overtime,
  });
}

class BreakRecord {
  DateTime startTime;
  DateTime endTime;
  Duration duration;
  
  BreakRecord({
    required this.startTime,
    required this.endTime,
    required this.duration,
  });
}