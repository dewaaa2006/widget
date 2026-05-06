import 'dart:async';

import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/app_state.dart';
import '../widgets/custom_widgets.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key, this.phone = ''});

  final String phone;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  late List<FocusNode> _nodes;
  late List<TextEditingController> _controllers;
  late Timer _timer;
  int _seconds = 45;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _nodes = List.generate(4, (_) => FocusNode());
    _controllers = List.generate(4, (_) => TextEditingController());
    _nodes[0].requestFocus();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _seconds -= 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (final node in _nodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onOtpChange(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _nodes[index + 1].requestFocus();
    }
  }

  void _verifyCode() {
    final code = _controllers.map((e) => e.text).join();
    if (code.length < 4) {
      _showToast('Masukkan kode OTP lengkap');
      return;
    }
    AppState.login();
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  void _resendCode() {
    if (!_canResend) return;
    setState(() {
      _seconds = 45;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _seconds -= 1;
        });
      }
    });
    _showToast('Kode OTP telah dikirim ulang');
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verifikasi OTP',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Masukkan kode verifikasi yang dikirim ke ${widget.phone.isEmpty ? AppState.currentUser.phone : widget.phone}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 64,
                    height: 72,
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
                          borderSide: BorderSide(
                            color: AppColors.border,
                          ),
                        ),
                      ),
                      onChanged: (value) => _onOtpChange(value, index),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Text(
                    'Kirim ulang dalam ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  Text(
                    _canResend ? 'Sekarang' : '00:${_seconds.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: PremiumButton(
                  label: 'Verifikasi & Masuk',
                  onPressed: _verifyCode,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: _canResend ? _resendCode : null,
                child: Text(
                  'Kirim ulang kode',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _canResend ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
