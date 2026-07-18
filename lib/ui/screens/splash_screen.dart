import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _whiteShapeAnimation;
  late Animation<double> _yellowShapeAnimation;
  late Animation<int> _dotAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _whiteShapeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.33, 0.66, curve: Curves.easeOutBack),
        reverseCurve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    _yellowShapeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 1.0, curve: Curves.easeOutBack),
        reverseCurve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    _dotAnimation = StepTween(begin: 1, end: 4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    _timer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          return Stack(
            children: [
              // Logo and Name
              Align(
                alignment: const Alignment(0, -0.35),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'lib/assets/terra_trip_temp_logo.svg',
                          width: 48,
                          height: 48,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'terratrip',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Loading Dots
                    AnimatedBuilder(
                      animation: _dotAnimation,
                      builder: (context, child) {
                        int activeDots = _dotAnimation.value.clamp(1, 3);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index < activeDots
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.3),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Yellow Shape (Behind)
              AnimatedBuilder(
                animation: _yellowShapeAnimation,
                builder: (context, child) {
                  return Positioned(
                    left: -40,
                    right: -40,
                    bottom: -80,
                    height: 400,
                    child: Transform.translate(
                      offset: Offset(
                          0, screenHeight * 0.5 * _yellowShapeAnimation.value),
                      child: Transform.rotate(
                        angle: 0.1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB700),
                            borderRadius: BorderRadius.circular(80),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFB700)
                                    .withValues(alpha: 0.6),
                                blurRadius: 40,
                                spreadRadius: 10,
                                offset: const Offset(0, -10),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // White Shape (Front)
              AnimatedBuilder(
                animation: _whiteShapeAnimation,
                builder: (context, child) {
                  return Positioned(
                    left: -20,
                    right: -20,
                    bottom: -50,
                    height: 250,
                    child: Transform.translate(
                      offset: Offset(
                          0, screenHeight * 0.5 * _whiteShapeAnimation.value),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
