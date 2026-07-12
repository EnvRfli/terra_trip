import 'package:flutter/material.dart';
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
  final List<String> _filters = ['Semua', 'Selesai', 'Batal', 'Sedang Berlangsung'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCard,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Month
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundApp,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(PhosphorIconsRegular.caretLeft, color: AppTheme.primaryBlue, size: 20),
                  ),
                  Text(
                    'Oktober',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundApp,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(PhosphorIconsRegular.caretRight, color: AppTheme.primaryBlue, size: 20),
                  ),
                ],
              ),
            ),
            
            // Calendar Grid
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: _CalendarWidget(),
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
                              children: List.generate(_filters.length, (index) {
                                final isSelected = _selectedFilterIndex == index;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() => _selectedFilterIndex = index);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Text(
                                      _filters[index],
                                      style: TextStyle(
                                        color: isSelected ? AppTheme.primaryBlue : Colors.white,
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
                                final activities = provider.getActivitiesForDate(DateTime(2026, 10, 16));
                                
                                return ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
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
    );
  }
}

class _CalendarWidget extends StatelessWidget {
  const _CalendarWidget();

  @override
  Widget build(BuildContext context) {
    final days = ['MIN', 'SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB'];
    
    return Column(
      children: [
        // Day Names
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
        // Dates (Mocked grid based on image)
        Table(
          children: [
            _buildWeekRow([29, 30, 1, 2, 3, 4, 5], startHighlight: [29, 30], highlightColor: AppTheme.accentAmber.withValues(alpha: 0.2)),
            _buildWeekRow([6, 7, 8, 9, 10, 11, 12]),
            _buildWeekRow([13, 14, 15, 16, 17, 18, 19], selectedDate: 16),
            _buildWeekRow([20, 21, 22, 23, 24, 25, 26], startHighlight: [24, 25, 26], highlightColor: AppTheme.statusSelesai.withValues(alpha: 0.3)),
            _buildWeekRow([27, 28, 29, 30, 31, 1, 2], startHighlight: [27, 28], highlightColor: AppTheme.statusBatal.withValues(alpha: 0.3)),
          ],
        ),
      ],
    );
  }

  TableRow _buildWeekRow(List<int> dates, {int? selectedDate, List<int>? startHighlight, Color? highlightColor}) {
    return TableRow(
      children: dates.map((date) {
        final isSelected = date == selectedDate;
        final isHighlighted = startHighlight != null && startHighlight.contains(date);
        
        return Container(
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.accentAmber : (isHighlighted ? highlightColor : Colors.transparent),
            shape: isSelected ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isHighlighted ? BorderRadius.circular(20) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            date.toString(),
            style: TextStyle(
              color: isSelected ? Colors.white : (date > 28 && !isHighlighted && selectedDate == null ? Colors.grey : AppTheme.textDark),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
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
      path.quadraticBezierTo(size.width * 0.25, 10 + offset, size.width * 0.5, 60 + offset);
      path.quadraticBezierTo(size.width * 0.75, 110 + offset, size.width, 50 + offset);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
