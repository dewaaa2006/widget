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

  Future<void> _addMethod() async {
    final created = await showModalBottomSheet<PaymentMethod>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final nameController = TextEditingController();
        final digitController = TextEditingController();
        PaymentMethodType selectedType = PaymentMethodType.virtualAccount;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tambah metode pembayaran',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: 'Contoh: BNI Virtual Account'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: digitController,
                    decoration: const InputDecoration(hintText: '4 digit terakhir'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<PaymentMethodType>(
                    initialValue: selectedType,
                    items: const [
                      DropdownMenuItem(value: PaymentMethodType.virtualAccount, child: Text('Virtual Account')),
                      DropdownMenuItem(value: PaymentMethodType.eWallet, child: Text('E-Wallet')),
                      DropdownMenuItem(value: PaymentMethodType.qris, child: Text('QRIS')),
                    ],
                    onChanged: (value) {
                      setSheetState(() {
                        selectedType = value ?? PaymentMethodType.virtualAccount;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PremiumButton(
                    label: 'Simpan Metode',
                    onPressed: () {
                      if (nameController.text.trim().isEmpty) return;
                      Navigator.pop(
                        context,
                        PaymentMethod(
                          id: 'PM${DateTime.now().millisecondsSinceEpoch}',
                          type: selectedType,
                          displayName: nameController.text.trim(),
                          subtitle: digitController.text.trim().isEmpty
                              ? 'Baru ditambahkan'
                              : '•••• ${digitController.text.trim()}',
                          icon: selectedType == PaymentMethodType.eWallet
                              ? Iconsax.wallet
                              : selectedType == PaymentMethodType.qris
                                  ? Iconsax.scan_barcode
                                  : Iconsax.bank,
                          lastDigits: digitController.text.trim(),
                          isDefault: false,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (created != null) {
      if (!mounted) return;
      setState(() {
        PaymentMethodRepository.addMethod(created);
        _selectedId = created.id;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${created.displayName} berhasil ditambahkan')),
      );
    }
  }

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
                  onPressed: _addMethod,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
