import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../models/models.dart';
import '../widgets/custom_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final User dummyUser = User(
    id: '1',
    name: 'Budi Santoso',
    email: 'budi@example.com',
    phone: '08123456789',
    avatar: '👤',
    balance: 250000,
    loyaltyLevel: 3,
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
  );

  final List<Promo> promos = [
    Promo(
      id: '1',
      title: 'Diskon Pulsa Telkomsel',
      description: 'Dapatkan diskon hingga 20%',
      imageUrl: '',
      discountPercent: 20,
      validUntil: DateTime.now().add(const Duration(days: 7)),
      code: 'TSEL20',
    ),
    Promo(
      id: '2',
      title: 'Bonus Data XL Axiata',
      description: '5GB ekstra untuk paket bulanan',
      imageUrl: '',
      discountPercent: 15,
      validUntil: DateTime.now().add(const Duration(days: 5)),
    ),
    Promo(
      id: '3',
      title: 'Flash Sale Indosat',
      description: 'Penawaran terbatas setiap jam 12 siang',
      imageUrl: '',
      discountPercent: 25,
      validUntil: DateTime.now().add(const Duration(days: 3)),
    ),
  ];

  final List<Transaction> recentTransactions = [
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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FadeTransition(
                      opacity: Tween<double>(begin: 0, end: 1).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: const Interval(0, 0.5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Pagi,',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dummyUser.name.split(' ').first,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pinned: true,
            expandedHeight: 100,
          ),
          // Hero balance card
          SliverToBoxAdapter(
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.1, 0.6),
                ),
              ),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.1, 0.6),
                  ),
                ),
                child: HeroBalanceCard(
                  balance: dummyUser.balance,
                  userName: dummyUser.name,
                  onTap: () {
                    Navigator.of(context).pushNamed('/topup');
                  },
                ),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: AppSpacing.lg)),
          // Quick actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Layanan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.2, 0.7),
                      ),
                    ),
                    child: GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: AppSpacing.sm,
                      mainAxisSpacing: AppSpacing.sm,
                      children: [
                        QuickActionButton(
                          label: 'Pulsa',
                          icon: Iconsax.mobile,
                          backgroundColor: Color(0xFFE3F2FD),
                          iconColor: AppColors.primary,
                          onTap: () {
                            Navigator.of(context).pushNamed('/pulsa');
                          },
                        ),
                        QuickActionButton(
                          label: 'Data',
                          icon: Iconsax.wifi,
                          backgroundColor: Color(0xFFE8F5E9),
                          iconColor: Color(0xFF2E7D32),
                          onTap: () {
                            Navigator.of(context).pushNamed('/data');
                          },
                        ),
                        QuickActionButton(
                          label: 'PLN',
                          icon: Iconsax.flash_1,
                          backgroundColor: Color(0xFFFFF3E0),
                          iconColor: AppColors.accentOrangeBright,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Fitur PLN segera hadir')),
                            );
                          },
                        ),
                        QuickActionButton(
                          label: 'Semua',
                          icon: Iconsax.menu,
                          backgroundColor: Color(0xFFF3E5F5),
                          iconColor: Color(0xFF7B1FA2),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Lihat semua layanan')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: AppSpacing.lg)),
          // Promo carousel
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Promo Spesial',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Lihat Semua',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: AppColors.primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: promos.length,
                    itemBuilder: (context, index) {
                      final promo = promos[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.md),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0.5, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                0.3 + (index * 0.08),
                                0.7 + (index * 0.08),
                              ),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 280,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.primary.withOpacity(0.9),
                                    AppColors.primaryGradient.withOpacity(0.9),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.lg),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.primary.withOpacity(0.2),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.sm,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                              AppRadius.sm),
                                        ),
                                        child: Text(
                                          'Diskon ${promo.discountPercent}%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      Text(
                                        promo.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    promo.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: AppSpacing.lg)),
          // Recent transactions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaksi Terbaru',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/history');
                        },
                        child: Text(
                          'Lihat Semua',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: AppColors.primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...List.generate(
                    recentTransactions.length,
                    (index) {
                      final transaction = recentTransactions[index];
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.3, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(
                              0.4 + (index * 0.1),
                              0.8 + (index * 0.1),
                            ),
                          ),
                        ),
                        child: Padding(
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
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.xl)),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // Stay on home
          } else if (index == 1) {
            Navigator.of(context).pushNamed('/history');
          } else if (index == 2) {
            Navigator.of(context).pushNamed('/profile');
          }
        },
      ),
    );
  }
}

// Transaction Card Widget
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

// Bottom Navigation Bar
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
                icon: Iconsax.clock,
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
