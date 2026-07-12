import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class DashboardWeatherCard extends StatelessWidget {
  const DashboardWeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppTheme.weatherBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.weatherBlue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Gradient Pattern
          Positioned.fill(
            child: Row(
              children: List.generate(6, (index) {
                final double opacity = (15 - (index * 3)) / 100.0;
                return Expanded(
                  child: Container(
                    color: Colors.white.withValues(alpha: opacity),
                  ),
                );
              }),
            ),
          ),

          // Content Layer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jakarta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '32° C',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cerah Berawan',
                      style: TextStyle(
                        color: AppTheme.accentAmber,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                // Cloud Icon Emoji
                const Text(
                  '⛅',
                  style: TextStyle(fontSize: 72),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
