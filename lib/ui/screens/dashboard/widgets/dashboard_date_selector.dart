import 'package:flutter/material.dart';

class DashboardDateSelector extends StatefulWidget {
  const DashboardDateSelector({super.key});

  @override
  State<DashboardDateSelector> createState() => _DashboardDateSelectorState();
}

class _DashboardDateSelectorState extends State<DashboardDateSelector> {
  late DateTime selectedDate;
  late List<DateTime> dates;
  late ScrollController _scrollController;

  final int _totalDays = 30; // Generate a month's worth of dates
  final int _initialIndex = 14; // Index for "today"

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day);

    // Generate dates around today
    dates = List.generate(_totalDays,
        (index) => selectedDate.add(Duration(days: index - _initialIndex)));

    _scrollController = ScrollController();

    // Defer the initial scroll until after layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToIndex(_initialIndex, animate: false);
    });
  }

  void _scrollToIndex(int index, {bool animate = true}) {
    if (!mounted) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 5.5; // ~5.5 items visible
    const padding = 20.0;

    // Calculate offset to bring the selected index near the center
    double offset =
        (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2) + padding;
    if (offset < 0) {
      offset = 0;
    }

    // Ensure we don't scroll past the max extent
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (offset > maxScroll) {
        offset = maxScroll;
      }
    }

    if (animate && _scrollController.hasClients) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else if (_scrollController.hasClients) {
      _scrollController.jumpTo(offset);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 5.5;

    return SizedBox(
      height: 100,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = date == selectedDate;
          final daysShort = ['SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB', 'MIN'];
          final dayName = daysShort[date.weekday - 1];
          final dateStr = date.day.toString();

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
              _scrollToIndex(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.bounceInOut, // Playful bouncy curve
              width: itemWidth - 8,
              margin: EdgeInsets.only(
                left: 4,
                right: 4,
                top: isSelected ? 4 : 16,
                bottom: isSelected ? 20 : 8,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFFB700)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFFFB700).withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        )
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSelected ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                    child: Text(dateStr),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
