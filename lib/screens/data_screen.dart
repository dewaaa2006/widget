import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../config/app_helpers.dart';
import '../config/theme.dart';
import '../models/models.dart';
import '../widgets/custom_widgets.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final TextEditingController _phoneController = TextEditingController();
  Operator? _operator;
  String _category = 'internet';
  String _sort = 'populer';
  DataPackage? _selected;

  final Map<String, List<DataPackage>> _packages = {
    'internet': [
      DataPackage(id: 'd1', name: 'Internet 2GB', category: 'internet', quota: '2GB', validityDays: '3 hari', price: 12000, originalPrice: 14000, discount: 2000, isPromo: true, benefits: ['Kuota utama 2GB', 'Aktif instan']),
      DataPackage(id: 'd2', name: 'Internet 5GB', category: 'internet', quota: '5GB', validityDays: '7 hari', price: 24500, originalPrice: 27000, discount: 2500, benefits: ['Kuota utama 5GB', 'Akses nasional']),
      DataPackage(id: 'd3', name: 'Internet 12GB', category: 'internet', quota: '12GB', validityDays: '30 hari', price: 67000, originalPrice: 72000, discount: 5000, isPromo: true, benefits: ['Kuota utama 12GB', 'Bonus 2GB lokal']),
    ],
    'combo': [
      DataPackage(id: 'd4', name: 'Combo 25GB', category: 'combo', quota: '25GB', validityDays: '30 hari', price: 93000, originalPrice: 109000, discount: 16000, isPromo: true, benefits: ['25GB utama', 'Bonus nelpon', 'Apps unlimited']),
      DataPackage(id: 'd5', name: 'Combo 40GB', category: 'combo', quota: '40GB', validityDays: '30 hari', price: 138000, originalPrice: 149000, discount: 11000, benefits: ['40GB utama', 'Bonus SMS']),
    ],
    'malam': [
      DataPackage(id: 'd6', name: 'Malam 15GB', category: 'malam', quota: '15GB', validityDays: '30 hari', price: 24000, originalPrice: 26000, discount: 2000, benefits: ['22:00-06:00', 'Cocok streaming malam']),
    ],
    'streaming': [
      DataPackage(id: 'd7', name: 'Streaming Max', category: 'streaming', quota: '10GB', validityDays: '30 hari', price: 48000, originalPrice: 56000, discount: 8000, isPromo: true, benefits: ['Netflix & YouTube', 'Bonus VIU']),
    ],
    'gaming': [
      DataPackage(id: 'd8', name: 'Gaming Booster', category: 'gaming', quota: '8GB', validityDays: '14 hari', price: 32000, originalPrice: 35000, discount: 3000, benefits: ['Free Fire', 'Mobile Legends', 'PUBG Mobile']),
    ],
    'masa': [
      DataPackage(id: 'd9', name: 'Perpanjang 30 Hari', category: 'masa', quota: '0GB', validityDays: '30 hari', price: 15000, originalPrice: 17000, discount: 2000, benefits: ['Tambah masa aktif 30 hari']),
    ],
  };

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  List<DataPackage> get _visiblePackages {
    final items = List<DataPackage>.from(_packages[_category] ?? []);
    if (_sort == 'termurah') {
      items.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sort == 'terbesar') {
      items.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sort == 'promo') {
      items.sort((a, b) => (b.discount).compareTo(a.discount));
    }
    return items;
  }

  void _detect() => setState(() => _operator = detectOperator(_phoneController.text));

  void _addToCart() {
    if (_selected == null || _operator == null) return;
    CartRepository.addItem(
      CartItem(
        id: 'cart-data-${DateTime.now().millisecondsSinceEpoch}',
        type: TransactionType.data,
        product: _selected!,
        displayName: _selected!.name,
        targetNumber: _phoneController.text,
        operator: _operator,
        price: _selected!.price,
        addedAt: DateTime.now(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paket data ditambahkan ke keranjang')),
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
        'type': 'data',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ready = _operator != null && _selected != null;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Beli Paket Data')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 140),
        children: [
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nomor tujuan',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
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
                if (_operator != null)
                  PremiumCard(
                    backgroundColor: getOperatorColor(_operator!).withAlphaValue(0.08),
                    child: Row(
                      children: [
                        Icon(Iconsax.wifi, color: getOperatorColor(_operator!)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Operator terdeteksi: ${getOperatorName(_operator!)}',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const ('internet', 'Internet'),
                const ('combo', 'Combo'),
                const ('malam', 'Malam'),
                const ('streaming', 'Streaming'),
                const ('gaming', 'Gaming'),
                const ('masa', 'Masa aktif'),
              ].map((entry) {
                final selected = _category == entry.$1;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(entry.$2),
                    selected: selected,
                    onSelected: (_) => setState(() {
                      _category = entry.$1;
                      _selected = null;
                    }),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['termurah', 'populer', 'terbesar', 'promo'].map((sort) {
                final selected = _sort == sort;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text(sort[0].toUpperCase() + sort.substring(1)),
                    selected: selected,
                    onSelected: (_) => setState(() => _sort = sort),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          ..._visiblePackages.map((item) {
            final selected = _selected?.id == item.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: GestureDetector(
                onTap: _operator == null ? null : () => setState(() => _selected = item),
                child: PremiumCard(
                  backgroundColor: selected ? AppColors.primary.withAlphaValue(0.06) : AppColors.surfaceCard,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          if (item.isPromo)
                            StatusChip(
                              label: 'Promo',
                              backgroundColor: AppColors.accentOrangeBright,
                              textColor: AppColors.accentOrangeBright,
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${item.quota} • ${item.validityDays}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: item.benefits.map((benefit) => _BenefitPill(label: benefit)).toList(),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Text(
                            formatCurrency(item.originalPrice),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            formatCurrency(item.price),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                          ),
                          const Spacer(),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: selected ? AppColors.primary : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected ? AppColors.primary : AppColors.border,
                                width: 2,
                              ),
                            ),
                            child: selected
                                ? const Icon(Icons.check, size: 13, color: Colors.white)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
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

class _BenefitPill extends StatelessWidget {
  const _BenefitPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}
