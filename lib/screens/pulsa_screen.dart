import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../config/app_helpers.dart';
import '../config/theme.dart';
import '../models/models.dart';
import '../widgets/custom_widgets.dart';

class PulsaScreen extends StatefulWidget {
  const PulsaScreen({super.key});

  @override
  State<PulsaScreen> createState() => _PulsaScreenState();
}

class _PulsaScreenState extends State<PulsaScreen> {
  final TextEditingController _phoneController =
      TextEditingController(text: FavoriteRepository.favorites.first.phone);
  Operator? _operator;
  PulsaProduct? _selected;
  bool _loadingPrice = false;

  final List<PulsaProduct> _products = [
    PulsaProduct(id: 'p5', nominal: 5000, price: 6500, originalPrice: 7000, discount: 500),
    PulsaProduct(id: 'p10', nominal: 10000, price: 11500, originalPrice: 12000, discount: 500),
    PulsaProduct(id: 'p15', nominal: 15000, price: 16500, originalPrice: 18000, discount: 1500, isPromo: true, promoLabel: 'Promo'),
    PulsaProduct(id: 'p20', nominal: 20000, price: 21800, originalPrice: 23000, discount: 1200),
    PulsaProduct(id: 'p25', nominal: 25000, price: 26750, originalPrice: 28000, discount: 1250, isPromo: true, promoLabel: 'Best deal'),
    PulsaProduct(id: 'p50', nominal: 50000, price: 52200, originalPrice: 54500, discount: 2300, isPromo: true, promoLabel: 'Hemat'),
    PulsaProduct(id: 'p100', nominal: 100000, price: 103500, originalPrice: 107000, discount: 3500, isPromo: true, promoLabel: 'Top pick'),
  ];

  @override
  void initState() {
    super.initState();
    _detect();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _detect() {
    setState(() {
      _operator = detectOperator(_phoneController.text);
      _loadingPrice = true;
    });
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _loadingPrice = false);
    });
  }

  void _addToCart() {
    if (_selected == null || _operator == null) return;
    CartRepository.addItem(
      CartItem(
        id: 'cart-pulsa-${DateTime.now().millisecondsSinceEpoch}',
        type: TransactionType.pulsa,
        product: _selected!,
        displayName: 'Pulsa ${formatCurrency(_selected!.nominal)}',
        targetNumber: _phoneController.text,
        operator: _operator,
        price: _selected!.price,
        addedAt: DateTime.now(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pulsa ditambahkan ke keranjang')),
    );
    setState(() {});
  }

  void _buyNow() {
    if (_selected == null || _operator == null) return;
    Navigator.pushNamed(
      context,
      '/checkout',
      arguments: {
        'product': _selected,
        'operator': _operator,
        'phone': _phoneController.text,
        'type': 'pulsa',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final valid = _phoneController.text.length >= 10 && _operator != null;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Beli Pulsa'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
            icon: const Icon(Iconsax.heart),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 140),
        children: [
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nomor tujuan',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  onChanged: (_) => _detect(),
                  decoration: const InputDecoration(
                    hintText: '0812xxxxxxx',
                    prefixIcon: Icon(Iconsax.mobile),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: FavoriteRepository.favorites.take(3).map((favorite) {
                    return ActionChip(
                      onPressed: () {
                        _phoneController.text = favorite.phone;
                        _detect();
                      },
                      label: Text(favorite.name),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                if (_operator != null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: getOperatorColor(_operator!).withAlphaValue(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Iconsax.flash_1, color: getOperatorColor(_operator!)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Operator terdeteksi: ${getOperatorName(_operator!)}',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        const Icon(Iconsax.tick_circle, color: AppColors.successGreen),
                      ],
                    ),
                  )
                else
                  Text(
                    'Masukkan nomor valid untuk mendeteksi operator otomatis.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader(
            title: 'Nominal cepat',
            action: 'Riwayat nomor',
            onTap: () => Navigator.pushNamed(context, '/history'),
          ),
          const SizedBox(height: 12),
          if (_loadingPrice)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                6,
                (_) => const SizedBox(
                  width: 160,
                  child: ShimmerSkeleton(height: 88, borderRadius: 24),
                ),
              ),
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _products.map((product) {
                final selected = _selected?.id == product.id;
                return GestureDetector(
                  onTap: valid
                      ? () => setState(() => _selected = product)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    width: (MediaQuery.of(context).size.width - 48) / 2,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withAlphaValue(0.08)
                          : AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                        width: selected ? 1.6 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.isPromo)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF2E5),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              product.promoLabel,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.accentOrange,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        const SizedBox(height: 10),
                        Text(
                          formatCurrency(product.nominal),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatCurrency(product.originalPrice),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                decoration: TextDecoration.lineThrough,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatCurrency(product.price),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          if (_selected != null) ...[
            const SizedBox(height: 18),
            PremiumCard(
              child: Column(
                children: [
                  _SummaryLine(label: 'Harga promo', value: formatCurrency(_selected!.price)),
                  _SummaryLine(label: 'Biaya admin', value: 'Gratis'),
                  _SummaryLine(
                    label: 'Estimasi diterima',
                    value: formatCurrency(_selected!.nominal),
                  ),
                  _SummaryLine(label: 'Voucher aktif', value: 'Cashback 10%'),
                  const Divider(height: 22),
                  _SummaryLine(
                    label: 'Total bayar',
                    value: formatCurrency(_selected!.price),
                    emphasize: true,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          decoration: const BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: valid && _selected != null ? _addToCart : null,
                  child: const Text('Masukkan ke Keranjang'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PremiumButton(
                  label: 'Beli Sekarang',
                  onPressed: valid && _selected != null ? _buyNow : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onTap,
  });

  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        TextButton(onPressed: onTap, child: Text(action)),
      ],
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            )
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(value, style: style),
        ],
      ),
    );
  }
}
