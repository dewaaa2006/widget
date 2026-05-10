import '../models/models.dart';

class AppState {
  static bool hasSeenOnboarding = false;
  static bool isLoggedIn = false;
  static final Set<String> claimedPromoIds = <String>{};
  static final Set<String> claimedVoucherCodes = <String>{};
  static final List<String> availableAvatars = [
    'AR',
    'AU',
    'AX',
    '✨',
    '⚡',
    '💎',
    '🚀',
    '🌊',
  ];

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
  static Map<String, String>? pendingRegistration;

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

  static void startRegistration({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    pendingRegistration = {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  static bool get hasPendingRegistration => pendingRegistration != null;

  static void completePendingRegistration() {
    final registration = pendingRegistration;
    if (registration == null) return;
    final name = registration['name'] ?? 'Pengguna Ultra.X';
    final initials = _buildInitials(name);
    currentUser = User(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: registration['email'] ?? '',
      phone: registration['phone'] ?? '',
      avatar: initials,
      balance: 0,
      loyaltyLevel: 1,
      createdAt: DateTime.now(),
    );
    pendingRegistration = null;
    isLoggedIn = true;
  }

  static String _buildInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return 'UX';
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  static bool isPromoClaimed(String promoId) {
    return claimedPromoIds.contains(promoId);
  }

  static bool isVoucherClaimed(String code) {
    return claimedVoucherCodes.contains(code.toUpperCase());
  }

  static void claimPromo(String promoId, {String? voucherCode, String? title}) {
    claimedPromoIds.add(promoId);
    if (voucherCode != null) {
      claimedVoucherCodes.add(voucherCode.toUpperCase());
      VoucherRepository.addVoucher(
        Voucher(
          id: 'CLAIM-${promoId.toUpperCase()}',
          code: voucherCode.toUpperCase(),
          title: title ?? 'Voucher Klaim Promo',
          description: 'Voucher hasil klaim promo Ultra.X.',
          discountAmount: 2000,
          discountPercent: 0,
          minPurchase: 20000,
          validUntil: DateTime.now().add(const Duration(days: 14)),
          isUsed: false,
        ),
      );
    }
  }
}
