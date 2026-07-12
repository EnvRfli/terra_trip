import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/trip_provider.dart';
import '../../theme/app_theme.dart';
import '../../models/activity_model.dart';
import '../widgets/activity_card.dart';
import 'dashboard/widgets/dashboard_header.dart';
import 'dashboard/widgets/dashboard_date_selector.dart';
import 'dashboard/widgets/dashboard_section_header.dart';
import 'dashboard/widgets/dashboard_weather_card.dart';
import 'dashboard/widgets/dashboard_ongoing_activity.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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

                  // Horizontal Date Selector
                  const DashboardDateSelector(),

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
                              // Schedule Header
                              DashboardSectionHeader(
                                title: 'Jadwal Hari Ini',
                                onActionTap: () {},
                              ),
                              const SizedBox(height: 16),

                              // Active Activity
                              Consumer<TripProvider>(
                                builder: (context, provider, child) {
                                  final activities =
                                      provider.getActivitiesForDate(DateTime(
                                          2026,
                                          10,
                                          16)); // Using dummy base date
                                  if (activities.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  final ongoing = activities
                                      .where((a) =>
                                          a.status == ActivityStatus.ongoing)
                                      .toList();
                                  final others = activities
                                      .where((a) =>
                                          a.status != ActivityStatus.ongoing)
                                      .toList();

                                  return Column(
                                    children: [
                                      if (ongoing.isNotEmpty) ...[
                                        DashboardOngoingActivity(
                                            activity: ongoing.first),
                                        const SizedBox(height: 16),
                                      ],
                                      // Show next upcoming activity as standard card
                                      if (others.isNotEmpty)
                                        ActivityCard(
                                            activity: others.first,
                                            showStatusBanner: false),
                                    ],
                                  );
                                },
                              ),

                              const SizedBox(height: 24),

                              // Weather Section
                              DashboardSectionHeader(
                                title: 'Cuaca',
                                onActionTap: () {},
                              ),
                              const SizedBox(height: 16),

                              // Weather Card
                              const DashboardWeatherCard(),

                              // Extra bottom padding for floating nav bar
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
