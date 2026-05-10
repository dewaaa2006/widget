import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../config/app_helpers.dart';
import '../config/theme.dart';
import '../models/models.dart';
import '../models/payment_simulation.dart';
import '../services/app_state.dart';
import '../services/payment_gateway_service.dart';
import '../widgets/custom_widgets.dart';

class PaymentProcessingScreen extends StatefulWidget {
  const PaymentProcessingScreen({
    super.key,
    required this.intent,
    required this.items,
    required this.fromCart,
  });

  final PaymentIntent intent;
  final List<CartItem> items;
  final bool fromCart;

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late PaymentIntent _intent;
  late final List<String> _steps;
  Timer? _timer;
  int _activeStep = -1;
  int _remainingSeconds = 0;
  bool _processing = false;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _intent = widget.intent;
    _steps = PaymentGatewayService.processingStepsFor(widget.intent);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _remainingSeconds = _intent.expiresAt.difference(DateTime.now()).inSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _completed) return;
      final updated = _intent.expiresAt.difference(DateTime.now()).inSeconds;
      if (updated <= 0 &&
          !_processing &&
          _intent.method.type != PaymentMethodType.saldo &&
          _intent.status != PaymentIntentStatus.expired) {
        setState(() {
          _remainingSeconds = 0;
          _intent = PaymentGatewayService.markExpired(_intent);
        });
      } else {
        setState(() => _remainingSeconds = updated < 0 ? 0 : updated);
      }
    });

    if (_intent.method.type == PaymentMethodType.saldo) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _submitPayment();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitPayment() async {
    if (_processing || _completed) return;
    setState(() {
      _processing = true;
      if (_intent.method.type != PaymentMethodType.saldo) {
        _intent = PaymentGatewayService.markActionSubmitted(_intent);
      }
    });

    for (var index = 0; index < _steps.length; index++) {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      setState(() => _activeStep = index);
    }

    final result = PaymentGatewayService.finalizeIntent(_intent);
    _applyGatewayResult(result);
  }

  void _applyGatewayResult(PaymentGatewayResult result) {
    _completed = true;
    _timer?.cancel();
    for (final transaction in result.transactions) {
      TransactionRepository.add(transaction);
    }
    if (_intent.method.type == PaymentMethodType.saldo &&
        result.intent.status != PaymentIntentStatus.failed &&
        result.intent.status != PaymentIntentStatus.cancelled &&
        result.intent.status != PaymentIntentStatus.expired) {
      AppState.updateBalance(
        AppState.currentUser.balance - result.intent.totalAmount,
      );
    }
    if (widget.fromCart) {
      for (final item in widget.items) {
        CartRepository.removeItem(item.id);
      }
    }
    Navigator.pushReplacementNamed(
      context,
      '/success',
      arguments: {
        'type': 'gateway',
        'amount': result.intent.totalAmount,
        'transactions': result.transactions,
        'paymentIntent': result.intent,
      },
    );
  }

  Future<void> _copyValue(String label, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label disalin')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(_intent.status);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Payment Gateway Sandbox')),
      body: SafeArea(
        child: FadeTransition(
          opacity: _controller,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 130),
            children: [
              PremiumCard(
                backgroundColor: statusColor.withAlphaValue(0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: statusColor.withAlphaValue(0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _intent.method.icon,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _intent.gatewayName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _statusLabel(_intent.status),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: statusColor),
                              ),
                            ],
                          ),
                        ),
                        StatusChip(
                          label: _intent.status.name,
                          backgroundColor: statusColor,
                          textColor: statusColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _GatewayRow(label: 'Order ID', value: _intent.orderId),
                    _GatewayRow(
                      label: 'Payment Ref',
                      value: _intent.paymentReference,
                    ),
                    _GatewayRow(
                      label: 'Provider Ref',
                      value: _intent.providerReference ?? '-',
                    ),
                    _GatewayRow(
                      label: 'Waktu dibuat',
                      value: formatCompactDate(_intent.createdAt),
                    ),
                    _GatewayRow(
                      label: 'Batas bayar',
                      value: _remainingSeconds > 0
                          ? '00:${_remainingSeconds.toString().padLeft(2, '0')}'
                          : formatCompactDate(_intent.expiresAt),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan pembayaran',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ...widget.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(child: Text(item.displayName)),
                            Text(formatCurrency(item.price)),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 24),
                    _GatewayRow(
                      label: 'Subtotal',
                      value: formatCurrency(_intent.subtotal),
                    ),
                    _GatewayRow(
                      label: 'Diskon',
                      value: '-${formatCurrency(_intent.discount)}',
                    ),
                    _GatewayRow(
                      label: 'Admin fee',
                      value: formatCurrency(_intent.adminFee),
                    ),
                    _GatewayRow(
                      label: 'Service fee',
                      value: formatCurrency(_intent.serviceFee),
                    ),
                    _GatewayRow(
                      label: 'Total',
                      value: formatCurrency(_intent.totalAmount),
                      emphasize: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildInstructionCard(context),
              const SizedBox(height: 16),
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress gateway',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 14),
                    ...List.generate(_steps.length, (index) {
                      final active = _activeStep >= index;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 240),
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.primary
                                    : AppColors.surfaceLow,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                active ? Icons.check : Iconsax.more_circle,
                                size: 14,
                                color: active
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _steps[index],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
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
              const SizedBox(height: 16),
              const AnimatedPromoBanner(
                title: 'Sandbox Payment yang Meyakinkan',
                subtitle:
                    'Flow ini mensimulasikan payment intent, callback gateway, dan settlement provider agar demo terasa seperti aplikasi fintech sungguhan.',
                badge: 'Gateway Sandbox',
                cta: 'Lanjutkan sampai settlement',
                icon: Iconsax.card_tick,
                height: 188,
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
          child: _buildBottomActions(),
        ),
      ),
    );
  }

  Widget _buildInstructionCard(BuildContext context) {
    switch (_intent.method.type) {
      case PaymentMethodType.qris:
        return PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pembayaran QRIS',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLow,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Iconsax.scan_barcode, size: 58, color: AppColors.primary),
                    const SizedBox(height: 10),
                    Text(
                      'QRIS Sandbox',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Payload ${_intent.paymentReference}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Scan QR dengan mobile banking atau e-wallet, lalu tekan tombol bayar setelah callback sandbox diterima.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      case PaymentMethodType.virtualAccount:
        return PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Virtual Account',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLow,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _intent.method.displayName,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _intent.vaNumber ?? '-',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _copyValue(
                        'Nomor VA',
                        _intent.vaNumber ?? '-',
                      ),
                      icon: const Icon(Iconsax.copy),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Nomor VA ini akan dipolling secara berkala untuk membaca callback pembayaran sandbox.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      case PaymentMethodType.eWallet:
        return PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Redirect E-Wallet',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLow,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _intent.method.displayName,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _intent.deepLinkUrl ?? '-',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Simulasikan redirect ke aplikasi e-wallet, lalu kembali ke Ultra.X untuk menerima callback hasil pembayaran.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      case PaymentMethodType.saldo:
        return PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saldo Ultra.X',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Pembayaran saldo diproses instan. Sistem akan langsung membuat payment intent, memotong saldo, dan menunggu settlement produk.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      case PaymentMethodType.card:
        return PremiumCard(
          child: Text(
            'Kartu sandbox belum diaktifkan untuk demo ini.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
    }
  }

  Widget _buildBottomActions() {
    if (_intent.status == PaymentIntentStatus.expired) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ganti Metode'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PremiumButton(
              label: 'Buat Intent Baru',
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      );
    }

    if (_processing) {
      return PremiumButton(
        label: 'Memproses Gateway',
        isLoading: true,
        onPressed: null,
      );
    }

    if (_intent.method.type == PaymentMethodType.saldo) {
      return PremiumButton(
        label: 'Memproses Saldo',
        isLoading: true,
        onPressed: null,
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ganti Metode'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PremiumButton(
            label: _intent.method.type == PaymentMethodType.eWallet
                ? 'Saya Sudah Kembali'
                : 'Saya Sudah Bayar',
            onPressed: _submitPayment,
          ),
        ),
      ],
    );
  }

  String _statusLabel(PaymentIntentStatus status) {
    switch (status) {
      case PaymentIntentStatus.created:
        return 'Payment intent dibuat';
      case PaymentIntentStatus.awaitingAction:
        return 'Menunggu aksi pembayaran';
      case PaymentIntentStatus.pending:
        return 'Menunggu callback gateway';
      case PaymentIntentStatus.paid:
        return 'Pembayaran diterima';
      case PaymentIntentStatus.settled:
        return 'Settlement selesai';
      case PaymentIntentStatus.expired:
        return 'Pembayaran kedaluwarsa';
      case PaymentIntentStatus.failed:
        return 'Pembayaran gagal';
      case PaymentIntentStatus.cancelled:
        return 'Pembayaran dibatalkan';
      case PaymentIntentStatus.partialSuccess:
        return 'Pembayaran settle dengan hasil parsial';
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

class _GatewayRow extends StatelessWidget {
  const _GatewayRow({
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
