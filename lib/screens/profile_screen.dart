import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../config/app_helpers.dart';
import '../config/theme.dart';
import '../services/app_state.dart';
import '../widgets/custom_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppState.currentUser;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
            icon: const Icon(Iconsax.edit_2),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryGradient],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Text(
                    user.avatar,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${user.phone} • ${user.email}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withAlphaValue(0.9),
                      ),
                ),
                const SizedBox(height: 14),
                GlassContainer(
                  opacity: 0.16,
                  borderRadius: BorderRadius.circular(18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ProfileMetric(label: 'Saldo', value: formatCurrency(user.balance)),
                      _ProfileMetric(label: 'Level', value: 'Lv ${user.loyaltyLevel}'),
                      const _ProfileMetric(label: 'Verifikasi', value: 'Aman'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ...[
            ('Akun Saya', Iconsax.user_edit, '/edit-profile'),
            ('Keamanan', Iconsax.shield_tick, '/security'),
            ('Metode Pembayaran', Iconsax.card, '/payment-methods'),
            ('Favorit', Iconsax.heart, '/favorites'),
            ('Voucher Saya', Iconsax.ticket_discount, '/voucher'),
            ('Notifikasi', Iconsax.notification, '/notifications'),
            ('Bantuan', Iconsax.message_question, '/help'),
            ('Pengaturan', Iconsax.setting_2, '/settings'),
          ].map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PremiumCard(
                onTap: () => Navigator.pushNamed(context, entry.$3),
                child: Row(
                  children: [
                    Icon(entry.$2, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.$1,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    const Icon(Iconsax.arrow_right_3, color: AppColors.textSecondary),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 6),
          PremiumButton(
            label: 'Keluar',
            backgroundColor: AppColors.errorRed,
            onPressed: () {
              AppState.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
      bottomNavigationBar: UltraBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          final routes = ['/home', '/promo', '/history', '/cart', '/profile'];
          if (index == 4) return;
          Navigator.pushReplacementNamed(context, routes[index]);
        },
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
