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
    if (location.startsWith('/dashboard')) { _currentIndex = 0; }
    else if (location.startsWith('/schedule')) { _currentIndex = 1; }
    else if (location.startsWith('/profile')) { _currentIndex = 2; }

    return Scaffold(
      extendBody: true,
      body: widget.child,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = 80;

    return SizedBox(
      height: height + 20, // Extra space for the floating item
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: size.width,
              height: height,
              child: CustomPaint(
                painter: _BottomNavCurvePainter(currentIndex: currentIndex),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: height + 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _NavBarItem(
                    icon: PhosphorIcons.house(),
                    label: 'Beranda',
                    isSelected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _NavBarItem(
                    icon: PhosphorIcons.calendarBlank(),
                    label: 'Jadwal',
                    isSelected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  _NavBarItem(
                    icon: PhosphorIcons.user(),
                    label: 'Profil',
                    isSelected: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isSelected)
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              )
            else
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 28.0),
                child: Icon(icon, color: AppTheme.textGrey, size: 28),
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.primaryBlue : AppTheme.textGrey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _BottomNavCurvePainter extends CustomPainter {
  final int currentIndex;

  _BottomNavCurvePainter({required this.currentIndex});

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
    final double width = size.width;
    final double height = size.height;
    
    // Width of each segment
    final double segmentWidth = width / 3;
    // Center x of the active item
    final double activeCenterX = (segmentWidth * currentIndex) + (segmentWidth / 2);
    
    final double curveWidth = 80;
    final double curveHeight = 30;

    path.moveTo(0, 0);

    // Draw straight line to the start of the curve
    if (activeCenterX - curveWidth / 2 > 0) {
      path.lineTo(activeCenterX - curveWidth / 2, 0);
    }

    // Draw the upward curve (bump)
    path.cubicTo(
      activeCenterX - curveWidth / 4, 0,
      activeCenterX - curveWidth / 4, -curveHeight,
      activeCenterX, -curveHeight,
    );
    
    path.cubicTo(
      activeCenterX + curveWidth / 4, -curveHeight,
      activeCenterX + curveWidth / 4, 0,
      activeCenterX + curveWidth / 2, 0,
    );

    // Draw straight line to the end
    path.lineTo(width, 0);
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BottomNavCurvePainter oldDelegate) {
    return oldDelegate.currentIndex != currentIndex;
  }
}
