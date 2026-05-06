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
