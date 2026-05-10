import '../config/app_helpers.dart';
import '../models/models.dart';
import '../models/payment_simulation.dart';

class PaymentGatewayService {
  static PaymentIntent createIntent({
    required List<CartItem> items,
    required PaymentMethod method,
    required int subtotal,
    required int discount,
    required int adminFee,
    required int serviceFee,
    required int totalAmount,
    String? note,
  }) {
    final now = DateTime.now();
    final orderStamp = now.millisecondsSinceEpoch;
    final paymentReference = 'PAY-$orderStamp';
    final providerReference = '${_providerPrefix(method)}-$orderStamp';

    return PaymentIntent(
      id: 'pi-$orderStamp',
      orderId: 'ULX-$orderStamp',
      paymentReference: paymentReference,
      providerReference: providerReference,
      method: method,
      gatewayName: _gatewayName(method),
      status: method.type == PaymentMethodType.saldo
          ? PaymentIntentStatus.paid
          : PaymentIntentStatus.awaitingAction,
      items: items
          .map(
            (item) => PaymentIntentItemSummary(
              id: item.id,
              label: item.displayName,
              target: item.targetNumber,
              type: item.type,
              amount: item.price,
            ),
          )
          .toList(),
      subtotal: subtotal,
      discount: discount,
      adminFee: adminFee,
      serviceFee: serviceFee,
      totalAmount: totalAmount,
      createdAt: now,
      expiresAt: now.add(const Duration(minutes: 15)),
      vaNumber: method.type == PaymentMethodType.virtualAccount
          ? _buildVirtualAccount(method, orderStamp)
          : null,
      qrisPayload: method.type == PaymentMethodType.qris
          ? '00020101021226670016COM.ULTRAX.WALLET011893600915327${orderStamp}5204549953033605802ID5910Ultra.X6007Jakarta61051234562070703A016304$orderStamp'
          : null,
      deepLinkUrl: method.type == PaymentMethodType.eWallet
          ? 'ultrax://wallet-redirect/$paymentReference'
          : null,
      note: note,
    );
  }

  static PaymentIntent markActionSubmitted(PaymentIntent intent) {
    return intent.copyWith(status: PaymentIntentStatus.pending);
  }

  static PaymentGatewayResult finalizeIntent(PaymentIntent intent) {
    final resolvedIntent = _resolveIntentStatus(intent);
    final transactions = _buildTransactions(resolvedIntent);
    return PaymentGatewayResult(
      intent: resolvedIntent,
      transactions: transactions,
      message: _resultMessage(resolvedIntent.status),
    );
  }

  static PaymentIntent markExpired(PaymentIntent intent) {
    return intent.copyWith(status: PaymentIntentStatus.expired);
  }

  static PaymentIntent cancelIntent(PaymentIntent intent) {
    return intent.copyWith(status: PaymentIntentStatus.cancelled);
  }

  static List<String> processingStepsFor(PaymentIntent intent) {
    final methodLabel = switch (intent.method.type) {
      PaymentMethodType.qris => 'Menunggu scan QRIS',
      PaymentMethodType.virtualAccount => 'Menunggu pembayaran VA',
      PaymentMethodType.eWallet => 'Menunggu callback e-wallet',
      PaymentMethodType.saldo => 'Memotong saldo Ultra.X',
      PaymentMethodType.card => 'Memverifikasi kartu',
    };

    return [
      methodLabel,
      'Memverifikasi pembayaran',
      'Menghubungi provider produk',
      'Menyelesaikan settlement pesanan',
    ];
  }

  static PaymentIntent _resolveIntentStatus(PaymentIntent intent) {
    if (intent.method.type == PaymentMethodType.virtualAccount &&
        intent.items.length > 1) {
      return intent.copyWith(status: PaymentIntentStatus.partialSuccess);
    }
    if (intent.method.type == PaymentMethodType.eWallet &&
        intent.totalAmount >= 250000) {
      return intent.copyWith(status: PaymentIntentStatus.partialSuccess);
    }
    if (intent.method.type == PaymentMethodType.qris &&
        intent.totalAmount >= 300000) {
      return intent.copyWith(status: PaymentIntentStatus.pending);
    }
    return intent.copyWith(status: PaymentIntentStatus.settled);
  }

  static List<Transaction> _buildTransactions(PaymentIntent intent) {
    final List<Transaction> transactions = <Transaction>[];
    for (var index = 0; index < intent.items.length; index++) {
      final item = intent.items[index];
      final status = _transactionStatusFor(intent, index);
      transactions.add(
        Transaction(
          id: 'TRX-${intent.orderId}-$index',
          type: item.type,
          title: getTransactionTypeLabel(item.type),
          description: item.label,
          targetNumber: item.target,
          amount: item.amount,
          totalPrice: item.amount + intent.adminFee + intent.serviceFee,
          adminFee: intent.adminFee,
          discount: intent.discount > 0
              ? (intent.discount / intent.items.length).round()
              : 0,
          status: status,
          paymentMethod: intent.method.type,
          createdAt: intent.createdAt,
          completedAt: status == TransactionStatus.processing
              ? null
              : DateTime.now(),
          referenceNumber: intent.orderId,
          paymentReference: intent.paymentReference,
          providerReference: intent.providerReference,
          paymentExpiresAt: intent.expiresAt,
          gatewayName: intent.gatewayName,
          gatewayStatus: intent.status.name,
          serviceFee: intent.serviceFee,
          note: intent.note,
        ),
      );
    }
    return transactions;
  }

  static TransactionStatus _transactionStatusFor(
    PaymentIntent intent,
    int index,
  ) {
    switch (intent.status) {
      case PaymentIntentStatus.pending:
        return TransactionStatus.pending;
      case PaymentIntentStatus.partialSuccess:
        if (intent.method.type == PaymentMethodType.eWallet &&
            index == intent.items.length - 1) {
          return TransactionStatus.failed;
        }
        if (intent.method.type == PaymentMethodType.virtualAccount &&
            index == intent.items.length - 1) {
          return TransactionStatus.pending;
        }
        return TransactionStatus.success;
      case PaymentIntentStatus.failed:
      case PaymentIntentStatus.cancelled:
      case PaymentIntentStatus.expired:
        return TransactionStatus.failed;
      case PaymentIntentStatus.created:
      case PaymentIntentStatus.awaitingAction:
      case PaymentIntentStatus.paid:
      case PaymentIntentStatus.settled:
        return TransactionStatus.success;
    }
  }

  static String _gatewayName(PaymentMethod method) {
    switch (method.type) {
      case PaymentMethodType.saldo:
        return 'Ultra.X Balance Gateway';
      case PaymentMethodType.virtualAccount:
        return '${method.bankName ?? 'Bank'} Virtual Account';
      case PaymentMethodType.eWallet:
        return '${method.bankName ?? method.displayName} Redirect Gateway';
      case PaymentMethodType.qris:
        return 'QRIS National Sandbox';
      case PaymentMethodType.card:
        return 'Card Payment Sandbox';
    }
  }

  static String _providerPrefix(PaymentMethod method) {
    switch (method.type) {
      case PaymentMethodType.saldo:
        return 'SALDO';
      case PaymentMethodType.virtualAccount:
        return 'VA';
      case PaymentMethodType.eWallet:
        return 'EW';
      case PaymentMethodType.qris:
        return 'QRIS';
      case PaymentMethodType.card:
        return 'CARD';
    }
  }

  static String _buildVirtualAccount(PaymentMethod method, int stamp) {
    final bankSeed = switch ((method.bankName ?? '').toUpperCase()) {
      'BCA' => '3901',
      'MANDIRI' => '8808',
      _ => '7007',
    };
    final suffix = stamp.toString().padLeft(10, '0');
    return '$bankSeed${suffix.substring(suffix.length - 10)}';
  }

  static String _resultMessage(PaymentIntentStatus status) {
    switch (status) {
      case PaymentIntentStatus.settled:
        return 'Pembayaran sudah settle dan semua item berhasil diproses.';
      case PaymentIntentStatus.partialSuccess:
        return 'Pembayaran berhasil, tetapi beberapa item masih pending atau gagal.';
      case PaymentIntentStatus.pending:
        return 'Pembayaran diterima dan transaksi sedang menunggu konfirmasi provider.';
      case PaymentIntentStatus.expired:
        return 'Pembayaran melewati batas waktu dan perlu dibuat ulang.';
      case PaymentIntentStatus.failed:
        return 'Pembayaran gagal diproses oleh sandbox gateway.';
      case PaymentIntentStatus.cancelled:
        return 'Pembayaran dibatalkan sebelum settlement.';
      case PaymentIntentStatus.created:
      case PaymentIntentStatus.awaitingAction:
      case PaymentIntentStatus.paid:
        return 'Pembayaran sedang diproses.';
    }
  }
}
