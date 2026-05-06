import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../config/theme.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../widgets/custom_widgets.dart';

class PromoCenterScreen extends StatefulWidget {
  const PromoCenterScreen({super.key});

  @override
  State<PromoCenterScreen> createState() => _PromoCenterScreenState();
}

class _PromoCenterScreenState extends State<PromoCenterScreen> {
  String _selectedFilter = 'Semua';

  List<Promo> get _promos {
    return PromoRepository.promos.where((promo) {
      if (_selectedFilter == 'Semua') return true;
      if (_selectedFilter == 'Cashback') {
        return promo.title.toLowerCase().contains('cashback');
      }
      if (_selectedFilter == 'Bebas Admin') {
        return promo.title.toLowerCase().contains('admin');
      }
      return promo.description.toLowerCase().contains('top up') ||
          promo.subtitle.toLowerCase().contains('top up');
    }).toList();
  }

  void _claimPromo(Promo promo) {
    if (AppState.isPromoClaimed(promo.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${promo.title} sudah pernah diklaim')),
      );
      return;
    }

    AppState.claimPromo(
      promo.id,
      voucherCode: promo.code,
      title: promo.title,
    );
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${promo.title} berhasil diklaim')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final promos = _promos;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Promo Center'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Penawaran eksklusif untuk kamu',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Dapatkan cashback, bebas admin, dan voucher khusus pengguna Ultra.X.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Semua', 'Cashback', 'Bebas Admin', 'Top Up']
                    .map(
                      (filter) => Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          onSelected: (_) {
                            setState(() => _selectedFilter = filter);
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: promos.length,
                itemBuilder: (context, index) {
                  final promo = promos[index];
                  final claimed = AppState.isPromoClaimed(promo.id);
                  return Padding(
                    padding: EdgeInsets.only(right: index == promos.length - 1 ? 0 : AppSpacing.md),
                    child: Container(
                      width: 320,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: promo.gradient,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.xxl),
                        boxShadow: [
                          BoxShadow(
                            color: promo.gradient.last.withAlphaValue(0.16),
                            blurRadius: 24,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  promo.title,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                              ),
                              const Icon(
                                Iconsax.ticket_discount,
                                color: Color.fromRGBO(255, 255, 255, 0.85),
                                size: 32,
                              ),
                            ],
                          ),
                          Text(
                            promo.subtitle,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: const Color.fromRGBO(255, 255, 255, 0.9),
                                ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    promo.discountLabel,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  if (promo.code != null)
                                    Text(
                                      promo.code!,
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: Colors.white70,
                                          ),
                                    ),
                                ],
                              ),
                              TextButton(
                                onPressed: claimed ? null : () => _claimPromo(promo),
                                style: TextButton.styleFrom(
                                  backgroundColor: claimed
                                      ? const Color.fromRGBO(255, 255, 255, 0.10)
                                      : const Color.fromRGBO(255, 255, 255, 0.18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppRadius.xl),
                                  ),
                                ),
                                child: Text(
                                  claimed ? 'Terklaim' : 'Klaim',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Promo Terkini',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.md),
            Column(
              children: promos
                  .map(
                    (promo) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: PremiumCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.primary.withAlphaValue(0.12),
                              child: const Icon(
                                Iconsax.flash_1,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    promo.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    promo.subtitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    promo.code == null ? 'Tanpa kode' : 'Kode: ${promo.code}',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  promo.discountLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: AppColors.accentOrangeBright, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                InkWell(
                                  onTap: () => _claimPromo(promo),
                                  child: Text(
                                    AppState.isPromoClaimed(promo.id) ? 'Sudah diklaim' : 'Klaim sekarang',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            PremiumCard(
              backgroundColor: AppColors.surfaceLow,
              child: Row(
                children: [
                  const Icon(Iconsax.ticket_discount, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Promo yang diklaim akan otomatis ditambahkan ke halaman voucher.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/voucher'),
                    child: const Text('Lihat'),
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
