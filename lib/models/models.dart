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
  final String lastDigits;
  final bool isDefault;
  final String? bankName;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.displayName,
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

// Promo Model
class Promo {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int discountPercent;
  final DateTime validUntil;
  final String? code;

  Promo({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.discountPercent,
    required this.validUntil,
    this.code,
  });
}

// Voucher Model
class Voucher {
  final String id;
  final String code;
  final String title;
  final int discountAmount;
  final int discountPercent;
  final int minPurchase;
  final DateTime validUntil;
  final bool isUsed;

  Voucher({
    required this.id,
    required this.code,
    required this.title,
    required this.discountAmount,
    required this.discountPercent,
    required this.minPurchase,
    required this.validUntil,
    required this.isUsed,
  });
}
