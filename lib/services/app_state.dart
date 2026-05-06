import '../models/models.dart';

class AppState {
  static bool hasSeenOnboarding = false;
  static bool isLoggedIn = false;

  static User currentUser = User(
    id: 'user-001',
    name: 'Alya Rahma',
    email: 'alya.rahma@example.com',
    phone: '081234567890',
    avatar: 'AR',
    balance: 1_250_000,
    loyaltyLevel: 4,
    createdAt: DateTime.now().subtract(const Duration(days: 520)),
  );

  static void completeOnboarding() {
    hasSeenOnboarding = true;
  }

  static void login() {
    isLoggedIn = true;
  }

  static void logout() {
    isLoggedIn = false;
  }

  static void updateUser(User user) {
    currentUser = user;
  }

  static void updateBalance(double balance) {
    currentUser = currentUser.copyWith(balance: balance);
  }
}
