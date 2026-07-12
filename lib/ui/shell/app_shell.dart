import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../theme/app_theme.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  void _onItemTapped(int index, BuildContext context) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/schedule');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine current index based on route
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/dashboard')) {
      _currentIndex = 0;
    } else if (location.startsWith('/schedule')) {
      _currentIndex = 1;
    } else if (location.startsWith('/profile')) {
      _currentIndex = 2;
    }

    return Scaffold(
      extendBody: true,
      body: widget.child,
      bottomNavigationBar: CurvedBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onItemTapped(index, context),
        items: [
          NavBarItemData(icon: PhosphorIcons.house(), label: 'Beranda'),
          NavBarItemData(icon: PhosphorIcons.calendarBlank(), label: 'Jadwal'),
          NavBarItemData(icon: PhosphorIcons.user(), label: 'Profil'),
        ],
      ),
    );
  }
}

class NavBarItemData {
  final IconData icon;
  final String label;
  NavBarItemData({required this.icon, required this.label});
}

class CurvedBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavBarItemData> items;

  const CurvedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<CurvedBottomNavBar> createState() => _CurvedBottomNavBarState();
}

class _CurvedBottomNavBarState extends State<CurvedBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _oldIndex = 0;

  @override
  void initState() {
    super.initState();
    _oldIndex = widget.currentIndex;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(
      begin: _oldIndex.toDouble(),
      end: widget.currentIndex.toDouble(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void didUpdateWidget(covariant CurvedBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _oldIndex = oldWidget.currentIndex;
      _animation = Tween<double>(
        begin: _oldIndex.toDouble(),
        end: widget.currentIndex.toDouble(),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ));
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const double horizontalPadding =
        32.0; // Margin from edges to push items to center
    final availableWidth = size.width - (horizontalPadding * 2);
    final itemWidth = availableWidth / widget.items.length;
    const double navBarHeight = 80.0;
    const double domeHeight = 35.0; // Height of the bump

    return SizedBox(
      height: navBarHeight + domeHeight,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final currentAnimValue = _animation.value;
          final activeCenterX = horizontalPadding +
              (currentAnimValue * itemWidth) +
              (itemWidth / 2);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. White Background with Dome
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: navBarHeight + domeHeight,
                child: CustomPaint(
                  painter: _DomePainter(
                    activeCenterX: activeCenterX,
                    navBarHeight: navBarHeight,
                    domeHeight: domeHeight,
                  ),
                ),
              ),

              // 2. Navigation Items
              Positioned(
                bottom: 0,
                left: horizontalPadding,
                right: horizontalPadding,
                height: navBarHeight + domeHeight,
                child: Row(
                  children: List.generate(widget.items.length, (index) {
                    final item = widget.items[index];
                    final distance = (currentAnimValue - index).abs();
                    final progress = (1.0 - distance).clamp(0.0, 1.0);

                    return GestureDetector(
                      onTap: () => widget.onTap(index),
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        width: itemWidth,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            // Text
                            Positioned(
                              bottom: 20,
                              child: Text(
                                item.label,
                                style: TextStyle(
                                  color: Color.lerp(
                                    AppTheme.textGrey,
                                    AppTheme.primaryBlue,
                                    progress,
                                  ),
                                  fontSize: 12,
                                  fontWeight: progress > 0.5
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            // Circle Icon
                            Positioned(
                              bottom: 26 +
                                  (progress *
                                      27), // Ends at 53 (concentric), starts at 26 (closer to text)
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: progress > 0.5
                                      ? AppTheme.primaryBlue
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                  boxShadow: progress > 0.5
                                      ? [
                                          BoxShadow(
                                            color: AppTheme.primaryBlue
                                                .withValues(
                                                    alpha: 0.3 * progress),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Center(
                                  child: Icon(
                                    item.icon,
                                    color: Color.lerp(
                                      AppTheme.textGrey,
                                      Colors.white,
                                      progress,
                                    ),
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DomePainter extends CustomPainter {
  final double activeCenterX;
  final double navBarHeight;
  final double domeHeight;

  _DomePainter({
    required this.activeCenterX,
    required this.navBarHeight,
    required this.domeHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final path = Path();

    // Coordinates setup
    final double yFlat = domeHeight; // Baseline of the navbar (35.0)
    final double cx = activeCenterX;

    final double fxOffset = 50.54;
    final double txOffset = 31.83; // Tangent X offset from center
    final double ty = 22.03; // Tangent Y coordinate

    path.moveTo(0, yFlat);

    if (cx - fxOffset > 0) {
      path.lineTo(cx - fxOffset, yFlat);
    }

    // Left fillet
    path.arcToPoint(
      Offset(cx - txOffset, ty),
      radius: const Radius.circular(20),
      clockwise: false, // Bends upwards
    );

    // Center dome (perfect semicircle)
    path.arcToPoint(
      Offset(cx + txOffset, ty),
      radius: const Radius.circular(34),
      clockwise: true, // Wraps around the circle
    );

    // Right fillet
    path.arcToPoint(
      Offset(cx + fxOffset, yFlat),
      radius: const Radius.circular(20),
      clockwise: false, // Bends downwards to flat
    );

    path.lineTo(size.width, yFlat);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Draw shadow first
    canvas.drawPath(path, shadowPaint);
    // Draw the white navbar
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DomePainter oldDelegate) {
    return oldDelegate.activeCenterX != activeCenterX;
  }
}
