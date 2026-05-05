import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../config/theme.dart';
import '../models/models.dart';
import '../widgets/custom_widgets.dart';

class SuccessScreen extends StatefulWidget {
  final String type;
  final int amount;

  const SuccessScreen({
    Key? key,
    required this.type,
    required this.amount,
  }) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success icon with animation
                  ScaleTransition(
                    scale: Tween<double>(begin: 0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0, 0.5, curve: Curves.elasticOut),
                      ),
                    ),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.successGreen,
                            AppColors.successGreen.withOpacity(0.8),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.successGreen.withOpacity(0.4),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Iconsax.tick_square,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // Success text
                  FadeTransition(
                    opacity: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.2, 0.7),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Transaksi Berhasil!',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.successGreen,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '${widget.type == 'pulsa' ? 'Pulsa' : 'Paket Data'} telah terkirim',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // Amount
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.3, 0.8),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLow,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Nominal Transaksi',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Rp${widget.amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // Buttons
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.5, 1),
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: PremiumButton(
                              label: 'Lihat Riwayat',
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed('/history');
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed('/home');
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.xl),
                                ),
                              ),
                              child: Text(
                                'Kembali ke Beranda',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailScreen({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  Color getStatusColor() {
    switch (transaction.status) {
      case TransactionStatus.success:
        return AppColors.successGreen;
      case TransactionStatus.pending:
        return AppColors.warningYellow;
      case TransactionStatus.failed:
        return AppColors.errorRed;
      case TransactionStatus.processing:
        return AppColors.infoBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                      color: getStatusColor().withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        transaction.status == TransactionStatus.success
                            ? Iconsax.tick_square
                            : Iconsax.timer_1,
                        color: getStatusColor(),
                        size: 48,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        transaction.statusLabel,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              color: getStatusColor(),
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Transaction details
                Text(
                  'Rincian Transaksi',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                PremiumCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      _DetailRow(
                        label: 'ID Transaksi',
                        value: transaction.id,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Divider(
                        color: AppColors.border.withOpacity(0.5),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DetailRow(
                        label: 'Jenis',
                        value: transaction.title,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Divider(
                        color: AppColors.border.withOpacity(0.5),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DetailRow(
                        label: 'Nomor Tujuan',
                        value: transaction.targetNumber,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Divider(
                        color: AppColors.border.withOpacity(0.5),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DetailRow(
                        label: 'Operator',
                        value: transaction.operatorName ?? '-',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Divider(
                        color: AppColors.border.withOpacity(0.5),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DetailRow(
                        label: 'Metode Pembayaran',
                        value: _getPaymentMethodName(
                            transaction.paymentMethod),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Divider(
                        color: AppColors.border.withOpacity(0.5),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DetailRow(
                        label: 'Tanggal',
                        value: _formatDate(transaction.createdAt),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Price breakdown
                Text(
                  'Rincian Biaya',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                PremiumCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            'Rp${transaction.amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
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
                      if (transaction.adminFee != null &&
                          transaction.adminFee! > 0) ...[
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Biaya Admin',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            Text(
                              'Rp${transaction.adminFee}',
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
                      ],
                      Divider(
                        color: AppColors.border.withOpacity(0.5),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            'Rp${transaction.totalPrice.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
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
                // Action buttons
                SizedBox(
                  width: double.infinity,
                  child: PremiumButton(
                    label: 'Beli Lagi',
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home');
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

  String _getPaymentMethodName(PaymentMethodType type) {
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
        return 'Kartu Kredit';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }
}
