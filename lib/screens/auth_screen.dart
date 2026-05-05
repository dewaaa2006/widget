import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../widgets/custom_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Masuk ke akun Ultra.X Anda',
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
                      // Phone field
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
                      // Password field
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
                      // Forgot password
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
                // Login button
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
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/home');
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Signup link
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.6, 1),
                    ),
                  ),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Belum punya akun? ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        children: [
                          TextSpan(
                            text: 'Daftar',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                            recognizer: null,
                          ),
                        ],
                      ),
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
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              children: [
                // Name field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama Lengkap',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
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
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                // Email field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
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
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                // Phone field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nomor Telepon',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                // Password field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kata Sandi',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                const SizedBox(height: AppSpacing.lg),
                // Terms checkbox
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
                // Register button
                SizedBox(
                  width: double.infinity,
                  child: PremiumButton(
                    label: 'Daftar',
                    onPressed: () {
                      if (_agreeTerms) {
                        Navigator.of(context)
                            .pushReplacementNamed('/home');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Mohon setujui syarat dan ketentuan'),
                          ),
                        );
                      }
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
}
