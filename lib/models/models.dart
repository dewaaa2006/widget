import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../config/theme.dart';

// User Model
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final double balance;
  final int loyaltyLevel;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.balance,
    required this.loyaltyLevel,
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    double? balance,
    int? loyaltyLevel,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      balance: balance ?? this.balance,
      loyaltyLevel: loyaltyLevel ?? this.loyaltyLevel,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// Operator Model
enum Operator {
  telkomsel,
  xl,
  indosat,
  tri,
  smartfren,
}

class OperatorInfo {
  final Operator operator;
  final String displayName;
  final String logo;
  final String color;

  OperatorInfo({
    required this.operator,
    required this.displayName,
    required this.logo,
    required this.color,
  });
}

// Pulsa Product Model
class PulsaProduct {
  final String id;
  final int nominal;
  final int price;
  final int originalPrice;
  final int discount;
  final bool isPromo;
  final String promoLabel;

  PulsaProduct({
    required this.id,
    required this.nominal,
    required this.price,
    required this.originalPrice,
    required this.discount,
    this.isPromo = false,
    this.promoLabel = '',
  });
}

// Data Package Model
class DataPackage {
  final String id;
  final String name;
  final String category; // internet, combo, malam, streaming, gaming
  final String quota;
  final String validityDays;
  final int price;
  final int originalPrice;
  final int discount;
  final bool isPromo;
  final List<String> benefits;

  DataPackage({
    required this.id,
    required this.name,
    required this.category,
    required this.quota,
    required this.validityDays,
    required this.price,
    required this.originalPrice,
    required this.discount,
    this.isPromo = false,
    required this.benefits,
  });
}

// Payment Method Model
enum PaymentMethodType {
  saldo,
  virtualAccount,
  eWallet,
  qris,
  card,
}

class PaymentMethod {
  final String id;
  final PaymentMethodType type;
  final String displayName;
  final String subtitle;
  final IconData icon;
  final String lastDigits;
  final bool isDefault;
  final String? bankName;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.displayName,
    required this.subtitle,
    required this.icon,
    required this.lastDigits,
    required this.isDefault,
    this.bankName,
  });
}

// Transaction Model
enum TransactionStatus {
  pending,
  processing,
  success,
  failed,
}

enum TransactionType {
  pulsa,
  data,
  topup,
  electric,
  voucher,
}

class Transaction {
  final String id;
  final TransactionType type;
  final String title;
  final String description;
  final String targetNumber;
  final String? operatorName;
  final int amount;
  final int totalPrice;
  final int? adminFee;
  final int? discount;
  final TransactionStatus status;
  final PaymentMethodType paymentMethod;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? referenceNumber;

  Transaction({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.targetNumber,
    this.operatorName,
    required this.amount,
    required this.totalPrice,
    this.adminFee,
    this.discount,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    this.completedAt,
    this.referenceNumber,
  });

  String get statusLabel {
    switch (status) {
      case TransactionStatus.pending:
        return 'Menunggu';
      case TransactionStatus.processing:
        return 'Diproses';
      case TransactionStatus.success:
        return 'Berhasil';
      case TransactionStatus.failed:
        return 'Gagal';
    }
  }
}

class TransactionRepository {
  static final List<Transaction> transactions = [
    Transaction(
      id: 'TRX001',
      type: TransactionType.pulsa,
      title: 'Top Up Pulsa',
      description: 'Telkomsel',
      targetNumber: '08123456789',
      operatorName: 'Telkomsel',
      amount: 100000,
      totalPrice: 100000,
      adminFee: 0,
      discount: 0,
      status: TransactionStatus.success,
      paymentMethod: PaymentMethodType.saldo,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      completedAt: DateTime.now().subtract(const Duration(hours: 2)),
      referenceNumber: 'REF20240505001',
    ),
    Transaction(
      id: 'TRX002',
      type: TransactionType.data,
      title: 'Paket Data',
      description: 'XL 10GB/30 Hari',
      targetNumber: '08987654321',
      operatorName: 'XL Axiata',
      amount: 99000,
      totalPrice: 99000,
      adminFee: 0,
      discount: 0,
      status: TransactionStatus.success,
      paymentMethod: PaymentMethodType.virtualAccount,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      completedAt: DateTime.now().subtract(const Duration(hours: 5)),
      referenceNumber: 'REF20240505002',
    ),
  ];

  static void add(Transaction transaction) {
    transactions.insert(0, transaction);
  }

  static void addTransaction(Transaction transaction) {
    add(transaction);
  }
}

// Voucher Model
class Voucher {
  final String id;
  final String code;
  final String title;
  final String description;
  final int discountAmount;
  final int discountPercent;
  final int minPurchase;
  final DateTime validUntil;
  final bool isUsed;

  Voucher({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discountAmount,
    required this.discountPercent,
    required this.minPurchase,
    required this.validUntil,
    required this.isUsed,
  });
}

class TopUpOption {
  final String id;
  final int amount;
  final String label;
  final int bonus;
  final String? badge;

  TopUpOption({
    required this.id,
    required this.amount,
    required this.label,
    this.bonus = 0,
    this.badge,
  });
}

class Promo {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<Color> gradient;
  final String discountLabel;
  final String? code;

  Promo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.gradient,
    required this.discountLabel,
    this.code,
  });
}

class PromoRepository {
  static final List<Promo> promos = [
    Promo(
      id: 'PROMO1',
      title: 'Cashback Ultra',
      subtitle: 'Hingga 50% untuk transaksi pertama kamu',
      description: 'Gunakan kode ULTRAXFIRST sekarang dan nikmati cashback instan.',
      gradient: [AppColors.primary, AppColors.primaryGradient],
      discountLabel: '50% OFF',
      code: 'ULTRAXFIRST',
    ),
    Promo(
      id: 'PROMO2',
      title: 'Bebas Admin',
      subtitle: 'Top up tanpa biaya admin sampai akhir bulan',
      description: 'Top up saldo Ultra.X sekarang tanpa biaya admin sama sekali.',
      gradient: [AppColors.accentOrange, AppColors.accentOrangeBright],
      discountLabel: 'Gratis',
      code: 'NOADMIN',
    ),
  ];
}

class VoucherRepository {
  static final List<Voucher> vouchers = [
    Voucher(
      id: 'VCH001',
      code: 'ULTRA50',
      title: 'Diskon 50% Top Up',
      description: 'Gunakan untuk top up saldo dan dapatkan potongan 50%.',
      discountAmount: 0,
      discountPercent: 50,
      minPurchase: 50000,
      validUntil: DateTime.now().add(const Duration(days: 14)),
      isUsed: false,
    ),
    Voucher(
      id: 'VCH002',
      code: 'FLASH20',
      title: 'Diskon 20% Pakai QRIS',
      description: 'Potongan khusus saat membayar melalui QRIS.',
      discountAmount: 0,
      discountPercent: 20,
      minPurchase: 100000,
      validUntil: DateTime.now().add(const Duration(days: 7)),
      isUsed: false,
    ),
  ];

  static void addVoucher(Voucher voucher) {
    final exists = vouchers.any((item) => item.code == voucher.code);
    if (!exists) {
      vouchers.insert(0, voucher);
    }
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final bool unread;
  final String timestamp;
  final IconData icon;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.unread,
    required this.timestamp,
    required this.icon,
  });
}

class NotificationRepository {
  static final List<NotificationItem> notifications = [
    NotificationItem(
      id: 'NOTIF1',
      title: 'Transaksi Berhasil',
      body: 'Pulsa Telkomsel Rp100.000 berhasil dikirim.',
      unread: false,
      timestamp: '2 jam lalu',
      icon: Icons.check_circle,
    ),
    NotificationItem(
      id: 'NOTIF2',
      title: 'Promo Spesial',
      body: 'Dapatkan hadiah hingga Rp50.000 untuk top up pertama minggu ini.',
      unread: true,
      timestamp: '5 jam lalu',
      icon: Icons.local_offer,
    ),
  ];
}

class RewardMission {
  final String id;
  final String title;
  final String subtitle;
  final int points;

  RewardMission({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.points,
  });
}

class RewardData {
  final int points;
  final String description;

  RewardData({
    required this.points,
    required this.description,
  });
}

class RewardRepository {
  static final RewardData reward = RewardData(
    points: 1_240,
    description: 'Tukarkan poin untuk voucher, cashback, dan keuntungan eksklusif.',
  );

  static final List<RewardMission> missions = [
    RewardMission(
      id: 'RWD1',
      title: 'Bayar 3 transaksi',
      subtitle: 'Dapatkan 100 poin bonus ketika selesai melakukan 3 transaksi.',
      points: 100,
    ),
    RewardMission(
      id: 'RWD2',
      title: 'Top up saldo',
      subtitle: 'Top up saldo Rp100.000 atau lebih untuk mendapatkan 75 poin.',
      points: 75,
    ),
  ];
}

class HelpQuestion {
  final String id;
  final String question;
  final String answer;

  HelpQuestion({
    required this.id,
    required this.question,
    required this.answer,
  });
}

class HelpRepository {
  static final List<HelpQuestion> questions = [
    HelpQuestion(
      id: 'HELP1',
      question: 'Bagaimana cara top up saldo?',
      answer: 'Buka menu Top Up, pilih nominal, lalu selesaikan pembayaran menggunakan metode yang Anda pilih.',
    ),
    HelpQuestion(
      id: 'HELP2',
      question: 'Apakah ada biaya admin?',
      answer: 'Beberapa promo memberikan bebas biaya admin. Biasanya biaya admin Rp1.500 untuk transaksi biasa.',
    ),
    HelpQuestion(
      id: 'HELP3',
      question: 'Bagaimana cara mengajukan komplain?',
      answer: 'Hubungi pusat bantuan melalui profil atau fitur live chat di halaman bantuan.',
    ),
  ];
}

class PaymentMethodRepository {
  static final List<PaymentMethod> methods = [
    PaymentMethod(
      id: 'PM1',
      type: PaymentMethodType.saldo,
      displayName: 'Saldo Ultra.X',
      subtitle: 'Rp1.250.000',
      icon: Iconsax.wallet,
      lastDigits: 'Saldo',
      isDefault: true,
    ),
    PaymentMethod(
      id: 'PM2',
      type: PaymentMethodType.eWallet,
      displayName: 'GoPay',
      subtitle: 'Rp 250.000 tersedia',
      icon: Iconsax.wallet,
      lastDigits: '1234',
      isDefault: false,
      bankName: 'GoPay',
    ),
    PaymentMethod(
      id: 'PM3',
      type: PaymentMethodType.virtualAccount,
      displayName: 'BCA Virtual',
      subtitle: 'VA 7890',
      icon: Iconsax.bank,
      lastDigits: '7890',
      isDefault: false,
      bankName: 'BCA',
    ),
  ];

  static void addMethod(PaymentMethod method) {
    methods.add(method);
  }
}

// Cart Item Model
class CartItem {
  final String id;
  final TransactionType type;
  final dynamic product; // PulsaProduct, DataPackage, or TopUpOption
  final String displayName;
  final String targetNumber;
  final Operator? operator;
  final int price;
  final String? voucherId;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.type,
    required this.product,
    required this.displayName,
    required this.targetNumber,
    this.operator,
    required this.price,
    this.voucherId,
    required this.addedAt,
  });

  CartItem copyWith({
    String? id,
    TransactionType? type,
    dynamic product,
    String? displayName,
    String? targetNumber,
    Operator? operator,
    int? price,
    String? voucherId,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      type: type ?? this.type,
      product: product ?? this.product,
      displayName: displayName ?? this.displayName,
      targetNumber: targetNumber ?? this.targetNumber,
      operator: operator ?? this.operator,
      price: price ?? this.price,
      voucherId: voucherId ?? this.voucherId,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}

// Cart Repository
class CartRepository {
  static final List<CartItem> items = [];

  static void addItem(CartItem item) {
    items.add(item);
  }

  static void removeItem(String id) {
    items.removeWhere((item) => item.id == id);
  }

  static void updateItem(String id, CartItem updatedItem) {
    final index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      items[index] = updatedItem;
    }
  }

  static void clear() {
    items.clear();
  }

  static int get itemCount => items.length;

  static int getTotalPrice() {
    return items.fold(0, (sum, item) => sum + item.price);
  }
}

// Favorite Number Model
class FavoriteNumber {
  final String id;
  final String name;
  final String phone;
  final Operator operator;
  final DateTime createdAt;

  FavoriteNumber({
    required this.id,
    required this.name,
    required this.phone,
    required this.operator,
    required this.createdAt,
  });
}

// Favorite Repository
class FavoriteRepository {
  static final List<FavoriteNumber> favorites = [
    FavoriteNumber(
      id: 'FAV1',
      name: 'Nomor Utama',
      phone: '08123456789',
      operator: Operator.telkomsel,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    FavoriteNumber(
      id: 'FAV2',
      name: 'Nomor Kerja',
      phone: '08987654321',
      operator: Operator.xl,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  static void addFavorite(FavoriteNumber favorite) {
    favorites.add(favorite);
  }

  static void removeFavorite(String id) {
    favorites.removeWhere((fav) => fav.id == id);
  }
}

class FavoritesRepository {
  static List<FavoriteNumber> get favorites => FavoriteRepository.favorites;

  static void addFavorite(FavoriteNumber favorite) {
    FavoriteRepository.addFavorite(favorite);
  }

  static void removeFavorite(String id) {
    FavoriteRepository.removeFavorite(id);
  }
}

// Loyalty Data Model
class LoyaltyData {
  final int currentLevel;
  final int totalPoints;
  final int pointsToNextLevel;
  final List<String> achievedBadges;
  final DateTime memberSince;

  LoyaltyData({
    required this.currentLevel,
    required this.totalPoints,
    required this.pointsToNextLevel,
    required this.achievedBadges,
    required this.memberSince,
  });
}

// Help Ticket Model
class HelpTicket {
  final String id;
  final String category;
  final String subject;
  final String description;
  final String status; // open, pending, resolved, closed
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? imageUrl;

  HelpTicket({
    required this.id,
    required this.category,
    required this.subject,
    required this.description,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.imageUrl,
  });
}

// Help Ticket Repository
class HelpTicketRepository {
  static final List<HelpTicket> tickets = [
    HelpTicket(
      id: 'TKT001',
      category: 'Pembayaran',
      subject: 'Transaksi gagal tapi saldo berkurang',
      description: 'Saya coba top up Rp100.000 tapi gagal, tapi saldo saya berkurang.',
      status: 'resolved',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  static void addTicket(HelpTicket ticket) {
    tickets.insert(0, ticket);
  }

  static List<HelpTicket> getOpenTickets() {
    return tickets.where((t) => t.status == 'open').toList();
  }
}
