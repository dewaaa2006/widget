import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../models/models.dart';
import '../widgets/custom_widgets.dart';

class PulsaScreen extends StatefulWidget {
  const PulsaScreen({Key? key}) : super(key: key);

  @override
  State<PulsaScreen> createState() => _PulsaScreenState();
}

class _PulsaScreenState extends State<PulsaScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _phoneController = TextEditingController();
  Operator? _selectedOperator;
  PulsaProduct? _selectedProduct;

  final List<PulsaProduct> _pulsaProducts = [
    PulsaProduct(
      id: '1',
      nominal: 10000,
      price: 10000,
      originalPrice: 10000,
      discount: 0,
    ),
    PulsaProduct(
      id: '2',
      nominal: 25000,
      price: 23750,
      originalPrice: 25000,
      discount: 5,
      isPromo: true,
      promoLabel: '-5%',
    ),
    PulsaProduct(
      id: '3',
      nominal: 50000,
      price: 47500,
      originalPrice: 50000,
      discount: 5,
      isPromo: true,
      promoLabel: '-5%',
    ),
    PulsaProduct(
      id: '4',
      nominal: 100000,
      price: 95000,
      originalPrice: 100000,
      discount: 5,
      isPromo: true,
      promoLabel: '-5%',
    ),
  ];

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
    _phoneController.dispose();
    super.dispose();
  }

  void _detectOperator() {
    final phone = _phoneController.text;
    if (phone.isEmpty) return;

    Operator? detected;
    if (phone.startsWith('0811') || phone.startsWith('0812') || phone.startsWith('0813') || phone.startsWith('0821') || phone.startsWith('0822') || phone.startsWith('0823')) {
      detected = Operator.telkomsel;
    } else if (phone.startsWith('0817') || phone.startsWith('0818') || phone.startsWith('0819') || phone.startsWith('0859') || phone.startsWith('0877') || phone.startsWith('0878')) {
      detected = Operator.xl;
    } else if (phone.startsWith('0814') || phone.startsWith('0815') || phone.startsWith('0816') || phone.startsWith('0855') || phone.startsWith('0856') || phone.startsWith('0857')) {
      detected = Operator.indosat;
    } else if (phone.startsWith('0892') || phone.startsWith('0893') || phone.startsWith('0899')) {
      detected = Operator.tri;
    } else if (phone.startsWith('0881') || phone.startsWith('0882') || phone.startsWith('0883') || phone.startsWith('0888') || phone.startsWith('0889')) {
      detected = Operator.smartfren;
    }

    if (detected != null) {
      setState(() {
        _selectedOperator = detected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Beli Pulsa'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Phone input section
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
                        'Nomor Tujuan',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        onChanged: (_) {
                          _detectOperator();
                        },
                        decoration: InputDecoration(
                          hintText: '08123456789',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Icon(
                              Iconsax.mobile,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Operator selection (auto-detected)
                if (_selectedOperator != null)
                  FadeTransition(
                    opacity: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.2, 0.6),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLow,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.mobile,
                            color: AppColors.primary,
                            size: 28,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Operator Terdeteksi',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _getOperatorName(_selectedOperator!),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Iconsax.tick_square,
                            color: AppColors.successGreen,
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_selectedOperator != null)
                  const SizedBox(height: AppSpacing.lg),
                // Nominal selection
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Nominal',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        childAspectRatio: 1.5,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _pulsaProducts.length,
                      itemBuilder: (context, index) {
                        final product = _pulsaProducts[index];
                        final isSelected = _selectedProduct?.id == product.id;

                        return ScaleTransition(
                          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                0.3 + (index * 0.08),
                                0.7 + (index * 0.08),
                              ),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedProduct = product;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.surfaceCard,
                                borderRadius: BorderRadius.circular(AppRadius.lg),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Rp${product.nominal.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppColors.textPrimary,
                                            ),
                                      ),
                                      if (product.isPromo) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          product.promoLabel,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: isSelected
                                                    ? Colors.white
                                                    : AppColors.accentOrangeBright,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    'Rp${product.price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: isSelected
                                              ? Colors.white.withOpacity(0.9)
                                              : AppColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                // Summary section
                if (_selectedProduct != null && _selectedOperator != null)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.5, 0.9),
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
                                    'Nominal',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                  Text(
                                    'Rp${_selectedProduct!.nominal.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
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
                                height: 1,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Bayar',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  Text(
                                    'Rp${_selectedProduct!.price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
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
                        // CTA Button
                        SizedBox(
                          width: double.infinity,
                          child: PremiumButton(
                            label: 'Lanjutkan ke Pembayaran',
                            icon: Iconsax.arrow_right_3,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                '/checkout',
                                arguments: {
                                  'product': _selectedProduct,
                                  'operator': _selectedOperator,
                                  'phone': _phoneController.text,
                                  'type': 'pulsa',
                                },
                              );
                            },
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

  String _getOperatorName(Operator operator) {
    switch (operator) {
      case Operator.telkomsel:
        return 'Telkomsel';
      case Operator.xl:
        return 'XL Axiata';
      case Operator.indosat:
        return 'Indosat';
      case Operator.tri:
        return 'Tri (3)';
      case Operator.smartfren:
        return 'Smartfren';
    }
  }
}
