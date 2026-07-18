import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import 'timeline_card.dart';

class TimelineList extends StatelessWidget {
  const TimelineList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      children: [
        // Date Pill
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.weatherBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Selasa, 11 Mei 2026',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Timeline Items
        _buildTimelineItem(
          isFirst: true,
          isLast: false,
          dotColor: AppTheme.statusBatal, // red
          child: const TimelineCard(
            time: '09:00 - 12:00',
            title: 'Aquarium',
            subtitle: 'Liat dugong, jadi mermaid, ke rumah sponge...',
            badgeText: 'Batal',
            badgeColor: AppTheme.statusBatal,
            avatarCount: 0,
            hasImages: false,
          ),
        ),
        _buildTimelineItem(
          isFirst: false,
          isLast: false,
          dotColor: AppTheme.accentAmber, // yellow
          isSolidLine: false,
          child: const TimelineCard(
            time: '08:00 - 09:00',
            title: 'Aquarium',
            subtitle: 'Liat dugong, jadi mermaid, ke rumah sponge...',
            badgeText: 'Selesai',
            badgeColor: AppTheme.statusSelesai,
            avatarCount: 4,
            hasImages: true,
            hasIcons: true,
          ),
        ),
        _buildTimelineItem(
          isFirst: false,
          isLast: false,
          dotColor: AppTheme.accentAmber, // yellow
          child: const TimelineCard(
            time: '09:00 - 12:00',
            title: 'Aquarium',
            subtitle: 'Liat dugong, jadi mermaid, ke rumah sponge...',
            badgeText: 'Berlangsung',
            badgeColor: AppTheme.statusBerlangsung,
            avatarCount: 4,
            hasImages: false,
          ),
        ),
        _buildTimelineItem(
          isFirst: false,
          isLast: true,
          dotColor: Colors.grey.shade400, // grey
          child: const TimelineCard(
            time: '09:00 - 12:00',
            title: 'Aquarium',
            subtitle: 'Liat dugong, jadi mermaid, ke rumah sponge...',
            badgeText: 'Menunggu',
            badgeColor: AppTheme.primaryBlue,
            avatarCount: 0,
            hasImages: false,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required Widget child,
    required Color dotColor,
    required bool isFirst,
    required bool isLast,
    bool isSolidLine = true,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Line & Dot
          SizedBox(
            width: 32,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // The vertical line
                Positioned.fill(
                  child: CustomPaint(
                    painter: _TimelinePainter(
                      color: isSolidLine ? Colors.grey.shade300 : dotColor,
                      isSolidLine: isSolidLine,
                      isFirst: isFirst,
                      isLast: isLast,
                    ),
                  ),
                ),
                // The dot
                Positioned(
                  top: 0,
                  bottom: 16.0,
                  child: Center(
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: dotColor, width: 3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // The Card Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final Color color;
  final bool isSolidLine;
  final bool isFirst;
  final bool isLast;

  _TimelinePainter({
    required this.color,
    required this.isSolidLine,
    required this.isFirst,
    required this.isLast,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    final double totalHeight = size.height;
    final double cardHeight = totalHeight - 16.0; // Subtract padding
    final double centerY = cardHeight / 2;

    final double startY = isFirst ? centerY : 0;
    final double endY = isLast ? centerY : totalHeight;

    if (isSolidLine) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, endY),
        paint,
      );
    } else {
      double dashHeight = 5, dashSpace = 5;
      double currentY = startY;
      while (currentY < endY) {
        double nextY = currentY + dashHeight;
        if (nextY > endY) nextY = endY;
        canvas.drawLine(
          Offset(size.width / 2, currentY),
          Offset(size.width / 2, nextY),
          paint,
        );
        currentY += dashHeight + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TimelinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.isSolidLine != isSolidLine ||
        oldDelegate.isFirst != isFirst ||
        oldDelegate.isLast != isLast;
  }
}
