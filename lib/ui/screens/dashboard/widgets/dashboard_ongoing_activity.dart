import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../../../models/activity_model.dart';
import '../../../widgets/activity_card.dart';

class DashboardOngoingActivity extends StatelessWidget {
  final ActivityModel activity;

  const DashboardOngoingActivity({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background pattern (simplified as an overlapping curved shape)
          Positioned(
            top: -20,
            right: -20,
            child: CustomPaint(
              size: const Size(100, 100),
              painter: _AccentLinePainter(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Text(
                    'Sedang Berlangsung',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 2, right: 2, bottom: 2),
                  child: ActivityCard(
                    activity: activity,
                    showStatusBanner: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccentLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentAmber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, size.height / 2, size.width, 0);

    final path2 = Path();
    path2.moveTo(size.width * 0.3, size.height);
    path2.quadraticBezierTo(
        size.width * 0.8, size.height * 0.8, size.width, size.height * 0.3);

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
