import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class CustomTabBar extends StatefulWidget {
  final TabController tabController;

  const CustomTabBar({
    super.key,
    required this.tabController,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabSelection);
    super.dispose();
  }

  void _handleTabSelection() {
    if (widget.tabController.indexIsChanging ||
        widget.tabController.index == widget.tabController.animation?.value) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.tabController.animation!,
      builder: (context, child) {
        final double animationValue = widget.tabController.animation!.value;
        final int currentIndex = animationValue.round();

        return Container(
          height: 60,
          color: Colors
              .transparent, // Background is transparent to show header gradient
          child: Stack(
            children: [
              // 1. The custom painted white background
              Positioned.fill(
                child: CustomPaint(
                  painter:
                      _TabBackgroundPainter(animationValue: animationValue),
                ),
              ),
              // 2. The tab texts
              Row(
                children: [
                  _buildTab(
                    title: 'Jadwal',
                    isSelected: currentIndex == 0,
                    onTap: () => widget.tabController.animateTo(0),
                  ),
                  _buildTab(
                    title: 'Deskripsi',
                    isSelected: currentIndex == 1,
                    onTap: () => widget.tabController.animateTo(1),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 60,
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFFFF5EC2) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _TabBackgroundPainter extends CustomPainter {
  final double animationValue;

  _TabBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.backgroundApp
      ..style = PaintingStyle.fill;

    final double w = size.width;
    final double h = size.height;
    final double tabWidth = w / 2;

    final double t = animationValue; // 0.0 to 1.0
    final double startX = t * tabWidth;
    final double endX = startX + tabWidth;

    // The maximum horizontal distance the curve takes
    const double maxCurveWidth = 24.0;

    // Scale the curve width based on animation value so it flattens at the edges
    final double cwLeft = t * maxCurveWidth;
    final double cwRight = (1 - t) * maxCurveWidth;

    final Path path = Path();
    path.moveTo(0, h);

    // Bottom left to start of left curve
    path.lineTo(startX - cwLeft, h);

    // Left S-Curve
    path.cubicTo(
      startX,
      h,
      startX,
      0,
      startX + cwLeft,
      0,
    );

    // Top edge to start of right curve
    path.lineTo(endX - cwRight, 0);

    // Right S-Curve
    path.cubicTo(
      endX,
      0,
      endX,
      h,
      endX + cwRight,
      h,
    );

    // Bottom right to end
    path.lineTo(w, h);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TabBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
