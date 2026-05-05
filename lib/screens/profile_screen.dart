import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../config/theme.dart';
import '../models/models.dart';
import '../widgets/custom_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User dummyUser = User(
    id: '1',
    name: 'Budi Santoso',
    email: 'budi@example.com',
    phone: '08123456789',
    avatar: '👤',
    balance: 250000,
    loyaltyLevel: 3,
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Icon(Iconsax.edit, color: AppColors.primary),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primaryGradient.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.primaryGradient,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          dummyUser.avatar,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      dummyUser.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dummyUser.email,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Loyalty badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentOrangeBright
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(
                          color: AppColors.accentOrangeBright
                              .withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.star_1,
                            color: AppColors.accentOrangeBright,
                            size: 18,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Member Level ${dummyUser.loyaltyLevel}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.accentOrangeBright,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Menu list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    _ProfileMenuItem(
                      icon: Iconsax.card,
                      title: 'Metode Pembayaran',
                      subtitle: '3 metode tersimpan',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Fitur metode pembayaran segera hadir')),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _ProfileMenuItem(
                      icon: Iconsax.ticket,
                      title: 'Voucher Saya',
                      subtitle: '2 voucher aktif',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Fitur voucher segera hadir')),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _ProfileMenuItem(
                      icon: Iconsax.heart,
                      title: 'Nomor Favorit',
                      subtitle: '5 nomor tersimpan',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Fitur nomor favorit segera hadir')),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _ProfileMenuItem(
                      icon: Iconsax.notification,
                      title: 'Notifikasi',
                      subtitle: 'Atur preferensi notifikasi',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Fitur notifikasi segera hadir')),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _ProfileMenuItem(
                      icon: Iconsax.lock,
                      title: 'Keamanan Akun',
                      subtitle: 'Ubah password dan autentikasi',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Fitur keamanan segera hadir')),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _ProfileMenuItem(
                      icon: Iconsax.info_circle,
                      title: 'Bantuan & FAQ',
                      subtitle: 'Pusat bantuan dan pertanyaan umum',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Fitur bantuan segera hadir')),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Logout button
                    SizedBox(
                      width: double.infinity,
                      child: PremiumButton(
                        label: 'Keluar dari Akun',
                        backgroundColor: AppColors.errorRed,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Keluar?'),
                              content: const Text(
                                  'Apakah Anda yakin ingin keluar dari akun?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed('/login');
                                  },
                                  child: const Text('Keluar'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (index == 1) {
            Navigator.of(context).pushReplacementNamed('/history');
          }
        },
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PremiumCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Iconsax.arrow_right_3,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.border.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Iconsax.home_1,
                label: 'Beranda',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Iconsax.clock,
                label: 'Riwayat',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Iconsax.user,
                label: 'Profil',
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
