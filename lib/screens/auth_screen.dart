import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../config/constants.dart';
import '../config/theme.dart';
import '../services/app_state.dart';
import '../services/telegram_otp_service.dart';
import '../widgets/custom_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_phoneController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi nomor telepon dan kata sandi'),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    Future<void>.delayed(const Duration(milliseconds: 650), () async {
      if (!mounted) return;
      final phone = _phoneController.text.trim();
      var result = TelegramOtpService.requestOtp(phone: phone);
      if (!result.linked && mounted) {
        final shouldLink = await _showTelegramLinkSheet(phone);
        if (!mounted) return;
        if (shouldLink == true) {
          TelegramOtpService.connectDemoTelegram(phone);
          result = TelegramOtpService.requestOtp(phone: phone);
        }
      }
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (!result.linked || result.session == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
      Navigator.of(context).pushReplacementNamed(
        '/otp',
        arguments: {
          'phone': phone,
          'sessionId': result.session!.id,
        },
      );
    });
  }

  Future<bool?> _showTelegramLinkSheet(String phone) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final suggested = '@ultrax_${phone.substring(phone.length >= 4 ? phone.length - 4 : 0)}';
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
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
                    width: 54,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Hubungkan Telegram Demo',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Nomor ini belum terhubung ke bot Telegram resmi Ultra.X. Untuk demo/UTS, kami bisa membuat link sandbox ke akun $suggested lalu mengirim OTP ke sana.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                PremiumButton(
                  label: 'Hubungkan dan Kirim OTP',
                  onPressed: () => Navigator.pop(context, true),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Nanti Saja'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.1, 0.5),
                    ),
                  ),
                  child: const AnimatedPromoBanner(
                    title: 'Masuk dan Buka Promo Eksklusif',
                    subtitle:
                        'Cashback hingga 10% dan voucher prioritas langsung aktif setelah login ke akun Ultra.X.',
                    badge: 'Flash Promo',
                    cta: 'Masuk dan klaim benefit sekarang',
                    icon: Iconsax.discount_circle,
                    height: 178,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.5, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0, 0.4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat Datang',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Masuk ke akun Ultra.X Anda',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.2, 0.6),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nomor Telepon',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: '08123456789',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Icon(
                                  Iconsax.mobile,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kata Sandi',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Icon(
                                  Iconsax.lock,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                child: Icon(
                                  _obscurePassword
                                      ? Iconsax.eye
                                      : Iconsax.eye_slash,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Lupa Kata Sandi?',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.4, 0.8),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: PremiumButton(
                      label: 'Masuk',
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _login,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.6, 1),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/register');
                          },
                          child: Text(
                            'Daftar',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
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
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late AnimationController _animationController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    )..forward();
    _passwordController.addListener(_refreshState);
    _confirmPasswordController.addListener(_refreshState);
  }

  void _refreshState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _passwordController.removeListener(_refreshState);
    _confirmPasswordController.removeListener(_refreshState);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  int get _passwordStrength {
    final password = _passwordController.text;
    var score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[^A-Za-z0-9]'))) score++;
    return score;
  }

  String get _passwordStrengthLabel {
    switch (_passwordStrength) {
      case 0:
      case 1:
        return 'Lemah';
      case 2:
        return 'Cukup';
      case 3:
        return 'Kuat';
      default:
        return 'Sangat kuat';
    }
  }

  void _register() {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua field pendaftaran')),
      );
      return;
    }
    if (!_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email belum valid')),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi kata sandi tidak cocok')),
      );
      return;
    }
    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi minimal 8 karakter')),
      );
      return;
    }
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon setujui syarat dan ketentuan')),
      );
      return;
    }

    setState(() => _isLoading = true);
    AppState.startRegistration(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      final result = TelegramOtpService.requestOtp(
        phone: _phoneController.text.trim(),
        autoLinkIfNeeded: true,
      );
      setState(() => _isLoading = false);
      if (result.session == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
      Navigator.of(context).pushReplacementNamed(
        '/otp',
        arguments: {
          'phone': _phoneController.text.trim(),
          'sessionId': result.session!.id,
        },
      );
    });
  }

  Widget _animatedSection({
    required double start,
    required double end,
    required Widget child,
    Offset begin = const Offset(0, 0.08),
  }) {
    final curved = CurvedAnimation(
      parent: _animationController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: begin,
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strengthValue = _passwordStrength / 4;
    final strengthColor = _passwordStrength >= 3
        ? AppColors.successGreen
        : AppColors.accentOrangeBright;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Daftar Akun Baru'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _animatedSection(
                  start: 0,
                  end: 0.34,
                  begin: const Offset(0, -0.06),
                  child: const AnimatedPromoBanner(
                    title: 'Member Baru, Benefit Lebih Tinggi',
                    subtitle:
                        'Daftar sekarang dan nikmati voucher pengguna baru, cashback awal, dan bebas admin top up pertama.',
                    badge: 'Welcome Bonus',
                    cta: 'Buat akun dan aktifkan promo',
                    icon: Iconsax.user_add,
                    height: 188,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _animatedSection(
                  start: 0.10,
                  end: 0.44,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buka akun Ultra.X',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Lengkapi data kamu dan nikmati promo pengguna baru secara otomatis.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _animatedSection(
                  start: 0.18,
                  end: 0.60,
                  child: _RegisterField(
                    label: 'Nama Lengkap',
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Budi Santoso',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Icon(
                            Iconsax.user,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _animatedSection(
                  start: 0.24,
                  end: 0.66,
                  child: _RegisterField(
                    label: 'Email',
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'budi@email.com',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Icon(
                            Iconsax.sms,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _animatedSection(
                  start: 0.30,
                  end: 0.72,
                  child: _RegisterField(
                    label: 'Nomor Telepon',
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '08123456789',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Icon(
                            Iconsax.mobile,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _animatedSection(
                  start: 0.36,
                  end: 0.78,
                  child: _RegisterField(
                    label: 'Kata Sandi',
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Icon(
                            Iconsax.lock,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          child: Icon(
                            _obscurePassword
                                ? Iconsax.eye
                                : Iconsax.eye_slash,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _animatedSection(
                  start: 0.42,
                  end: 0.84,
                  child: _RegisterField(
                    label: 'Konfirmasi Kata Sandi',
                    child: TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Ulangi kata sandi',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Icon(
                            Iconsax.lock,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                          child: Icon(
                            _obscureConfirmPassword
                                ? Iconsax.eye
                                : Iconsax.eye_slash,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _animatedSection(
                  start: 0.50,
                  end: 0.90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: strengthValue,
                          minHeight: 8,
                          backgroundColor: AppColors.surfaceLow,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            strengthColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Kekuatan password: $_passwordStrengthLabel',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: strengthColor,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _animatedSection(
                  start: 0.58,
                  end: 0.96,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _agreeTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreeTerms = value ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'Saya setuju dengan ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                children: [
                                  TextSpan(
                                    text: 'Syarat & Ketentuan',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      SizedBox(
                        width: double.infinity,
                        child: PremiumButton(
                          label: 'Daftar',
                          isLoading: _isLoading,
                          onPressed: _isLoading ? null : _register,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterField extends StatelessWidget {
  const _RegisterField({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}
