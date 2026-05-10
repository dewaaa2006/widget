import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../config/app_helpers.dart';
import '../config/theme.dart';
import '../models/models.dart';
import '../models/payment_simulation.dart';
import '../widgets/custom_widgets.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({
    super.key,
    this.type,
    this.amount,
    this.transactions,
    this.paymentIntent,
  });

  final String? type;
  final int? amount;
  final List<Transaction>? transactions;
  final PaymentIntent? paymentIntent;

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

  bool get _allSuccess =>
      _transactions.isEmpty || (_failedCount == 0 && _pendingCount == 0);

  @override
  Widget build(BuildContext context) {
    final paymentIntent = widget.paymentIntent;
    final title = _allSuccess
        ? 'Transaksi berhasil'
        : _failedCount > 0
            ? 'Sebagian transaksi perlu perhatian'
            : 'Transaksi masih diproses';
    final subtitle = _resolveSubtitle(paymentIntent);
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
                scale: CurvedAnimation(
                  parent: _controller,
                  curve: Curves.elasticOut,
                ),
                child: Container(
                  width: 124,
                  height: 124,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        iconColor,
                        iconColor.withAlpha(184),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withAlpha(72),
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
                    _ResultStat(
                      label: 'Total pembayaran',
                      value: formatCurrency(widget.amount ?? 0),
                    ),
                    _ResultStat(label: 'Berhasil', value: '$_successCount item'),
                    _ResultStat(label: 'Pending', value: '$_pendingCount item'),
                    _ResultStat(label: 'Gagal', value: '$_failedCount item'),
                    if (_transactions.isNotEmpty)
                      _ResultStat(
                        label: 'Waktu',
                        value: formatCompactDate(_transactions.first.createdAt),
                      ),
                  ],
                ),
              ),
              if (paymentIntent != null) ...[
                const SizedBox(height: 18),
                PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Ringkasan payment gateway',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          _IntentStatusPill(status: paymentIntent.status),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _ResultStat(
                        label: 'Gateway',
                        value: paymentIntent.gatewayName,
                      ),
                      _ResultStat(
                        label: 'Order ID',
                        value: paymentIntent.orderId,
                      ),
                      _ResultStat(
                        label: 'Payment Ref',
                        value: paymentIntent.paymentReference,
                      ),
                      if (paymentIntent.providerReference != null)
                        _ResultStat(
                          label: 'Provider Ref',
                          value: paymentIntent.providerReference!,
                        ),
                      _ResultStat(
                        label: 'Metode bayar',
                        value: paymentIntent.method.displayName,
                      ),
                      _ResultStat(
                        label: 'Batas bayar',
                        value: formatCompactDate(paymentIntent.expiresAt),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const AnimatedPromoBanner(
                  title: 'Gateway Sandbox Aktif',
                  subtitle:
                      'Flow pembayaran ini mensimulasikan payment intent, callback provider, dan settlement agar aplikasi terasa seperti produk fintech sungguhan.',
                  badge: 'Payment Simulation',
                  cta: 'Aman untuk demo UTS',
                  icon: Iconsax.shield_tick,
                  height: 186,
                ),
              ],
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
                      ..._transactions.map(
                        (tx) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TransactionListTile(
                            transaction: tx,
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/transaction-detail',
                              arguments: tx,
                            ),
                          ),
                        ),
                      ),
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
              if (paymentIntent != null &&
                  (paymentIntent.status == PaymentIntentStatus.expired ||
                      paymentIntent.status == PaymentIntentStatus.failed ||
                      paymentIntent.status == PaymentIntentStatus.cancelled))
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (route) => false,
                    ),
                    child: const Text('Pilih Metode Lain'),
                  ),
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

  String _resolveSubtitle(PaymentIntent? paymentIntent) {
    if (_allSuccess) {
      if (paymentIntent == null) {
        return 'Pesanan kamu sudah kami teruskan dan siap dipakai.';
      }
      return 'Pembayaran ${paymentIntent.gatewayName} sudah tercatat dan settlement sedang dijaga sampai produk selesai diproses.';
    }
    if (paymentIntent == null) {
      return 'Beberapa item berhasil, sementara sisanya pending atau gagal.';
    }
    return 'Gateway ${paymentIntent.gatewayName} sudah merespons. Beberapa item berhasil, sementara sisanya pending atau gagal.';
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
    final gatewayStatus = _gatewayStatusLabel(transaction.gatewayStatus);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
        children: [
          PremiumCard(
            backgroundColor: color.withAlpha(20),
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
                if (gatewayStatus != null) ...[
                  const SizedBox(height: 12),
                  _GatewayStatusPill(label: gatewayStatus, color: color),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          PremiumCard(
            child: Column(
              children: [
                _DetailRow(label: 'ID transaksi', value: transaction.id),
                _DetailRow(label: 'Layanan', value: transaction.title),
                _DetailRow(
                  label: 'Jenis produk',
                  value: getTransactionTypeLabel(transaction.type),
                ),
                _DetailRow(label: 'Tujuan', value: transaction.targetNumber),
                _DetailRow(
                  label: 'Provider',
                  value: transaction.operatorName ?? '-',
                ),
                _DetailRow(
                  label: 'Metode bayar',
                  value: _paymentMethodLabel(transaction.paymentMethod),
                ),
                _DetailRow(
                  label: 'Waktu',
                  value: formatCompactDate(transaction.createdAt),
                ),
                _DetailRow(
                  label: 'Reference',
                  value: transaction.referenceNumber ?? '-',
                ),
                if (transaction.paymentReference != null)
                  _DetailRow(
                    label: 'Payment Ref',
                    value: transaction.paymentReference!,
                  ),
                if (transaction.providerReference != null)
                  _DetailRow(
                    label: 'Provider Ref',
                    value: transaction.providerReference!,
                  ),
                if (transaction.gatewayName != null)
                  _DetailRow(
                    label: 'Gateway',
                    value: transaction.gatewayName!,
                  ),
                if (transaction.paymentExpiresAt != null)
                  _DetailRow(
                    label: 'Batas bayar',
                    value: formatCompactDate(transaction.paymentExpiresAt!),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PremiumCard(
            child: Column(
              children: [
                _DetailRow(
                  label: 'Nominal',
                  value: formatCurrency(transaction.amount),
                ),
                _DetailRow(
                  label: 'Biaya admin',
                  value: formatCurrency(transaction.adminFee ?? 0),
                ),
                _DetailRow(
                  label: 'Service fee',
                  value: formatCurrency(transaction.serviceFee ?? 0),
                ),
                _DetailRow(
                  label: 'Diskon',
                  value: formatCurrency(transaction.discount ?? 0),
                ),
                _DetailRow(
                  label: 'Total',
                  value: formatCurrency(transaction.totalPrice),
                  emphasize: true,
                ),
              ],
            ),
          ),
          if (transaction.note != null && transaction.note!.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catatan transaksi',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    transaction.note!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
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
                  onPressed: () => _repeatOrder(context),
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

  String? _gatewayStatusLabel(String? status) {
    switch (status) {
      case 'created':
        return 'Payment intent dibuat';
      case 'awaitingAction':
        return 'Menunggu aksi pembayaran';
      case 'pending':
        return 'Menunggu callback provider';
      case 'paid':
        return 'Pembayaran diterima';
      case 'settled':
        return 'Settlement selesai';
      case 'expired':
        return 'Pembayaran kedaluwarsa';
      case 'failed':
        return 'Pembayaran gagal';
      case 'cancelled':
        return 'Pembayaran dibatalkan';
      case 'partialSuccess':
        return 'Settlement parsial';
      default:
        return null;
    }
  }

  void _repeatOrder(BuildContext context) {
    switch (transaction.type) {
      case TransactionType.pulsa:
        Navigator.pushNamed(context, '/pulsa');
        return;
      case TransactionType.data:
        Navigator.pushNamed(context, '/data');
        return;
      case TransactionType.topup:
        Navigator.pushNamed(context, '/topup');
        return;
      case TransactionType.electric:
        Navigator.pushNamed(context, '/pln');
        return;
      case TransactionType.voucher:
        Navigator.pushNamed(context, '/home');
        return;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
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

class _IntentStatusPill extends StatelessWidget {
  const _IntentStatusPill({required this.status});

  final PaymentIntentStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(31),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _label(status),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  String _label(PaymentIntentStatus status) {
    switch (status) {
      case PaymentIntentStatus.created:
        return 'Created';
      case PaymentIntentStatus.awaitingAction:
        return 'Awaiting action';
      case PaymentIntentStatus.pending:
        return 'Pending';
      case PaymentIntentStatus.paid:
        return 'Paid';
      case PaymentIntentStatus.settled:
        return 'Settled';
      case PaymentIntentStatus.expired:
        return 'Expired';
      case PaymentIntentStatus.failed:
        return 'Failed';
      case PaymentIntentStatus.cancelled:
        return 'Cancelled';
      case PaymentIntentStatus.partialSuccess:
        return 'Partial';
    }
  }

  Color _statusColor(PaymentIntentStatus status) {
    switch (status) {
      case PaymentIntentStatus.settled:
      case PaymentIntentStatus.paid:
        return AppColors.successGreen;
      case PaymentIntentStatus.partialSuccess:
      case PaymentIntentStatus.pending:
      case PaymentIntentStatus.awaitingAction:
      case PaymentIntentStatus.created:
        return AppColors.warningYellow;
      case PaymentIntentStatus.expired:
      case PaymentIntentStatus.failed:
      case PaymentIntentStatus.cancelled:
        return AppColors.errorRed;
    }
  }
}

class _GatewayStatusPill extends StatelessWidget {
  const _GatewayStatusPill({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(31),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
