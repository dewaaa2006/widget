import '../models/payment_simulation.dart';

class TelegramOtpService {
  static const String botName = '@UltraXAuthBot';
  static const Duration otpValidity = Duration(seconds: 60);
  static const Duration resendCooldown = Duration(seconds: 25);

  static final Map<String, String> _linkedHandles = <String, String>{
    '081234567890': '@alyarahma_demo',
    '08123456789': '@ultrax_6789',
    '08987654321': '@ultrax_4321',
  };

  static final Map<String, OtpSession> _sessions = <String, OtpSession>{};
  static final Map<String, String> _phoneToSession = <String, String>{};

  static bool isTelegramLinked(String phone) {
    return _linkedHandles.containsKey(_normalize(phone));
  }

  static String? linkedHandleForPhone(String phone) {
    return _linkedHandles[_normalize(phone)];
  }

  static String connectDemoTelegram(String phone) {
    final normalized = _normalize(phone);
    final suffix = normalized.length > 4
        ? normalized.substring(normalized.length - 4)
        : normalized;
    final handle = '@ultrax_$suffix';
    _linkedHandles[normalized] = handle;
    return handle;
  }

  static OtpRequestResult requestOtp({
    required String phone,
    bool autoLinkIfNeeded = false,
  }) {
    final normalized = _normalize(phone);
    var handle = _linkedHandles[normalized];

    if (handle == null && autoLinkIfNeeded) {
      handle = connectDemoTelegram(normalized);
    }

    if (handle == null) {
      return const OtpRequestResult(
        linked: false,
        session: null,
        telegramHandle: null,
        message:
            'Nomor ini belum terhubung ke Telegram demo. Hubungkan dulu untuk menerima OTP dari bot resmi Ultra.X.',
      );
    }

    final now = DateTime.now();
    final code = _generateCode(normalized, 0);
    final session = OtpSession(
      id: 'otp-${now.millisecondsSinceEpoch}',
      phone: normalized,
      code: code,
      botName: botName,
      telegramHandle: handle,
      state: TelegramVerificationState.delivered,
      createdAt: now,
      lastSentAt: now,
      expiresAt: now.add(otpValidity),
      resendCount: 0,
      maxResend: 3,
      remainingAttempts: 5,
      maxAttempts: 5,
      deliveryMessage:
          'Kode verifikasi Ultra.X kamu adalah $code. Berlaku 60 detik. Jangan bagikan kode ini.',
    );
    _sessions[session.id] = session;
    _phoneToSession[normalized] = session.id;

    return OtpRequestResult(
      linked: true,
      session: session,
      telegramHandle: handle,
      message: 'OTP demo berhasil dikirim ke bot Telegram $handle melalui $botName.',
    );
  }

  static OtpSession? getSession(String? sessionId, {String? phone}) {
    if (sessionId != null && _sessions.containsKey(sessionId)) {
      return _sessions[sessionId];
    }
    if (phone != null) {
      final normalized = _normalize(phone);
      final mapped = _phoneToSession[normalized];
      if (mapped != null) return _sessions[mapped];
    }
    return null;
  }

  static OtpRequestResult resendOtp(String sessionId) {
    final session = _sessions[sessionId];
    if (session == null) {
      return const OtpRequestResult(
        linked: false,
        session: null,
        telegramHandle: null,
        message: 'Sesi OTP tidak ditemukan. Minta kode baru untuk melanjutkan.',
      );
    }

    final now = DateTime.now();
    if (session.state == TelegramVerificationState.blocked) {
      return OtpRequestResult(
        linked: true,
        session: session,
        telegramHandle: session.telegramHandle,
        message:
            'Sesi OTP diblokir karena terlalu banyak percobaan. Mulai ulang proses login atau daftar.',
      );
    }
    if (session.resendCount >= session.maxResend) {
      final blocked = session.copyWith(
        state: TelegramVerificationState.blocked,
      );
      _sessions[session.id] = blocked;
      return OtpRequestResult(
        linked: true,
        session: blocked,
        telegramHandle: blocked.telegramHandle,
        message: 'Batas kirim ulang OTP sudah habis untuk sesi ini.',
      );
    }
    if (now.isBefore(session.lastSentAt.add(resendCooldown))) {
      return OtpRequestResult(
        linked: true,
        session: session,
        telegramHandle: session.telegramHandle,
        message: 'Tunggu beberapa detik sebelum meminta OTP lagi.',
      );
    }

    final resentCount = session.resendCount + 1;
    final code = _generateCode(session.phone, resentCount);
    final updated = session.copyWith(
      code: code,
      state: TelegramVerificationState.delivered,
      lastSentAt: now,
      expiresAt: now.add(otpValidity),
      resendCount: resentCount,
      remainingAttempts: session.maxAttempts,
      deliveryMessage:
          'Kode verifikasi Ultra.X kamu adalah $code. Berlaku 60 detik. Jangan bagikan kode ini.',
    );
    _sessions[updated.id] = updated;

    return OtpRequestResult(
      linked: true,
      session: updated,
      telegramHandle: updated.telegramHandle,
      message: 'OTP baru sudah dikirim ke ${updated.telegramHandle}.',
    );
  }

  static OtpVerificationResult verifyOtp({
    required String sessionId,
    required String code,
  }) {
    final session = _sessions[sessionId];
    if (session == null) {
      return const OtpVerificationResult(
        success: false,
        session: null,
        message: 'Sesi OTP tidak ditemukan.',
      );
    }

    final now = DateTime.now();
    if (now.isAfter(session.expiresAt)) {
      final expired = session.copyWith(state: TelegramVerificationState.expired);
      _sessions[session.id] = expired;
      return OtpVerificationResult(
        success: false,
        session: expired,
        message: 'Kode OTP sudah kedaluwarsa. Silakan kirim ulang.',
      );
    }

    if (session.state == TelegramVerificationState.blocked) {
      return OtpVerificationResult(
        success: false,
        session: session,
        message: 'Terlalu banyak percobaan. Mulai ulang proses verifikasi.',
      );
    }

    if (session.code == code) {
      final verified = session.copyWith(
        state: TelegramVerificationState.verified,
      );
      _sessions[session.id] = verified;
      return OtpVerificationResult(
        success: true,
        session: verified,
        message: 'OTP berhasil diverifikasi. Selamat datang di Ultra.X.',
      );
    }

    final remaining = session.remainingAttempts - 1;
    final updated = session.copyWith(
      remainingAttempts: remaining,
      state: remaining <= 0
          ? TelegramVerificationState.blocked
          : TelegramVerificationState.delivered,
    );
    _sessions[session.id] = updated;
    return OtpVerificationResult(
      success: false,
      session: updated,
      message: remaining <= 0
          ? 'Percobaan OTP habis. Minta kode baru untuk melanjutkan.'
          : 'Kode OTP tidak cocok. Sisa percobaan: $remaining.',
    );
  }

  static int secondsUntilResend(OtpSession session) {
    final remaining =
        session.lastSentAt.add(resendCooldown).difference(DateTime.now()).inSeconds;
    return remaining < 0 ? 0 : remaining;
  }

  static int secondsUntilExpiry(OtpSession session) {
    final remaining = session.expiresAt.difference(DateTime.now()).inSeconds;
    return remaining < 0 ? 0 : remaining;
  }

  static String _normalize(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9]'), '');
  }

  static String _generateCode(String phone, int iteration) {
    final seed = phone.codeUnits.fold<int>(0, (sum, value) => sum + value);
    final generated = (seed * 91 + (iteration * 137) + 483920) % 900000;
    return (generated + 100000).toString();
  }
}
