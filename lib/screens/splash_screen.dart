import 'package:flutter/material.dart';
import '../config/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/onboarding');
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Animated background blobs
          Positioned(
            right: -100,
            top: -100,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primaryGradient.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: -150,
            bottom: -150,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accentOrange.withOpacity(0.08),
                      AppColors.accentOrangeBright.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Logo and text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.primaryGradient,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'X',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 72,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Ultra',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              TextSpan(
                                text: '.X',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Top Up Cepat & Mudah',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                    letterSpacing: 0.5,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom progress indicator
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
