import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../config/theme.dart';
import '../models/payment_simulation.dart';
import '../services/app_state.dart';
import '../services/telegram_otp_service.dart';
import '../widgets/custom_widgets.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({
    super.key,
    this.phone = '',
    this.sessionId,
  });

  final String phone;
  final String? sessionId;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  late final List<FocusNode> _nodes;
  late final List<TextEditingController> _controllers;
  Timer? _ticker;
  bool _isVerifying = false;
  late OtpSession? _session;
  int _expirySeconds = 0;
  int _resendSeconds = 0;

  @override
  void initState() {
    super.initState();
    _nodes = List.generate(6, (_) => FocusNode());
    _controllers = List.generate(6, (_) => TextEditingController());
    _session = TelegramOtpService.getSession(
      widget.sessionId,
      phone: widget.phone,
    );
    _syncSession();
    _nodes.first.requestFocus();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _syncSession());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    for (final node in _nodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _syncSession() {
    final latest = TelegramOtpService.getSession(
      _session?.id ?? widget.sessionId,
      phone: widget.phone,
    );
    if (!mounted) return;
    setState(() {
      _session = latest;
      if (latest != null) {
        _expirySeconds = TelegramOtpService.secondsUntilExpiry(latest);
        _resendSeconds = TelegramOtpService.secondsUntilResend(latest);
      }
    });
  }

  void _onOtpChange(String value, int index) {
    if (value.isNotEmpty && index < _nodes.length - 1) {
      _nodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyCode() async {
    final session = _session;
    if (session == null) {
      _showToast('Sesi OTP tidak ditemukan. Minta kode baru terlebih dulu.');
      return;
    }
    final code = _controllers.map((item) => item.text).join();
    if (code.length < 6) {
      _showToast('Masukkan 6 digit kode OTP lengkap');
      return;
    }

    setState(() => _isVerifying = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final result = TelegramOtpService.verifyOtp(
      sessionId: session.id,
      code: code,
    );
    if (!mounted) return;
    setState(() {
      _isVerifying = false;
      _session = result.session;
    });
    _showToast(result.message);

    if (!result.success) return;
    if (AppState.hasPendingRegistration) {
      AppState.completePendingRegistration();
    } else {
      AppState.login();
    }
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  void _resendCode() {
    final session = _session;
    if (session == null) {
      _showToast('Sesi OTP tidak tersedia.');
      return;
    }
    final result = TelegramOtpService.resendOtp(session.id);
    setState(() {
      _session = result.session;
      for (final controller in _controllers) {
        controller.clear();
      }
    });
    _nodes.first.requestFocus();
    _showToast(result.message);
    _syncSession();
  }

  void _connectTelegram() {
    final linked = TelegramOtpService.connectDemoTelegram(widget.phone);
    final result = TelegramOtpService.requestOtp(phone: widget.phone);
    setState(() => _session = result.session);
    _showToast('Telegram demo $linked berhasil dihubungkan.');
    _syncSession();
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    final hasLinkedTelegram = session?.telegramHandle != null ||
        TelegramOtpService.isTelegramLinked(widget.phone);
    final phoneLabel = widget.phone.isEmpty ? AppState.currentUser.phone : widget.phone;
    final attemptLabel = session == null
        ? '-'
        : '${session.remainingAttempts}/${session.maxAttempts} percobaan';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verifikasi via Telegram Bot',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Kami mengirim OTP sandbox ke bot resmi Ultra.X untuk nomor $phoneLabel.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (!hasLinkedTelegram) ...[
                PremiumCard(
                  backgroundColor: const Color(0xFFFFF5E9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Telegram belum terhubung',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Untuk demo/UTS, hubungkan akun Telegram sandbox lalu kami kirim OTP dari bot resmi Ultra.X.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      PremiumButton(
                        label: 'Hubungkan Telegram Demo',
                        onPressed: _connectTelegram,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              if (session != null) ...[
                PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Iconsax.message, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              session.botName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          StatusChip(
                            label: session.telegramHandle ?? 'Belum linked',
                            backgroundColor: AppColors.primary,
                            textColor: AppColors.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Inbox Preview Telegram Demo',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              session.deliveryMessage,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: _OtpMeta(
                              label: 'Sisa waktu',
                              value: '00:${_expirySeconds.toString().padLeft(2, '0')}',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _OtpMeta(
                              label: 'Percobaan',
                              value: attemptLabel,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_controllers.length, (index) {
                  return SizedBox(
                    width: 46,
                    height: 68,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _nodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: AppColors.surfaceCard,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                      ),
                      onChanged: (value) => _onOtpChange(value, index),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.lg),
              const AnimatedPromoBanner(
                title: 'OTP via Bot Resmi Sandbox',
                subtitle:
                    'Verifikasi ini memakai Telegram bot demo Ultra.X, bukan SMS atau nomor palsu, agar tetap aman dan realistis untuk presentasi akademik.',
                badge: 'Sandbox Auth',
                cta: 'Verifikasi akun sekarang',
                icon: Iconsax.shield_tick,
                height: 188,
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: PremiumButton(
                  label: 'Verifikasi & Masuk',
                  isLoading: _isVerifying,
                  onPressed: _isVerifying ? null : _verifyCode,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _resendSeconds == 0 ? _resendCode : null,
                      child: Text(
                        _resendSeconds == 0
                            ? 'Kirim ulang kode'
                            : 'Kirim ulang dalam $_resendSeconds dtk',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _resendSeconds == 0
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                  if (!hasLinkedTelegram)
                    TextButton(
                      onPressed: _connectTelegram,
                      child: const Text('Hubungkan Telegram'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpMeta extends StatelessWidget {
  const _OtpMeta({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 6),
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
