import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../models/models.dart';
import '../widgets/custom_widgets.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedStatus = 'all';

  final List<Transaction> _allTransactions = [
    Transaction(
      id: 'TRX001',
      type: TransactionType.pulsa,
      title: 'Top Up Pulsa',
      description: 'Telkomsel',
      targetNumber: '08123456789',
      operatorName: 'Telkomsel',
      amount: 100000,
      totalPrice: 100000,
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
      status: TransactionStatus.success,
      paymentMethod: PaymentMethodType.virtualAccount,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      completedAt: DateTime.now().subtract(const Duration(hours: 5)),
      referenceNumber: 'REF20240505002',
    ),
    Transaction(
      id: 'TRX003',
      type: TransactionType.topup,
      title: 'Top Up Saldo',
      description: 'Virtual Account',
      targetNumber: '08123456789',
      amount: 500000,
      totalPrice: 500000,
      status: TransactionStatus.pending,
      paymentMethod: PaymentMethodType.virtualAccount,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      referenceNumber: 'REF20240505003',
    ),
    Transaction(
      id: 'TRX004',
      type: TransactionType.data,
      title: 'Paket Data',
      description: 'Indosat 15GB',
      targetNumber: '08567890123',
      operatorName: 'Indosat',
      amount: 79000,
      totalPrice: 79000,
      status: TransactionStatus.failed,
      paymentMethod: PaymentMethodType.saldo,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      referenceNumber: 'REF20240504001',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = _allTransactions.where((tx) {
      if (_selectedStatus == 'all') return true;
      return tx.status.toString().split('.').last == _selectedStatus;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status filter tabs
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Semua',
                      isSelected: _selectedStatus == 'all',
                      onTap: () {
                        setState(() {
                          _selectedStatus = 'all';
                        });
                      },
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _FilterChip(
                      label: 'Berhasil',
                      isSelected: _selectedStatus == 'success',
                      onTap: () {
                        setState(() {
                          _selectedStatus = 'success';
                        });
                      },
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _FilterChip(
                      label: 'Menunggu',
                      isSelected: _selectedStatus == 'pending',
                      onTap: () {
                        setState(() {
                          _selectedStatus = 'pending';
                        });
                      },
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _FilterChip(
                      label: 'Gagal',
                      isSelected: _selectedStatus == 'failed',
                      onTap: () {
                        setState(() {
                          _selectedStatus = 'failed';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Transaction list
            Expanded(
              child: filteredTransactions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.document_text,
                            size: 64,
                            color: AppColors.textSecondary.withOpacity(0.3),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Belum ada transaksi',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg),
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSpacing.md),
                          child: TransactionCard(
                            transaction: transaction,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/transaction-detail',
                                arguments: transaction,
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed('/profile');
          }
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionCard({
    Key? key,
    required this.transaction,
    required this.onTap,
  }) : super(key: key);

  Color getStatusColor() {
    switch (transaction.status) {
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

  IconData getTransactionIcon() {
    switch (transaction.type) {
      case TransactionType.pulsa:
        return Iconsax.mobile;
      case TransactionType.data:
        return Iconsax.wifi;
      case TransactionType.topup:
        return Iconsax.wallet_2;
      case TransactionType.electric:
        return Iconsax.flash_1;
      case TransactionType.voucher:
        return Iconsax.ticket;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PremiumCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: getStatusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(
                getTransactionIcon(),
                color: getStatusColor(),
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${transaction.description} • ${transaction.targetNumber}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '-Rp${transaction.totalPrice.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 4),
                StatusChip(
                  label: transaction.statusLabel,
                  backgroundColor: getStatusColor(),
                  textColor: getStatusColor(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.border.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Iconsax.home_1,
                label: 'Beranda',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Iconsax.history,
                label: 'Riwayat',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Iconsax.user,
                label: 'Profil',
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
