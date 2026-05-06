import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../config/app_helpers.dart';
import '../config/theme.dart';
import '../models/models.dart';
import '../widgets/custom_widgets.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  final Set<String> _selectedIds = <String>{};
  String? _voucherCode;

  @override
  void initState() {
    super.initState();
    _selectedIds.addAll(CartRepository.items.map((item) => item.id));
  }

  List<CartItem> get _selectedItems => CartRepository.items
      .where((item) => _selectedIds.contains(item.id))
      .toList();

  int get _subtotal => _selectedItems.fold(0, (sum, item) => sum + item.price);
  int get _discount => _voucherCode == null ? 0 : (_subtotal >= 50000 ? 2000 : 0);
  int get _adminFee => _selectedItems.isEmpty ? 0 : (_selectedItems.length * 1500);
  int get _total => _subtotal - _discount + _adminFee;

  void _toggleItem(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _toggleAll() {
    setState(() {
      if (_selectedIds.length == CartRepository.items.length) {
        _selectedIds.clear();
      } else {
        _selectedIds
          ..clear()
          ..addAll(CartRepository.items.map((item) => item.id));
      }
    });
  }

  void _removeItem(CartItem item) {
    setState(() {
      CartRepository.removeItem(item.id);
      _selectedIds.remove(item.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item dihapus dari keranjang')),
    );
  }

  Future<void> _editItem(CartItem item) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 56,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Edit item',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Untuk demo ini, item diarahkan kembali ke halaman layanan agar kamu bisa memilih ulang produk yang diinginkan.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              PremiumButton(
                label: 'Pilih ulang layanan',
                onPressed: () {
                  Navigator.pop(context);
                  final route = item.type == TransactionType.data
                      ? '/data'
                      : item.type == TransactionType.electric
                          ? '/pln'
                          : item.type == TransactionType.topup
                              ? '/topup'
                              : '/pulsa';
                  Navigator.pushNamed(context, route);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyVoucher() {
    setState(() {
      _voucherCode = _voucherCode == null ? 'HEMAT2000' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = CartRepository.items.isEmpty;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Keranjang ${isEmpty ? '' : '(${CartRepository.items.length})'}'),
      ),
      body: isEmpty ? _buildEmptyState(context) : _buildFilledState(context),
      bottomNavigationBar: isEmpty
          ? null
          : SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_selectedItems.length} item dipilih',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: _total.toDouble()),
                                duration: const Duration(milliseconds: 500),
                                builder: (context, value, _) => Text(
                                  formatCurrency(value),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: PremiumButton(
                            label: 'Lanjut Checkout',
                            onPressed: _selectedItems.isEmpty
                                ? null
                                : () {
                                    Navigator.pushNamed(
                                      context,
                                      '/checkout',
                                      arguments: {
                                        'fromCart': true,
                                        'selectedItems': _selectedIds.toList(),
                                        'voucher': _voucherCode,
                                      },
                                    ).then((_) => setState(() {}));
                                  },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.surfaceLow,
                borderRadius: BorderRadius.circular(38),
              ),
              child: const Icon(
                Iconsax.shopping_cart,
                size: 44,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Keranjang masih kosong',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              'Simpan pulsa, paket data, token listrik, atau top up saldo supaya bisa checkout sekaligus.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 220,
              child: PremiumButton(
                label: 'Mulai Belanja',
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilledState(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: _toggleAll,
                child: Row(
                  children: [
                    _SelectCircle(
                      selected: _selectedIds.length == CartRepository.items.length,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _selectedIds.length == CartRepository.items.length
                          ? 'Batalkan semua'
                          : 'Pilih semua',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _applyVoucher,
                child: Text(
                  _voucherCode == null ? 'Pakai voucher' : 'Voucher aktif',
                ),
              ),
            ],
          ),
        ),
        if (_voucherCode != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: PremiumCard(
              backgroundColor: const Color(0xFFFFF4E8),
              child: Row(
                children: [
                  const Icon(Iconsax.ticket_discount, color: AppColors.accentOrangeBright),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Voucher $_voucherCode terpasang dan memotong Rp2.000.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.accentOrange,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            children: [
              ...CartRepository.items.map((item) {
                final selected = _selectedIds.contains(item.id);
                final unavailable = item.targetNumber.endsWith('999');
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Dismissible(
                    key: ValueKey(item.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: AppColors.errorRed,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: const Icon(Iconsax.trash, color: Colors.white),
                    ),
                    onDismissed: (_) => _removeItem(item),
                    child: PremiumCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: unavailable ? null : () => _toggleItem(item.id),
                                child: _SelectCircle(selected: selected),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceLow,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Icon(
                                  item.type == TransactionType.data
                                      ? Iconsax.wifi
                                      : item.type == TransactionType.electric
                                          ? Iconsax.flash_1
                                          : item.type == TransactionType.topup
                                              ? Iconsax.wallet_add
                                              : Iconsax.mobile,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.displayName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                        ),
                                        if (unavailable)
                                          StatusChip(
                                            label: 'Tidak tersedia',
                                            backgroundColor: AppColors.errorRed,
                                            textColor: AppColors.errorRed,
                                          )
                                        else
                                          StatusChip(
                                            label: 'Ready',
                                            backgroundColor: AppColors.successGreen,
                                            textColor: AppColors.successGreen,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.targetNumber,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        if (item.operator != null)
                                          _MetaPill(
                                            label: getOperatorName(item.operator!),
                                          ),
                                        _MetaPill(
                                          label: getTransactionTypeLabel(item.type),
                                        ),
                                        if (item.price >= 50000)
                                          const _MetaPill(label: 'Best deal'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Text(
                                formatCurrency(item.price + 2500),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                formatCurrency(item.price),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: () => _editItem(item),
                                icon: const Icon(Iconsax.edit_2, size: 16),
                                label: const Text('Edit'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              PremiumCard(
                backgroundColor: AppColors.surfaceLow,
                child: Row(
                  children: [
                    const Icon(Iconsax.shop, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Lanjut belanja dan gabungkan beberapa kebutuhan digital dalam satu checkout.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/home'),
                      child: const Text('Belanja lagi'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              PremiumCard(
                child: Column(
                  children: [
                    _SummaryRow(label: 'Subtotal', value: formatCurrency(_subtotal)),
                    _SummaryRow(label: 'Diskon', value: '-${formatCurrency(_discount)}'),
                    _SummaryRow(label: 'Estimasi admin', value: formatCurrency(_adminFee)),
                    const Divider(),
                    _SummaryRow(
                      label: 'Total akhir',
                      value: formatCurrency(_total),
                      emphasize: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectCircle extends StatelessWidget {
  const _SelectCircle({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
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
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label});

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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
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
            )
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(
            value,
            style: style?.copyWith(
              color: emphasize ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
