import 'models.dart';

enum PaymentIntentStatus {
  created,
  awaitingAction,
  pending,
  paid,
  settled,
  expired,
  failed,
  cancelled,
  partialSuccess,
}

enum TelegramVerificationState {
  linked,
  unlinked,
  sending,
  delivered,
  verified,
  expired,
  blocked,
}

class PaymentIntentItemSummary {
  final String id;
  final String label;
  final String target;
  final TransactionType type;
  final int amount;

  const PaymentIntentItemSummary({
    required this.id,
    required this.label,
    required this.target,
    required this.type,
    required this.amount,
  });
}

class PaymentIntent {
  final String id;
  final String orderId;
  final String paymentReference;
  final String? providerReference;
  final PaymentMethod method;
  final String gatewayName;
  final PaymentIntentStatus status;
  final List<PaymentIntentItemSummary> items;
  final int subtotal;
  final int discount;
  final int adminFee;
  final int serviceFee;
  final int totalAmount;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String? vaNumber;
  final String? qrisPayload;
  final String? deepLinkUrl;
  final String? note;

  const PaymentIntent({
    required this.id,
    required this.orderId,
    required this.paymentReference,
    required this.providerReference,
    required this.method,
    required this.gatewayName,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.adminFee,
    required this.serviceFee,
    required this.totalAmount,
    required this.createdAt,
    required this.expiresAt,
    this.vaNumber,
    this.qrisPayload,
    this.deepLinkUrl,
    this.note,
  });

  PaymentIntent copyWith({
    String? id,
    String? orderId,
    String? paymentReference,
    String? providerReference,
    PaymentMethod? method,
    String? gatewayName,
    PaymentIntentStatus? status,
    List<PaymentIntentItemSummary>? items,
    int? subtotal,
    int? discount,
    int? adminFee,
    int? serviceFee,
    int? totalAmount,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? vaNumber,
    String? qrisPayload,
    String? deepLinkUrl,
    String? note,
  }) {
    return PaymentIntent(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      paymentReference: paymentReference ?? this.paymentReference,
      providerReference: providerReference ?? this.providerReference,
      method: method ?? this.method,
      gatewayName: gatewayName ?? this.gatewayName,
      status: status ?? this.status,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      adminFee: adminFee ?? this.adminFee,
      serviceFee: serviceFee ?? this.serviceFee,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      vaNumber: vaNumber ?? this.vaNumber,
      qrisPayload: qrisPayload ?? this.qrisPayload,
      deepLinkUrl: deepLinkUrl ?? this.deepLinkUrl,
      note: note ?? this.note,
    );
  }
}

class PaymentGatewayResult {
  final PaymentIntent intent;
  final List<Transaction> transactions;
  final String message;

  const PaymentGatewayResult({
    required this.intent,
    required this.transactions,
    required this.message,
  });
}

class OtpSession {
  final String id;
  final String phone;
  final String code;
  final String botName;
  final String? telegramHandle;
  final TelegramVerificationState state;
  final DateTime createdAt;
  final DateTime lastSentAt;
  final DateTime expiresAt;
  final int resendCount;
  final int maxResend;
  final int remainingAttempts;
  final int maxAttempts;
  final String deliveryMessage;

  const OtpSession({
    required this.id,
    required this.phone,
    required this.code,
    required this.botName,
    required this.telegramHandle,
    required this.state,
    required this.createdAt,
    required this.lastSentAt,
    required this.expiresAt,
    required this.resendCount,
    required this.maxResend,
    required this.remainingAttempts,
    required this.maxAttempts,
    required this.deliveryMessage,
  });

  OtpSession copyWith({
    String? id,
    String? phone,
    String? code,
    String? botName,
    String? telegramHandle,
    TelegramVerificationState? state,
    DateTime? createdAt,
    DateTime? lastSentAt,
    DateTime? expiresAt,
    int? resendCount,
    int? maxResend,
    int? remainingAttempts,
    int? maxAttempts,
    String? deliveryMessage,
  }) {
    return OtpSession(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      code: code ?? this.code,
      botName: botName ?? this.botName,
      telegramHandle: telegramHandle ?? this.telegramHandle,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
      lastSentAt: lastSentAt ?? this.lastSentAt,
      expiresAt: expiresAt ?? this.expiresAt,
      resendCount: resendCount ?? this.resendCount,
      maxResend: maxResend ?? this.maxResend,
      remainingAttempts: remainingAttempts ?? this.remainingAttempts,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      deliveryMessage: deliveryMessage ?? this.deliveryMessage,
    );
  }
}

class OtpRequestResult {
  final bool linked;
  final OtpSession? session;
  final String? telegramHandle;
  final String message;

  const OtpRequestResult({
    required this.linked,
    required this.session,
    required this.telegramHandle,
    required this.message,
  });
}

class OtpVerificationResult {
  final bool success;
  final OtpSession? session;
  final String message;

  const OtpVerificationResult({
    required this.success,
    required this.session,
    required this.message,
  });
}
