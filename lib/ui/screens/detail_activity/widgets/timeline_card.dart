import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class TimelineCard extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;
  final int avatarCount;
  final bool hasImages;
  final bool hasIcons;

  const TimelineCard({
    super.key,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
    this.avatarCount = 0,
    this.hasImages = false,
    this.hasIcons = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Time, Icons, Badge
          Row(
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: AppTheme.accentAmber,
                  fontWeight: 
FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              if (hasIcons) ...[
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentAmber.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.attach_money,
                    size: 16,
                    color: AppTheme.accentAmber,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.visibility_off,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Title
          Text(
            title + ' 🐠💞', // Hardcoded emoji based on design
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          
          // Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textGrey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          if (avatarCount > 0 || hasImages) const SizedBox(height: 16),
          
          // Bottom Row: Avatars & Images
          if (avatarCount > 0 || hasImages)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (avatarCount > 0)
                  SizedBox(
                    height: 32,
                    width: 32.0 * avatarCount + 10, // Approximate width
                    child: Stack(
                      children: List.generate(avatarCount, (index) {
                        return Positioned(
                          left: index * 20.0,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              color: AppTheme.primaryBlue, // placeholder color
                            ),
                            child: index == avatarCount - 1
                                ? const Center(
                                    child: Text(
                                      '+3',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : ClipOval(
                                    child: Image.asset(
                                      'lib/assets/State=${index + 1}.jpg', // Use our new jpgs
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        );
                      }),
                    ),
                  ),
                const Spacer(),
                if (hasImages)
                  SizedBox(
                    height: 50,
                    width: 100, // Approximate width for 3 tilted images
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Positioned(
                          right: 40,
                          child: Transform.rotate(
                            angle: -0.2,
                            child: _buildPlaceholderImage(Colors.blue.shade300),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          child: _buildPlaceholderImage(Colors.teal.shade300),
                        ),
                        Positioned(
                          right: 0,
                          child: Transform.rotate(
                            angle: 0.2,
                            child: _buildPlaceholderImage(Colors.orange.shade300),
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

  Widget _buildPlaceholderImage(Color color) {
    return Container(
      width: 35,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}
