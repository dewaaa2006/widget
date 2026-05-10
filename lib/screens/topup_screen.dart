import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../config/app_helpers.dart';
import '../config/theme.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../widgets/custom_widgets.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final TextEditingController _customController = TextEditingController();
  TopUpOption? _selected;
  PaymentMethod _method = PaymentMethodRepository.methods[1];

  final List<TopUpOption> _options = [
    TopUpOption(id: 't1', amount: 50000, label: 'Rp50.000', badge: 'Quick'),
    TopUpOption(id: 't2', amount: 100000, label: 'Rp100.000', badge: 'Populer'),
    TopUpOption(id: 't3', amount: 200000, label: 'Rp200.000', badge: 'Cashback'),
    TopUpOption(id: 't4', amount: 500000, label: 'Rp500.000', badge: 'Premium'),
  ];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  int get _selectedAmount {
    if (_selected != null) return _selected!.amount;
    return int.tryParse(_customController.text.replaceAll('.', '')) ?? 0;
  }

  void _continueCheckout() {
    if (_selectedAmount <= 0) return;
    Navigator.pushNamed(
      context,
      '/checkout',
      arguments: {
        'product': TopUpOption(
          id: _selected?.id ?? 'custom',
          amount: _selectedAmount,
          label: formatCurrency(_selectedAmount),
        ),
        'phone': AppState.currentUser.phone,
        'type': 'topup',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final amount = _selectedAmount;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Top Up Saldo')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 140),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryGradient],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saldo saat ini',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withAlphaValue(0.84),
                      ),
                ),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: AppState.currentUser.balance),
                  duration: const Duration(milliseconds: 900),
                  builder: (context, value, _) => Text(
                    formatCurrency(value),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const AnimatedPromoBanner(
            title: 'Top Up Kilat, Cashback Lebih Besar',
            subtitle: 'Isi saldo dalam hitungan detik dan buka promo bebas admin plus cashback eksklusif hari ini.',
            badge: 'Ultra Flash',
            cta: 'Pilih nominal dan aktifkan promo sekarang',
            icon: Iconsax.wallet_add,
            height: 182,
          ),
          const SizedBox(height: 18),
          Text(
            'Pilih nominal',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _options.map((item) {
              final selected = _selected?.id == item.id;
              return GestureDetector(
                onTap: () => setState(() {
                  _selected = item;
                  _customController.clear();
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: (MediaQuery.of(context).size.width - 48) / 2,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary.withAlphaValue(0.08) : AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.badge != null)
                        StatusChip(
                          label: item.badge!,
                          backgroundColor: AppColors.accentOrangeBright,
                          textColor: AppColors.accentOrangeBright,
                        ),
                      const SizedBox(height: 8),
                      Text(
                        item.label,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      if (item.bonus > 0)
                        Text('Bonus ${formatCurrency(item.bonus)}'),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nominal custom',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _customController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() => _selected = null),
                  decoration: const InputDecoration(
                    hintText: 'Contoh 150000',
                    prefixText: 'Rp ',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Metode top up',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                ...PaymentMethodRepository.methods.where((m) => m.type != PaymentMethodType.saldo).map((method) {
                  final selected = _method.id == method.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _method = method),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary.withAlphaValue(0.06) : AppColors.surfaceLow,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected ? AppColors.primary : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(method.icon, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Expanded(child: Text(method.displayName)),
                            if (selected)
                              const Icon(Iconsax.tick_circle, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          if (amount > 0) ...[
            const SizedBox(height: 18),
            PremiumCard(
              child: Column(
                children: [
                  _TopupLine(label: 'Nominal top up', value: formatCurrency(amount)),
                  const _TopupLine(label: 'Biaya admin', value: 'Gratis'),
                  _TopupLine(label: 'Saldo masuk', value: formatCurrency(amount), emphasize: true),
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
          child: PremiumButton(
            label: 'Lanjutkan',
            onPressed: amount > 0 ? _continueCheckout : null,
          ),
        ),
      ),
    );
  }
}

class _TopupLine extends StatelessWidget {
  const _TopupLine({
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
