import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../providers/trip_provider.dart';
import '../../theme/app_theme.dart';
import '../widgets/activity_card.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    'Semua',
    'Selesai',
    'Batal',
    'Sedang Berlangsung'
  ];

  static const List<String> _monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  late DateTime _selectedDate;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _currentMonth = DateTime(now.year, now.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
          backgroundColor: AppTheme.backgroundCard,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentMonth = DateTime(
                                _currentMonth.year, _currentMonth.month - 1, 1);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundApp,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(PhosphorIconsRegular.caretLeft,
                              color: AppTheme.primaryBlue, size: 20),
                        ),
                      ),
                      Text(
                        '${_monthNames[_currentMonth.month - 1]} ${_currentMonth.year}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentMonth = DateTime(
                                _currentMonth.year, _currentMonth.month + 1, 1);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundApp,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(PhosphorIconsRegular.caretRight,
                              color: AppTheme.primaryBlue, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: _CalendarWidget(
                    currentMonth: _currentMonth,
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Blue Body Content
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryBlue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      child: Stack(
                        children: [
                          // Background Wave Pattern (mock)
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _WavePatternPainter(),
                            ),
                          ),
                          Column(
                            children: [
                              // Filter Chips
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children:
                                      List.generate(_filters.length, (index) {
                                    final isSelected =
                                        _selectedFilterIndex == index;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(
                                            () => _selectedFilterIndex = index);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.white
                                                  .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        child: Text(
                                          _filters[index],
                                          style: TextStyle(
                                            color: isSelected
                                                ? AppTheme.primaryBlue
                                                : Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),

                              // Activity List
                              Expanded(
                                child: Consumer<TripProvider>(
                                  builder: (context, provider, child) {
                                    final activities = provider
                                        .getActivitiesForDate(_selectedDate);

                                    return ListView.builder(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 100),
                                      itemCount: activities.length,
                                      itemBuilder: (context, index) {
                                        return ActivityCard(
                                          activity: activities[index],
                                          showStatusBanner: true,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: FloatingActionButton(
              onPressed: () {},
              shape: const CircleBorder(),
              elevation: 4,
              child: const Icon(PhosphorIconsRegular.plus, size: 28),
            ),
          ),
        ));
  }
}

class _CalendarWidget extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const _CalendarWidget({
    required this.currentMonth,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['MIN', 'SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB'];

    final int daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final int firstDayWeekday =
        DateTime(currentMonth.year, currentMonth.month, 1)
            .weekday; // 1=Mon, 7=Sun
    final int startOffset = firstDayWeekday == 7 ? 0 : firstDayWeekday;
    final int totalCells = ((startOffset + daysInMonth) / 7).ceil() * 7;

    List<DateTime> displayDates = [];
    for (int i = 0; i < totalCells; i++) {
      final int dayOffset = i - startOffset;
      displayDates
          .add(DateTime(currentMonth.year, currentMonth.month, dayOffset + 1));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: days.map((day) {
            return Text(
              day,
              style: TextStyle(
                color: day == 'MIN' ? AppTheme.statusBatal : AppTheme.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Table(
          children: List.generate((totalCells / 7).floor(), (rowIndex) {
            final rowDates =
                displayDates.sublist(rowIndex * 7, (rowIndex + 1) * 7);
            return TableRow(
              children: rowDates.map((date) {
                final isSelected = date.year == selectedDate.year &&
                    date.month == selectedDate.month &&
                    date.day == selectedDate.day;
                final isCurrentMonth = date.month == currentMonth.month;
                final isSunday = date.weekday == 7;

                return GestureDetector(
                  onTap: () => onDateSelected(date),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.accentAmber
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isCurrentMonth
                                ? (isSunday
                                    ? AppTheme.statusBatal
                                    : AppTheme.textDark)
                                : AppTheme.textGrey.withValues(alpha: 0.5)),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ),
      ],
    );
  }
}

class _WavePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 5; i++) {
      final path = Path();
      final double offset = i * 40.0;
      path.moveTo(0, 50 + offset);
      path.quadraticBezierTo(
          size.width * 0.25, 10 + offset, size.width * 0.5, 60 + offset);
      path.quadraticBezierTo(
          size.width * 0.75, 110 + offset, size.width, 50 + offset);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
