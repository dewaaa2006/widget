import 'package:flutter/material.dart';

import '../models/models.dart';
import 'theme.dart';

String formatCurrency(num amount) {
  final value = amount.round().toString();
  return 'Rp${value.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
}

String formatCompactDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

String getOperatorName(Operator operator) {
  switch (operator) {
    case Operator.telkomsel:
      return 'Telkomsel';
    case Operator.xl:
      return 'XL Axiata';
    case Operator.indosat:
      return 'Indosat';
    case Operator.tri:
      return 'Tri';
    case Operator.smartfren:
      return 'Smartfren';
  }
}

Color getOperatorColor(Operator operator) {
  switch (operator) {
    case Operator.telkomsel:
      return const Color(0xFFE53935);
    case Operator.xl:
      return const Color(0xFF1E88E5);
    case Operator.indosat:
      return const Color(0xFFF57C00);
    case Operator.tri:
      return const Color(0xFF7E57C2);
    case Operator.smartfren:
      return const Color(0xFFE91E63);
  }
}

Operator? detectOperator(String rawPhone) {
  final phone = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');
  if (phone.length < 4) return null;
  const telkomsel = ['0811', '0812', '0813', '0821', '0822', '0823', '0852', '0853', '0851'];
  const xl = ['0817', '0818', '0819', '0859', '0877', '0878'];
  const indosat = ['0814', '0815', '0816', '0855', '0856', '0857', '0858'];
  const tri = ['0895', '0896', '0897', '0898', '0899'];
  const smartfren = ['0881', '0882', '0883', '0884', '0885', '0886', '0887', '0888', '0889'];

  if (telkomsel.any(phone.startsWith)) return Operator.telkomsel;
  if (xl.any(phone.startsWith)) return Operator.xl;
  if (indosat.any(phone.startsWith)) return Operator.indosat;
  if (tri.any(phone.startsWith)) return Operator.tri;
  if (smartfren.any(phone.startsWith)) return Operator.smartfren;
  return null;
}

String getTransactionTypeLabel(TransactionType type) {
  switch (type) {
    case TransactionType.pulsa:
      return 'Pulsa';
    case TransactionType.data:
      return 'Paket Data';
    case TransactionType.topup:
      return 'Top Up Saldo';
    case TransactionType.electric:
      return 'Token Listrik';
    case TransactionType.voucher:
      return 'Pembayaran Digital';
  }
}

Color getStatusColor(TransactionStatus status) {
  switch (status) {
    case TransactionStatus.success:
      return AppColors.successGreen;
    case TransactionStatus.pending:
      return AppColors.warningYellow;
    case TransactionStatus.failed:
      return AppColors.errorRed;
    case TransactionStatus.processing:
      return AppColors.infoBlue;
  }
}
