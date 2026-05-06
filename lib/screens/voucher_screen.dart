import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../config/theme.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../widgets/custom_widgets.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  String _code = '';
  bool _applied = false;

  void _applyVoucher() {
    final normalized = _code.trim().toUpperCase();
    final exists = VoucherRepository.vouchers.any((voucher) => voucher.code == normalized);
    if (exists) {
      setState(() {
        _applied = true;
      });
      AppState.claimedVoucherCodes.add(normalized);
      _showToast('Voucher $normalized berhasil diterapkan!');
    } else {
      setState(() {
        _applied = false;
      });
      _showToast('Voucher tidak dikenali. Coba ulangi.');
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Voucher & Promo'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Masukkan kode voucher atau pilih promo terbaik untuk transaksi kamu.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PremiumCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) => _code = value,
                      decoration: InputDecoration(
                        hintText: 'ULTRA50',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceLow,
                        suffixIcon: IconButton(
                          onPressed: _applyVoucher,
                          icon: const Icon(Iconsax.tick_circle),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (_applied)
                      StatusChip(
                        label: 'Voucher berhasil diterapkan',
                        backgroundColor: AppColors.successGreen,
                        textColor: AppColors.successGreen,
                        icon: Iconsax.discount_circle,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Voucher Tersedia',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Column(
                children: VoucherRepository.vouchers.map((voucher) {
                  final claimed = AppState.isVoucherClaimed(voucher.code);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: PremiumCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      backgroundColor: AppColors.surfaceCard,
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlphaValue(0.08),
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                            ),
                            child: const Icon(
                              Iconsax.discount_circle,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  voucher.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  voucher.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            voucher.code,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _code = voucher.code;
                                _applied = true;
                              });
                              AppState.claimedVoucherCodes.add(voucher.code);
                              _showToast('Voucher ${voucher.code} siap dipakai');
                            },
                            child: Text(claimed ? 'Dipakai' : 'Pakai'),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
