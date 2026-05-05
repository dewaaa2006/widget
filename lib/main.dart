import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'config/theme.dart';
import 'models/models.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pulsa_screen.dart';
import 'screens/data_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/transaction_history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/success_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ultra.X',
      theme: AppTheme.lightTheme(),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/pulsa',
      builder: (context, state) => const PulsaScreen(),
    ),
    GoRoute(
      path: '/data',
      builder: (context, state) => const DataScreen(),
    ),
    GoRoute(
      path: '/topup',
      builder: (context, state) => const PulsaScreen(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return CheckoutScreen(
          product: extra['product'],
          operator: extra['operator'],
          phone: extra['phone'],
          type: extra['type'],
        );
      },
    ),
    GoRoute(
      path: '/success',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return SuccessScreen(
          type: extra['type'],
          amount: extra['amount'],
        );
      },
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const TransactionHistoryScreen(),
    ),
    GoRoute(
      path: '/transaction-detail',
      builder: (context, state) {
        final transaction = state.extra as Transaction;
        return TransactionDetailScreen(transaction: transaction);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);

