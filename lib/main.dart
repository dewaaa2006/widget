import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'models/models.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pulsa_screen.dart';
import 'screens/data_screen.dart';
import 'screens/topup_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/transaction_history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/success_detail_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/payment_methods_screen.dart';
import 'screens/voucher_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/promo_center_screen.dart';
import 'screens/rewards_screen.dart';
import 'screens/help_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/search_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/security_settings_screen.dart';
import 'screens/referral_screen.dart';
import 'screens/pln_token_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ultra.X',
      theme: AppTheme.lightTheme(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/pulsa': (context) => const PulsaScreen(),
        '/data': (context) => const DataScreen(),
        '/topup': (context) => const TopUpScreen(),
        '/pln': (context) => const PLNTokenScreen(),
        '/cart': (context) => const CartScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/security': (context) => const SecuritySettingsScreen(),
        '/referral': (context) => const ReferralScreen(),
        '/payment-methods': (context) => const PaymentMethodsScreen(),
        '/voucher': (context) => const VoucherScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/promo': (context) => const PromoCenterScreen(),
        '/rewards': (context) => const RewardsScreen(),
        '/help': (context) => const HelpScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/history': (context) => const TransactionHistoryScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/otp':
            final phone = settings.arguments as String?;
            return MaterialPageRoute(
              builder: (context) => OTPPage(phone: phone ?? ''),
              settings: settings,
            );
          case '/checkout':
            final extra = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => CheckoutScreen(
                product: extra?['product'],
                operator: extra?['operator'],
                phone: extra?['phone'],
                type: extra?['type'],
              ),
              settings: settings,
            );
          case '/success':
            final extra = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => SuccessScreen(
                type: extra?['type'],
                amount: extra?['amount'],
                transactions: extra?['transactions'],
              ),
              settings: settings,
            );
          case '/transaction-detail':
            final transaction = settings.arguments as Transaction?;
            return MaterialPageRoute(
              builder: (context) => TransactionDetailScreen(
                transaction: transaction!,
              ),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const SplashScreen(),
              settings: settings,
            );
        }
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
