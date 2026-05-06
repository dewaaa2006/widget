import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../config/theme.dart';
import '../widgets/custom_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  bool _fastCheckout = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Pengaturan Akun',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.md),
            PremiumCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Notifikasi Aplikasi'),
                    subtitle: const Text('Aktifkan jika ingin mendapatkan update transaksi dan promo'),
                    value: _notifications,
                    activeThumbColor: AppColors.primary,
                    onChanged: (value) => setState(() => _notifications = value),
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Mode Gelap'),
                    subtitle: const Text('Ubah tampilan aplikasi ke tema gelap'),
                    value: _darkMode,
                    activeThumbColor: AppColors.primary,
                    onChanged: (value) => setState(() => _darkMode = value),
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Checkout Cepat'),
                    subtitle: const Text('Gunakan pengaturan pembayaran default untuk transaksi lebih cepat'),
                    value: _fastCheckout,
                    activeThumbColor: AppColors.primary,
                    onChanged: (value) => setState(() => _fastCheckout = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Layanan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.md),
            PremiumCard(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Iconsax.lock),
                    title: const Text('Privasi & Keamanan'),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Iconsax.global),
                    title: const Text('Bahasa'),
                    subtitle: const Text('Indonesia'),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Iconsax.support),
                    title: const Text('Pusat Bantuan'),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    onTap: () {
                      Navigator.of(context).pushNamed('/help');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
