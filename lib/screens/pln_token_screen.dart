import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../config/app_helpers.dart';
import '../config/theme.dart';
import '../models/models.dart';
import '../widgets/custom_widgets.dart';

class PLNTokenScreen extends StatefulWidget {
  const PLNTokenScreen({super.key, this.prefilledPhoneNumber});

  final String? prefilledPhoneNumber;

  @override
  State<PLNTokenScreen> createState() => _PLNTokenScreenState();
}

class _PLNTokenScreenState extends State<PLNTokenScreen> {
  late final TextEditingController _customerIdController;
  bool _loading = false;
  bool _validated = false;
  Map<String, dynamic>? _customer;
  Map<String, dynamic>? _selected;

  final List<Map<String, dynamic>> _denominations = [
    {'name': 'Token 20.000', 'price': 21500, 'nominal': 20000},
    {'name': 'Token 50.000', 'price': 51500, 'nominal': 50000},
    {'name': 'Token 100.000', 'price': 101500, 'nominal': 100000},
    {'name': 'Token 200.000', 'price': 201500, 'nominal': 200000},
  ];

  @override
  void initState() {
    super.initState();
    _customerIdController =
        TextEditingController(text: widget.prefilledPhoneNumber ?? '');
  }

  @override
  void dispose() {
    _customerIdController.dispose();
    super.dispose();
  }

  Future<void> _validate() async {
    if (_customerIdController.text.length < 6) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _validated = true;
      _customer = {
        'name': 'Alya Rahma',
        'tarif': 'R1 / 1.300 VA',
      };
    });
  }

  void _addToCart() {
    if (_selected == null || !_validated) return;
    CartRepository.addItem(
      CartItem(
        id: 'cart-pln-${DateTime.now().millisecondsSinceEpoch}',
        type: TransactionType.electric,
        product: _selected,
        displayName: _selected!['name'] as String,
        targetNumber: _customerIdController.text,
        price: _selected!['price'] as int,
        addedAt: DateTime.now(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Token listrik ditambahkan ke keranjang')),
    );
  }

  void _buyNow() {
    if (_selected == null || !_validated) return;
    Navigator.pushNamed(
      context,
      '/checkout',
      arguments: {
        'product': _selected,
        'phone': _customerIdController.text,
        'type': 'electric',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ready = _validated && _selected != null;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Token Listrik')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 140),
        children: [
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID pelanggan / nomor meter',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _customerIdController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan nomor pelanggan',
                          prefixIcon: Icon(Iconsax.receipt_search),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 120,
                      child: PremiumButton(
                        label: 'Cek',
                        isLoading: _loading,
                        onPressed: _loading ? null : _validate,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_validated && _customer != null)
                  PremiumCard(
                    backgroundColor: AppColors.surfaceLow,
                    child: Row(
                      children: [
                        const Icon(Iconsax.flash_1, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _customer!['name'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              Text(_customer!['tarif'] as String),
                            ],
                          ),
                        ),
                        const Icon(Iconsax.tick_circle, color: AppColors.successGreen),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Pilih nominal token',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ..._denominations.map((item) {
            final selected = _selected?['name'] == item['name'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: _validated ? () => setState(() => _selected = item) : null,
                child: PremiumCard(
                  backgroundColor: selected ? AppColors.primary.withAlphaValue(0.06) : AppColors.surfaceCard,
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4E7),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Iconsax.flash_1, color: AppColors.accentOrangeBright),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'] as String,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Token diterima ${formatCurrency(item['nominal'] as int)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatCurrency(item['price'] as int),
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                          ),
                          const SizedBox(height: 6),
                          if (selected)
                            const Icon(Iconsax.tick_circle, color: AppColors.primary),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (_selected != null) ...[
            const SizedBox(height: 6),
            PremiumCard(
              child: Column(
                children: [
                  _PLNRow(label: 'Nominal token', value: formatCurrency(_selected!['nominal'] as int)),
                  const _PLNRow(label: 'Biaya admin', value: 'Rp1.500'),
                  _PLNRow(label: 'Promo aktif', value: 'Bebas admin member baru'),
                  _PLNRow(
                    label: 'Total bayar',
                    value: formatCurrency(_selected!['price'] as int),
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
                  onPressed: ready ? _addToCart : null,
                  child: const Text('Masukkan ke Keranjang'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PremiumButton(
                  label: 'Beli Sekarang',
                  onPressed: ready ? _buyNow : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PLNRow extends StatelessWidget {
  const _PLNRow({
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
