import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../models/models.dart';
import '../widgets/custom_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  final dynamic product;
  final Operator? operator;
  final String phone;
  final String type;

  const CheckoutScreen({
    Key? key,
    required this.product,
    required this.operator,
    required this.phone,
    required this.type,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  PaymentMethodType _selectedPaymentMethod = PaymentMethodType.saldo;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _processPayment() {
    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed(
        '/success',
        arguments: {
          'type': widget.type,
          'amount': widget.product.price,
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final int adminFee = 2500;
    final int totalAmount = widget.product.price + adminFee;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order details
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.3, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0, 0.4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Pesanan',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      PremiumCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.type == 'pulsa'
                                          ? 'Pulsa'
                                          : 'Paket Data',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.type == 'pulsa'
                                          ? 'Rp${widget.product.nominal}'
                                          : widget.product.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  widget.type == 'pulsa'
                                      ? Iconsax.mobile
                                      : Iconsax.wifi,
                                  color: AppColors.primary,
                                  size: 28,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Divider(
                              color: AppColors.border.withOpacity(0.5),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Nomor Tujuan',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.phone,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
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
                // Payment method selection
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.2, 0.6),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Metode Pembayaran',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _PaymentMethodTile(
                        title: 'Saldo Ultra.X',
                        subtitle: 'Rp 250.000',
                        isSelected: _selectedPaymentMethod ==
                            PaymentMethodType.saldo,
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod =
                                PaymentMethodType.saldo;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _PaymentMethodTile(
                        title: 'Virtual Account BCA',
                        subtitle: '1234567890',
                        isSelected: _selectedPaymentMethod ==
                            PaymentMethodType.virtualAccount,
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod =
                                PaymentMethodType.virtualAccount;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _PaymentMethodTile(
                        title: 'E-Wallet GoPay',
                        subtitle: 'Rp 100.000+',
                        isSelected:
                            _selectedPaymentMethod == PaymentMethodType.eWallet,
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod =
                                PaymentMethodType.eWallet;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Price summary
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.4, 0.8),
                    ),
                  ),
                  child: Column(
                    children: [
                      PremiumCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Harga Produk',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                                Text(
                                  'Rp${widget.product.price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Biaya Admin',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                                Text(
                                  'Rp${adminFee.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Divider(
                              color: AppColors.border.withOpacity(0.5),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Pembayaran',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                Text(
                                  'Rp${totalAmount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Confirm button
                      SizedBox(
                        width: double.infinity,
                        child: PremiumButton(
                          label: _isProcessing
                              ? 'Memproses...'
                              : 'Konfirmasi Pembayaran',
                          isLoading: _isProcessing,
                          onPressed:
                              _isProcessing ? () {} : _processPayment,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
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
          ],
        ),
      ),
    );
  }
}
