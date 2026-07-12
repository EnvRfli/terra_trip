import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../theme/app_theme.dart';

class DashboardScheduleSection extends StatelessWidget {
  final DateTime selectedDate;

  const DashboardScheduleSection({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    // Hardcoded logic: show schedules if selectedDate is "today"
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    if (!isToday) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        const _OngoingScheduleCard(),
        const SizedBox(height: 16),
        const _NormalScheduleCard(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIconsRegular.calendarBlank,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "Anda tidak memiliki jadwal pada hari ini.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              // Action to create schedule
            },
            child: const Text(
              "Ingin membuat?",
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OngoingScheduleCard extends StatelessWidget {
  const _OngoingScheduleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.headerGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Arrow background SVG with Gradient
          Positioned(
            top: -40,
            right: -30,
            child: Transform.rotate(
              angle: 0.3, // slight rotation to the left
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFFFD05D), Color(0xFFFF885D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: SvgPicture.asset(
                  'lib/assets/arrow_card_background.svg',
                  width: 140,
                ),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Text(
                  'Sedang Berlangsung',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              // Inner White Card
              Container(
                margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // Wavy background
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.8,
                        child: Image.asset(
                          'lib/assets/wavy_card_background.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '08:00 - 17:00',
                                style: TextStyle(
                                  color: Color(0xFFFFB700),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00C4D4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Liburan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Jakarta's Date 🐠💞",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Melihat aquarium di Jakarta bersama ayang se...",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: 0.7,
                                    minHeight: 12,
                                    backgroundColor: Colors.grey[200],
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      Color(0xFFFFB700),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                "Rp 5.000.000",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NormalScheduleCard extends StatelessWidget {
  const _NormalScheduleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '08:00 - 17:00',
                  style: TextStyle(
                    color: Color(0xFFFFB700),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF66D8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Kencan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "Jakarta's Date 🐠💞",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Melihat aquarium di Jakarta bersama ayang sela...",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 12,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(color: const Color(0xFF48C999)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(color: const Color(0xFFFF4D4F)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(color: const Color(0xFFFFB700)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  "Rp 5.000.000",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
