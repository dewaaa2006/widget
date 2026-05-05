import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../models/models.dart';
import '../widgets/custom_widgets.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _phoneController = TextEditingController();
  Operator? _selectedOperator;
  DataPackage? _selectedPackage;
  String _selectedCategory = 'internet';

  final Map<String, List<DataPackage>> _packages = {
    'internet': [
      DataPackage(
        id: '1',
        name: 'Internet 5GB',
        category: 'internet',
        quota: '5GB',
        validityDays: '30 Hari',
        price: 49000,
        originalPrice: 49000,
        discount: 0,
        benefits: ['Internet 5GB', 'Akses tanpa batas ke beberapa sosmed'],
      ),
      DataPackage(
        id: '2',
        name: 'Internet 10GB',
        category: 'internet',
        quota: '10GB',
        validityDays: '30 Hari',
        price: 89000,
        originalPrice: 99000,
        discount: 10,
        isPromo: true,
        benefits: ['Internet 10GB', 'Akses tanpa batas ke beberapa sosmed'],
      ),
    ],
    'combo': [
      DataPackage(
        id: '3',
        name: 'Combo Paket',
        category: 'combo',
        quota: '15GB Data + 100min Call',
        validityDays: '30 Hari',
        price: 129000,
        originalPrice: 139000,
        discount: 7,
        isPromo: true,
        benefits: [
          '15GB Internet',
          '100 Menit Panggilan',
          'Gratis akses sosmed',
        ],
      ),
    ],
    'malam': [
      DataPackage(
        id: '4',
        name: 'Internet Malam 20GB',
        category: 'malam',
        quota: '20GB (22:00-06:00)',
        validityDays: '30 Hari',
        price: 39000,
        originalPrice: 39000,
        discount: 0,
        benefits: ['20GB Internet Malam', 'Jam operasional 22:00-06:00'],
      ),
    ],
    'streaming': [
      DataPackage(
        id: '5',
        name: 'Paket Streaming',
        category: 'streaming',
        quota: '25GB Kuota Streaming',
        validityDays: '30 Hari',
        price: 99000,
        originalPrice: 129000,
        discount: 23,
        isPromo: true,
        benefits: [
          '25GB untuk YouTube, Netflix, TikTok',
          'Unlimited Spotify',
          'Streaming tanpa khawatir',
        ],
      ),
    ],
  };

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
    if (phone.startsWith('0811') ||
        phone.startsWith('0812') ||
        phone.startsWith('0813') ||
        phone.startsWith('0821') ||
        phone.startsWith('0822') ||
        phone.startsWith('0823')) {
      detected = Operator.telkomsel;
    } else if (phone.startsWith('0817') ||
        phone.startsWith('0818') ||
        phone.startsWith('0819') ||
        phone.startsWith('0859') ||
        phone.startsWith('0877') ||
        phone.startsWith('0878')) {
      detected = Operator.xl;
    } else if (phone.startsWith('0814') ||
        phone.startsWith('0815') ||
        phone.startsWith('0816') ||
        phone.startsWith('0855') ||
        phone.startsWith('0856') ||
        phone.startsWith('0857')) {
      detected = Operator.indosat;
    } else if (phone.startsWith('0892') ||
        phone.startsWith('0893') ||
        phone.startsWith('0899')) {
      detected = Operator.tri;
    } else if (phone.startsWith('0881') ||
        phone.startsWith('0882') ||
        phone.startsWith('0883') ||
        phone.startsWith('0888') ||
        phone.startsWith('0889')) {
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
        title: const Text('Beli Paket Data'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Phone input
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
                // Operator card
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
                            Iconsax.tick_circle,
                            color: AppColors.successGreen,
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_selectedOperator != null) const SizedBox(height: AppSpacing.lg),
                // Category tabs
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kategori Paket',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'internet',
                          'combo',
                          'malam',
                          'streaming',
                        ].map((category) {
                          final isSelected = _selectedCategory == category;
                          return Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.md),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                  _selectedPackage = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg,
                                  vertical: AppSpacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.surfaceLow,
                                  borderRadius: BorderRadius.circular(AppRadius.lg),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.border,
                                  ),
                                ),
                                child: Text(
                                  _getCategoryLabel(category),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                // Package list
                ..._packages[_selectedCategory]!.map((package) {
                  final isSelected = _selectedPackage?.id == package.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPackage = package;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withOpacity(0.05) : AppColors.surfaceCard,
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
                                    color:
                                        AppColors.primary.withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        package.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${package.quota} • ${package.validityDays}',
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
                                if (package.isPromo)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.accentOrangeBright
                                              .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(
                                          AppRadius.sm),
                                    ),
                                    child: Text(
                                      '-${package.discount}%',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: AppColors
                                                .accentOrangeBright,
                                            fontWeight: FontWeight.w700,
                                          ),
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
                                  'Rp${package.price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Iconsax.tick_square,
                                    color: AppColors.successGreen,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: AppSpacing.lg),
                // CTA Button
                if (_selectedPackage != null && _selectedOperator != null)
                  SizedBox(
                    width: double.infinity,
                    child: PremiumButton(
                      label: 'Lanjutkan ke Pembayaran',
                      icon: Iconsax.arrow_right_3,
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/checkout',
                          arguments: {
                            'product': _selectedPackage,
                            'operator': _selectedOperator,
                            'phone': _phoneController.text,
                            'type': 'data',
                          },
                        );
                      },
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

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'internet':
        return 'Internet';
      case 'combo':
        return 'Paket Combo';
      case 'malam':
        return 'Internet Malam';
      case 'streaming':
        return 'Streaming';
      default:
        return category;
    }
  }
}
