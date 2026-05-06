import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../config/app_helpers.dart';
import '../config/theme.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../widgets/custom_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    this.product,
    this.operator,
    this.phone = '',
    this.type = '',
  });

  final dynamic product;
  final Operator? operator;
  final String phone;
  final String type;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  PaymentMethod _selectedMethod = PaymentMethodRepository.methods.first;
  bool _agree = true;
  bool _processing = false;
  String? _globalVoucher = 'ULTRA50';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _fromCart {
    final args = ModalRoute.of(context)?.settings.arguments;
    return args is Map<String, dynamic> && args['fromCart'] == true;
  }

  List<CartItem> get _items {
    if (_fromCart) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      final selectedIds = List<String>.from(args['selectedItems'] as List<dynamic>);
      return CartRepository.items.where((item) => selectedIds.contains(item.id)).toList();
    }

    return [
      CartItem(
        id: 'single-${DateTime.now().millisecondsSinceEpoch}',
        type: _resolveType(widget.type),
        product: widget.product,
        displayName: _resolveDisplayName(widget.type, widget.product),
        targetNumber: widget.phone,
        operator: widget.operator,
        price: _resolvePrice(widget.type, widget.product),
        addedAt: DateTime.now(),
      ),
    ];
  }

  int get _subtotal => _items.fold(0, (sum, item) => sum + item.price);
  int get _discount => _globalVoucher == null ? 0 : (_subtotal >= 50000 ? 5000 : 0);
  int get _cashback => _subtotal >= 100000 ? 10000 : 0;
  int get _adminFee => _selectedMethod.type == PaymentMethodType.saldo ? 0 : 2500;
  int get _serviceFee => _items.length > 1 ? 1500 : 0;
  int get _grandTotal => _subtotal - _discount + _adminFee + _serviceFee;

  bool get _insufficientBalance =>
      _selectedMethod.type == PaymentMethodType.saldo &&
      AppState.currentUser.balance < _grandTotal;

  Future<void> _confirmPayment() async {
    if (!_agree || _processing) return;
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ConfirmSheet(
        total: _grandTotal,
        items: _items,
        method: _selectedMethod,
      ),
    );

    if (confirmed != true) return;

    setState(() => _processing = true);
    await _showProcessingDialog();
    if (!mounted) return;

    final transactions = <Transaction>[];
    for (var index = 0; index < _items.length; index++) {
      final item = _items[index];
      final status = _statusForItem(index, _items.length);
      final transaction = Transaction(
        id: 'TRX${DateTime.now().millisecondsSinceEpoch}$index',
        type: item.type,
        title: getTransactionTypeLabel(item.type),
        description: item.displayName,
        targetNumber: item.targetNumber,
        operatorName: item.operator == null ? null : getOperatorName(item.operator!),
        amount: item.price,
        totalPrice: item.price + (status == TransactionStatus.failed ? 0 : _adminFee),
        adminFee: _adminFee,
        discount: _discount > 0 ? (_discount / _items.length).round() : 0,
        status: status,
        paymentMethod: _selectedMethod.type,
        createdAt: DateTime.now(),
        completedAt: status == TransactionStatus.processing ? null : DateTime.now(),
        referenceNumber: 'INV${DateTime.now().millisecondsSinceEpoch}',
      );
      TransactionRepository.add(transaction);
      transactions.add(transaction);
    }

    if (_selectedMethod.type == PaymentMethodType.saldo && !_insufficientBalance) {
      AppState.updateBalance(AppState.currentUser.balance - _grandTotal);
    }
    if (_fromCart) {
      for (final item in _items) {
        CartRepository.removeItem(item.id);
      }
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      '/success',
      arguments: {
        'type': widget.type.isEmpty ? 'cart' : widget.type,
        'amount': _grandTotal,
        'transactions': transactions,
      },
    );
  }

  Future<void> _showProcessingDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _ProcessingDialog(onComplete: () async {
          await Future<void>.delayed(const Duration(milliseconds: 3800));
          if (dialogContext.mounted) Navigator.pop(dialogContext);
        });
      },
    );
    if (mounted) {
      setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Checkout Ultra.X')),
      body: SafeArea(
        child: FadeTransition(
          opacity: _controller,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 130),
            children: [
              _StepperCard(),
              const SizedBox(height: 16),
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: 'Item yang dibayar'),
                    const SizedBox(height: 14),
                    ..._items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          childrenPadding: EdgeInsets.zero,
                          collapsedBackgroundColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          shape: const Border(),
                          collapsedShape: const Border(),
                          title: Text(
                            item.displayName,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(item.targetNumber),
                          trailing: Text(
                            formatCurrency(item.price),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                spacing: 8,
                                children: [
                                  _CheckoutMeta(label: getTransactionTypeLabel(item.type)),
                                  if (item.operator != null)
                                    _CheckoutMeta(label: getOperatorName(item.operator!)),
                                  if (item.price >= 50000)
                                    const _CheckoutMeta(label: 'Promo eligible'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: 'Voucher & promo'),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () => setState(() {
                        _globalVoucher = _globalVoucher == null ? 'ULTRA50' : null;
                      }),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _globalVoucher == null
                              ? AppColors.surfaceLow
                              : const Color(0xFFFFF5E9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Iconsax.ticket_discount, color: AppColors.accentOrangeBright),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _globalVoucher ?? 'Tambahkan voucher global',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _globalVoucher == null
                                        ? 'Pakai kode promo, cashback, atau voucher item.'
                                        : 'Diskon aktif untuk checkout ini.',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              _globalVoucher == null ? Iconsax.add : Iconsax.tick_circle,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: 'Metode pembayaran'),
                    const SizedBox(height: 12),
                    ...PaymentMethodRepository.methods.map((method) {
                      final selected = _selectedMethod.id == method.id;
                      final warning = method.type == PaymentMethodType.saldo &&
                          _insufficientBalance &&
                          selected;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedMethod = method),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary.withAlphaValue(0.06)
                                  : AppColors.surfaceLow,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: selected ? AppColors.primary : Colors.transparent,
                                width: 1.4,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Icon(method.icon, color: AppColors.primary),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            method.displayName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            method.subtitle,
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selected ? AppColors.primary : Colors.transparent,
                                        border: Border.all(
                                          color: selected ? AppColors.primary : AppColors.border,
                                          width: 2,
                                        ),
                                      ),
                                      child: selected
                                          ? const Icon(Icons.check, size: 12, color: Colors.white)
                                          : null,
                                    ),
                                  ],
                                ),
                                if (warning) ...[
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Icon(Iconsax.warning_2, color: AppColors.errorRed, size: 16),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          'Saldo tidak cukup. Pilih metode lain atau top up saldo dulu.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: AppColors.errorRed),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: 'Catatan transaksi'),
                    const SizedBox(height: 12),
                    TextField(
                      minLines: 2,
                      maxLines: 4,
                      onChanged: (_) {},
                      decoration: const InputDecoration(
                        hintText: 'Tambahkan catatan jika diperlukan',
                      ),
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      value: _agree,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) => setState(() => _agree = value ?? false),
                      title: Text(
                        'Saya setuju dengan ketentuan transaksi dan memahami estimasi proses pembayaran.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PremiumCard(
                child: Column(
                  children: [
                    _CostRow(label: 'Subtotal', value: formatCurrency(_subtotal)),
                    _CostRow(label: 'Diskon', value: '-${formatCurrency(_discount)}'),
                    _CostRow(label: 'Cashback estimasi', value: formatCurrency(_cashback)),
                    _CostRow(label: 'Biaya admin', value: formatCurrency(_adminFee)),
                    _CostRow(label: 'Service fee', value: formatCurrency(_serviceFee)),
                    const Divider(height: 22),
                    _CostRow(
                      label: 'Total akhir',
                      value: formatCurrency(_grandTotal),
                      emphasize: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total pembayaran', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Text(
                      formatCurrency(_grandTotal),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 178,
                child: PremiumButton(
                  label: _processing ? 'Memproses' : 'Bayar Sekarang',
                  isLoading: _processing,
                  onPressed: (_agree && !_insufficientBalance && !_processing)
                      ? _confirmPayment
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TransactionType _resolveType(String type) {
    switch (type) {
      case 'pulsa':
        return TransactionType.pulsa;
      case 'data':
        return TransactionType.data;
      case 'topup':
        return TransactionType.topup;
      case 'electric':
      case 'pln':
        return TransactionType.electric;
      default:
        return TransactionType.voucher;
    }
  }

  int _resolvePrice(String type, dynamic product) {
    if (type == 'topup') return product.amount as int;
    if (type == 'data' || type == 'pulsa') return product.price as int;
    if (type == 'electric') return product['price'] as int;
    return 0;
  }

  String _resolveDisplayName(String type, dynamic product) {
    if (type == 'pulsa') return 'Pulsa ${formatCurrency(product.nominal as int)}';
    if (type == 'data') return product.name as String;
    if (type == 'topup') return 'Top Up ${product.label as String}';
    if (type == 'electric') return product['name'] as String;
    return 'Transaksi Ultra.X';
  }

  TransactionStatus _statusForItem(int index, int totalItems) {
    if (totalItems == 1) return TransactionStatus.success;
    if (index == totalItems - 1) return TransactionStatus.pending;
    if (index == totalItems - 2 && totalItems > 2) return TransactionStatus.failed;
    return TransactionStatus.success;
  }
}

class _StepperCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Row(
        children: const [
          _StepItem(index: 1, label: 'Review', active: true),
          Expanded(child: Divider(color: AppColors.border)),
          _StepItem(index: 2, label: 'Bayar', active: true),
          Expanded(child: Divider(color: AppColors.border)),
          _StepItem(index: 3, label: 'Selesai', active: false),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.index,
    required this.label,
    required this.active,
  });

  final int index;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.surfaceLow,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$index',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: active ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
    );
  }
}

class _CheckoutMeta extends StatelessWidget {
  const _CheckoutMeta({required this.label});

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

class _CostRow extends StatelessWidget {
  const _CostRow({
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

class _ConfirmSheet extends StatelessWidget {
  const _ConfirmSheet({
    required this.total,
    required this.items,
    required this.method,
  });

  final int total;
  final List<CartItem> items;
  final PaymentMethod method;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        top: false,
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
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Konfirmasi checkout',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Pastikan item, total, dan metode pembayaran sudah benar sebelum melanjutkan.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(child: Text(item.displayName)),
                      Text(formatCurrency(item.price)),
                    ],
                  ),
                )),
            const Divider(height: 26),
            Row(
              children: [
                const Icon(Iconsax.wallet, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(method.displayName)),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              formatCurrency(total),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 16),
            PremiumButton(
              label: 'Konfirmasi Bayar',
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProcessingDialog extends StatefulWidget {
  const _ProcessingDialog({required this.onComplete});

  final Future<void> Function() onComplete;

  @override
  State<_ProcessingDialog> createState() => _ProcessingDialogState();
}

class _ProcessingDialogState extends State<_ProcessingDialog> {
  int _activeStep = 0;
  final _steps = const [
    'Memverifikasi pembayaran',
    'Menghubungi provider',
    'Memproses transaksi',
    'Menyelesaikan pesanan',
  ];

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    for (var i = 0; i < _steps.length; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 850));
      if (!mounted) return;
      setState(() => _activeStep = i);
    }
    await widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 54,
              height: 54,
              child: CircularProgressIndicator(strokeWidth: 4),
            ),
            const SizedBox(height: 18),
            Text(
              'Jangan tutup aplikasi',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kami sedang memastikan transaksi berjalan aman dan tuntas.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            ...List.generate(_steps.length, (index) {
              final active = index <= _activeStep;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : AppColors.surfaceLow,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        active ? Icons.check : Iconsax.more_circle,
                        size: 14,
                        color: active ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _steps[index],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: active
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
