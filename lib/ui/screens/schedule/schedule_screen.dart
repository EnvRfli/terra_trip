import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../providers/trip_provider.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/activity_card.dart';

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
  bool _slideLeft = true; // Tracks animation direction

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _currentMonth = DateTime(now.year, now.month, 1);
  }

  void _changeMonth(int increment) {
    setState(() {
      _slideLeft = increment > 0;
      _currentMonth =
          DateTime(_currentMonth.year, _currentMonth.month + increment, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tripProvider = context.watch<TripProvider>();
    final activitiesForSelectedDate =
        tripProvider.getActivitiesForDate(_selectedDate);
    final bool hasActivities = activitiesForSelectedDate.isNotEmpty;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundCard,
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: hasActivities
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _CalendarHeaderDelegate(
                  currentMonth: _currentMonth,
                  selectedDate: _selectedDate,
                  monthNames: _monthNames,
                  slideLeft: _slideLeft,
                  onMonthChange: _changeMonth,
                  onDateSelected: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 160,
                  ),
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
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _WavePatternPainter(),
                          ),
                        ),
                        Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 48.0),
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
                                        borderRadius: BorderRadius.circular(24),
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
                            Consumer<TripProvider>(
                              builder: (context, provider, child) {
                                final activities = provider
                                    .getActivitiesForDate(_selectedDate);

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 24, 16, 100),
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
          padding: const EdgeInsets.only(bottom: 82.0),
          child: FloatingActionButton(
            onPressed: () {
              context.push('/add-schedule');
            },
            shape: const CircleBorder(),
            elevation: 4,
            child: const Icon(PhosphorIconsRegular.plus, size: 28),
          ),
        ),
      ),
    );
  }
}

class _CalendarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final DateTime currentMonth;
  final DateTime selectedDate;
  final List<String> monthNames;
  final bool slideLeft;
  final Function(int) onMonthChange;
  final ValueChanged<DateTime> onDateSelected;

  _CalendarHeaderDelegate({
    required this.currentMonth,
    required this.selectedDate,
    required this.monthNames,
    required this.slideLeft,
    required this.onMonthChange,
    required this.onDateSelected,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final caretOpacity = (1.0 - (progress * 3)).clamp(0.0, 1.0);
    final calendarOpacity = (1.0 - (progress * 1.5)).clamp(0.0, 1.0);

    final expandedTitle =
        '${monthNames[currentMonth.month - 1]} ${currentMonth.year}';
    final collapsedTitle =
        '${selectedDate.day} ${monthNames[selectedDate.month - 1]} ${selectedDate.year}';
    final currentTitle = progress > 0.6 ? collapsedTitle : expandedTitle;

    return ClipRect(
      child: Container(
        color: AppTheme.backgroundCard,
        child: OverflowBox(
          alignment: Alignment.topCenter,
          maxHeight: maxExtent,
          minHeight: maxExtent,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: caretOpacity,
                      child: GestureDetector(
                        onTap:
                            caretOpacity > 0.5 ? () => onMonthChange(-1) : null,
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
                    ),
                    Text(
                      currentTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Opacity(
                      opacity: caretOpacity,
                      child: GestureDetector(
                        onTap:
                            caretOpacity > 0.5 ? () => onMonthChange(1) : null,
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
                    ),
                  ],
                ),
              ),
              if (calendarOpacity > 0) const SizedBox(height: 16),
              Expanded(
                child: Opacity(
                  opacity: calendarOpacity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        final inAnimation = Tween<Offset>(
                          begin: Offset(slideLeft ? 1.0 : -1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation);
                        final outAnimation = Tween<Offset>(
                          begin: Offset(slideLeft ? -1.0 : 1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation);

                        return ClipRect(
                          child: SlideTransition(
                            position: child.key == ValueKey(currentMonth)
                                ? inAnimation
                                : outAnimation,
                            child: child,
                          ),
                        );
                      },
                      child: _CalendarWidget(
                        key: ValueKey(currentMonth),
                        currentMonth: currentMonth,
                        selectedDate: selectedDate,
                        onDateSelected: onDateSelected,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int get _rowCount {
    final int daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final int firstDayWeekday =
        DateTime(currentMonth.year, currentMonth.month, 1).weekday;
    final int startOffset = firstDayWeekday == 7 ? 0 : firstDayWeekday;
    return ((startOffset + daysInMonth) / 7).ceil();
  }

  @override
  double get maxExtent => 120.0 + (_rowCount * 44.0);

  @override
  double get minExtent => 76.0;

  @override
  bool shouldRebuild(covariant _CalendarHeaderDelegate oldDelegate) {
    return oldDelegate.currentMonth != currentMonth ||
        oldDelegate.selectedDate != selectedDate ||
        oldDelegate.slideLeft != slideLeft;
  }
}

class _CalendarWidget extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const _CalendarWidget({
    super.key,
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
