import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../config/theme.dart';
import '../models/models.dart';
import '../widgets/custom_widgets.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _selectedId = PaymentMethodRepository.methods.first.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Metode Pembayaran'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih metode pembayaran yang ingin Anda gunakan untuk transaksi Ultra.X.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...PaymentMethodRepository.methods.map((method) {
                final isSelected = _selectedId == method.id;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedId = method.id;
                  }),
                  child: PremiumCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    elevation: isSelected ? 6 : 0,
                    backgroundColor: isSelected
                        ? AppColors.primary.withAlphaValue(0.08)
                        : AppColors.surfaceCard,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: isSelected
                              ? AppColors.primary
                              : AppColors.surfaceLow,
                          child: Icon(
                            method.icon,
                            color: isSelected ? Colors.white : AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method.displayName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                method.subtitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected ? Iconsax.tick_square : Iconsax.arrow_right_3,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: PremiumButton(
                  label: 'Tambah Metode Baru',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tambah metode segera hadir')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
