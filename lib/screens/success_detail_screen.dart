import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../config/app_helpers.dart';
import '../config/theme.dart';
import '../models/models.dart';
import '../widgets/custom_widgets.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({
    super.key,
    this.type = 'cart',
    this.amount = 0,
    this.transactions,
  });

  final String type;
  final int amount;
  final List<Transaction>? transactions;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Transaction> get _transactions => widget.transactions ?? const [];

  int get _successCount =>
      _transactions.where((tx) => tx.status == TransactionStatus.success).length;
  int get _pendingCount =>
      _transactions.where((tx) => tx.status == TransactionStatus.pending).length;
  int get _failedCount =>
      _transactions.where((tx) => tx.status == TransactionStatus.failed).length;

  bool get _allSuccess => _transactions.isEmpty || _failedCount == 0 && _pendingCount == 0;

  @override
  Widget build(BuildContext context) {
    final title = _allSuccess
        ? 'Transaksi berhasil'
        : _failedCount > 0
            ? 'Sebagian transaksi perlu perhatian'
            : 'Transaksi masih diproses';
    final subtitle = _allSuccess
        ? 'Pesanan kamu sudah kami teruskan dan siap dipakai.'
        : 'Beberapa item berhasil, sementara sisanya pending atau gagal.';
    final iconColor = _allSuccess
        ? AppColors.successGreen
        : _failedCount > 0
            ? AppColors.errorRed
            : AppColors.warningYellow;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
            children: [
              ScaleTransition(
                scale: CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
                child: Container(
                  width: 124,
                  height: 124,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        iconColor,
                        iconColor.withAlphaValue(0.72),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withAlphaValue(0.28),
                        blurRadius: 30,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Icon(
                    _allSuccess ? Iconsax.tick_circle : Iconsax.warning_2,
                    size: 62,
                    color: Colors.white,
                  ),
                ),
              ),
              FadeTransition(
                opacity: _controller,
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PremiumCard(
                child: Column(
                  children: [
                    _ResultStat(label: 'Total pembayaran', value: formatCurrency(widget.amount)),
                    _ResultStat(label: 'Berhasil', value: '$_successCount item'),
                    _ResultStat(label: 'Pending', value: '$_pendingCount item'),
                    _ResultStat(label: 'Gagal', value: '$_failedCount item'),
                    if (_transactions.isNotEmpty)
                      _ResultStat(label: 'Waktu', value: formatCompactDate(_transactions.first.createdAt)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (_transactions.isNotEmpty)
                PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status per item',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 12),
                      ..._transactions.map((tx) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TransactionListTile(
                              transaction: tx,
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/transaction-detail',
                                arguments: tx,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              const SizedBox(height: 18),
              PremiumButton(
                label: 'Lihat Detail Transaksi',
                onPressed: _transactions.isEmpty
                    ? null
                    : () => Navigator.pushNamed(
                          context,
                          '/transaction-detail',
                          arguments: _transactions.first,
                        ),
              ),
              const SizedBox(height: 12),
              if (_failedCount > 0)
                OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/history'),
                  child: const Text('Retry dari Riwayat'),
                ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                ),
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final color = getStatusColor(transaction.status);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
        children: [
          PremiumCard(
            backgroundColor: color.withAlphaValue(0.08),
            child: Column(
              children: [
                Icon(
                  transaction.status == TransactionStatus.success
                      ? Iconsax.tick_circle
                      : transaction.status == TransactionStatus.pending
                          ? Iconsax.timer_1
                          : Iconsax.warning_2,
                  color: color,
                  size: 48,
                ),
                const SizedBox(height: 10),
                Text(
                  transaction.statusLabel,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  transaction.description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PremiumCard(
            child: Column(
              children: [
                _DetailRow(label: 'ID transaksi', value: transaction.id),
                _DetailRow(label: 'Layanan', value: transaction.title),
                _DetailRow(label: 'Tujuan', value: transaction.targetNumber),
                _DetailRow(label: 'Provider', value: transaction.operatorName ?? '-'),
                _DetailRow(label: 'Metode bayar', value: _paymentMethodLabel(transaction.paymentMethod)),
                _DetailRow(label: 'Waktu', value: formatCompactDate(transaction.createdAt)),
                _DetailRow(label: 'Reference', value: transaction.referenceNumber ?? '-'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PremiumCard(
            child: Column(
              children: [
                _DetailRow(label: 'Nominal', value: formatCurrency(transaction.amount)),
                _DetailRow(label: 'Biaya admin', value: formatCurrency(transaction.adminFee ?? 0)),
                _DetailRow(label: 'Diskon', value: formatCurrency(transaction.discount ?? 0)),
                _DetailRow(
                  label: 'Total',
                  value: formatCurrency(transaction.totalPrice),
                  emphasize: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/help'),
                  child: const Text('Hubungi CS'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PremiumButton(
                  label: 'Beli Lagi',
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _paymentMethodLabel(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.saldo:
        return 'Saldo Ultra.X';
      case PaymentMethodType.virtualAccount:
        return 'Virtual Account';
      case PaymentMethodType.eWallet:
        return 'E-Wallet';
      case PaymentMethodType.qris:
        return 'QRIS';
      case PaymentMethodType.card:
        return 'Kartu';
    }
  }
}

class _ResultStat extends StatelessWidget {
  const _ResultStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: style)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: style?.copyWith(
                fontWeight: emphasize ? FontWeight.w800 : FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
