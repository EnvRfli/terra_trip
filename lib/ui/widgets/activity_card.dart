import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/activity_model.dart';
import '../../theme/app_theme.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final bool showStatusBanner;

  const ActivityCard({
    super.key,
    required this.activity,
    this.showStatusBanner = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bannerColor = Colors.transparent;
    String bannerText = '';

    if (showStatusBanner) {
      switch (activity.status) {
        case ActivityStatus.finished:
          bannerColor = AppTheme.statusSelesai;
          bannerText = 'Selesai';
          break;
        case ActivityStatus.ongoing:
          bannerColor = AppTheme.statusBerlangsung;
          bannerText = 'Sedang Berlangsung';
          break;
        case ActivityStatus.canceled:
          bannerColor = AppTheme.statusBatal;
          bannerText = 'Batal';
          break;
        case ActivityStatus.upcoming:
          // No banner for upcoming usually, or handle if needed
          break;
      }
    }

    final hasBanner = showStatusBanner && bannerText.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // White Content Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Time and Category Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateFormat('HH:mm').format(activity.startTime)} - ${DateFormat('HH:mm').format(activity.endTime)}',
                      style: const TextStyle(
                        color: AppTheme.accentAmber,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    _CategoryBadge(category: activity.category),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Title
                Text(
                  activity.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                
                // Subtitle
                Text(
                  activity.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                
                // Bottom Row: Progress and Cost
                Row(
                  children: [
                    // Progress Bar Background
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundApp,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: 0.7, // Hardcoded for demo based on image
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.accentAmber,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Cost Text
                    Text(
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(activity.estimatedCost),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Optional Status Banner
          if (hasBanner)
            Container(
              color: bannerColor,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                bannerText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;

  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    Color bgColor = AppTheme.badgeLiburan;
    if (category.toLowerCase() == 'kencan') {
      bgColor = AppTheme.badgeKencan;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
