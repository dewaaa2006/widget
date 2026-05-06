import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../services/app_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late AnimationController _animationController;

  final List<OnboardingItem> items = [
    OnboardingItem(
      title: 'Top Up Pulsa\nSuper Cepat',
      subtitle: 'Isi pulsa ke nomor manapun hanya dalam hitungan detik. Proses otomatis dan aman.',
      icon: Iconsax.mobile,
      gradient: [AppColors.primary, AppColors.primaryGradient],
    ),
    OnboardingItem(
      title: 'Promo Provider\nTerbaik',
      subtitle: 'Nikmati penawaran eksklusif dari semua operator dengan diskon menarik setiap hari.',
      icon: Iconsax.gift,
      gradient: [AppColors.accentOrangeBright, AppColors.accentOrange],
    ),
    OnboardingItem(
      title: 'Transaksi Aman\n& Terpercaya',
      subtitle: 'Riwayat lengkap, notifikasi real-time, dan dukungan customer service 24/7.',
      icon: Iconsax.shield_tick,
      gradient: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    AppState.completeOnboarding();
    if (_currentPage < items.length - 1) {
      _pageController.nextPage(
        duration: AppAnimations.normal,
        curve: Curves.easeInOutQuart,
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void _skipOnboarding() {
    AppState.completeOnboarding();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            left: -120,
            top: -100,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withAlphaValue(0.14),
                    AppColors.primaryGradient.withAlphaValue(0.08),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -100,
            bottom: -120,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accentOrange.withAlphaValue(0.12),
                    AppColors.accentOrangeBright.withAlphaValue(0.06),
                  ],
                ),
              ),
            ),
          ),
          // Page view
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
                _animationController.reset();
                _animationController.forward();
              });
            },
            itemCount: items.length,
            itemBuilder: (context, index) {
              return OnboardingPage(
                item: items[index],
                animationController: _animationController,
              );
            },
          ),
          // Skip button
          Positioned(
            top: 40,
            right: 16,
            child: TextButton(
              onPressed: _skipOnboarding,
              child: Text(
                'Lewati',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          // Bottom section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  // Indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      items.length,
                      (index) {
                        final isActive = index == _currentPage;
                        return AnimatedContainer(
                          duration: AppAnimations.fast,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: isActive ? 32 : 10,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: isActive
                                ? items[_currentPage].gradient.first
                                : AppColors.border,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _goToNextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: items[_currentPage].gradient.first,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage == items.length - 1
                            ? 'Mulai Sekarang'
                            : 'Lanjutkan',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ),
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

class OnboardingItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;

  OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;
  final AnimationController animationController;

  const OnboardingPage({
    super.key,
    required this.item,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutQuart),
    );

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOutQuad),
    );

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container
              ScaleTransition(
                scale: scaleAnimation,
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: item.gradient,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: item.gradient.first.withAlphaValue(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      item.icon,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              // Title
              FadeTransition(
                opacity: fadeAnimation,
                child: Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle
              FadeTransition(
                opacity: fadeAnimation,
                child: Text(
                  item.subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
