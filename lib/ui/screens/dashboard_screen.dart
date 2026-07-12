import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_theme.dart';

import 'dashboard/widgets/dashboard_header.dart';
import 'dashboard/widgets/dashboard_date_selector.dart';
import 'dashboard/widgets/dashboard_section_header.dart';
import 'dashboard/widgets/dashboard_weather_card.dart';
import 'dashboard/widgets/dashboard_schedule_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundApp,
        body: Stack(
          children: [
            // Background Gradient (only for the top section)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 350, // Matches height of header before white overlap
              child: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.headerGradient,
                ),
              ),
            ),

            // Background Pattern (SVG)
            Positioned(
              top: -150,
              left: -60,
              child: Transform.rotate(
                angle: 0.2, // Slight rotation
                child: SvgPicture.asset(
                  'lib/assets/arrow_background.svg',
                  width: 350,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withValues(alpha: 0.05),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),

            // Main Content
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Header Content
                  const DashboardHeader(
                    greeting: 'Selamat Datang, 👋',
                    userName: 'Trio Dwi Pratama',
                  ),

                  SizedBox(height: 6),
                  DashboardDateSelector(
                    selectedDate: selectedDate,
                    onDateChanged: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Overlapping Body
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppTheme.backgroundApp,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              DashboardSectionHeader(
                                title: 'Jadwal Hari Ini',
                                onActionTap: () {},
                              ),
                              const SizedBox(height: 16),
                              DashboardScheduleSection(
                                selectedDate: selectedDate,
                              ),
                              const SizedBox(height: 42),
                              DashboardSectionHeader(
                                title: 'Cuaca',
                                onActionTap: () {},
                              ),
                              const SizedBox(height: 16),
                              const DashboardWeatherCard(),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
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
}
