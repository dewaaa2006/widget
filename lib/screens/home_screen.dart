import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../config/app_helpers.dart';
import '../config/theme.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../widgets/custom_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _heroController;
  late final AnimationController _staggerController;
  bool _hideBalance = false;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  List<Transaction> get _recentTransactions =>
      TransactionRepository.transactions.take(4).toList();

  @override
  Widget build(BuildContext context) {
    final user = AppState.currentUser;
    final rewards = RewardRepository.reward;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            left: -140,
            top: -80,
            child: _GlowOrb(
              size: 280,
              colors: [
                AppColors.primary.withAlphaValue(0.15),
                AppColors.primaryGradient.withAlphaValue(0.05),
              ],
            ),
          ),
          Positioned(
            right: -100,
            top: 140,
            child: _GlowOrb(
              size: 220,
              colors: [
                AppColors.accentOrangeBright.withAlphaValue(0.10),
                Colors.white.withAlphaValue(0.01),
              ],
            ),
          ),
          RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              await Future<void>.delayed(const Duration(milliseconds: 800));
              if (mounted) setState(() {});
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  stretch: true,
                  expandedHeight: 120,
                  backgroundColor: AppColors.background.withAlphaValue(0.95),
                  flexibleSpace: FlexibleSpaceBar(
                    background: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primaryGradient,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: Text(
                                  user.avatar,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Selamat datang kembali',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                            _HeaderBadgeButton(
                              icon: Iconsax.notification,
                              badge: NotificationRepository.notifications
                                  .where((item) => item.unread)
                                  .length,
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/notifications',
                              ).then((_) => setState(() {})),
                            ),
                            const SizedBox(width: 10),
                            _HeaderBadgeButton(
                              icon: Iconsax.shopping_cart,
                              badge: CartRepository.itemCount,
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/cart',
                              ).then((_) => setState(() {})),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/search'),
                          child: GlassContainer(
                            opacity: 0.86,
                            borderRadius: BorderRadius.circular(24),
                            child: Row(
                              children: [
                                const Icon(
                                  Iconsax.search_normal,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Cari layanan, paket, voucher, transaksi',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                ),
                                const Icon(
                                  Iconsax.scan_barcode,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildHeroWallet(user),
                        const SizedBox(height: 18),
                        _AnimatedSection(
                          controller: _staggerController,
                          start: 0.05,
                          child: _ShortcutRow(
                            items: [
                              _ShortcutData(
                                label: 'Top Up',
                                icon: Iconsax.wallet_add,
                                color: const Color(0xFFD8EEFF),
                                onTap: () => Navigator.pushNamed(context, '/topup'),
                              ),
                              _ShortcutData(
                                label: 'Pulsa',
                                icon: Iconsax.mobile,
                                color: const Color(0xFFE8F4EC),
                                onTap: () => Navigator.pushNamed(context, '/pulsa'),
                              ),
                              _ShortcutData(
                                label: 'Data',
                                icon: Iconsax.wifi,
                                color: const Color(0xFFEFF0FF),
                                onTap: () => Navigator.pushNamed(context, '/data'),
                              ),
                              _ShortcutData(
                                label: 'PLN',
                                icon: Iconsax.flash_1,
                                color: const Color(0xFFFFF2E5),
                                onTap: () => Navigator.pushNamed(context, '/pln'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        _AnimatedSection(
                          controller: _staggerController,
                          start: 0.12,
                          child: _SectionShell(
                            title: 'Layanan Cepat',
                            actionLabel: 'Semua layanan',
                            onAction: () => Navigator.pushNamed(context, '/search'),
                            child: GridView.count(
                              crossAxisCount: 4,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 14,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              childAspectRatio: 0.86,
                              children: [
                                _QuickTile(
                                  label: 'Pulsa',
                                  icon: Iconsax.mobile,
                                  color: const Color(0xFFDBEDFF),
                                ),
                                _QuickTile(
                                  label: 'Data',
                                  icon: Iconsax.wifi,
                                  color: const Color(0xFFE6F6EA),
                                ),
                                _QuickTile(
                                  label: 'PLN',
                                  icon: Iconsax.flash_1,
                                  color: const Color(0xFFFFF0E1),
                                ),
                                _QuickTile(
                                  label: 'E-Wallet',
                                  icon: Iconsax.wallet_2,
                                  color: const Color(0xFFEAF0FE),
                                ),
                                _QuickTile(
                                  label: 'Voucher',
                                  icon: Iconsax.ticket_discount,
                                  color: const Color(0xFFFFF0F4),
                                ),
                                _QuickTile(
                                  label: 'Tagihan',
                                  icon: Iconsax.receipt_item,
                                  color: const Color(0xFFF0F4FF),
                                ),
                                _QuickTile(
                                  label: 'Favorit',
                                  icon: Iconsax.heart,
                                  color: const Color(0xFFF3F7EE),
                                  onTap: () => Navigator.pushNamed(context, '/favorites'),
                                ),
                                _QuickTile(
                                  label: 'Bantuan',
                                  icon: Iconsax.message_question,
                                  color: const Color(0xFFF8F2E9),
                                  onTap: () => Navigator.pushNamed(context, '/help'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        _AnimatedSection(
                          controller: _staggerController,
                          start: 0.20,
                          child: _SectionShell(
                            title: 'Promo Pilihan',
                            actionLabel: 'Promo center',
                            onAction: () => Navigator.pushNamed(context, '/promo'),
                            child: SizedBox(
                              height: 186,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final promo = PromoRepository.promos[index];
                                  return _PromoCard(promo: promo);
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 14),
                                itemCount: PromoRepository.promos.length,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        _AnimatedSection(
                          controller: _staggerController,
                          start: 0.28,
                          child: _SectionShell(
                            title: 'Lanjutkan dari Keranjang',
                            actionLabel: CartRepository.items.isEmpty
                                ? 'Belanja'
                                : 'Buka keranjang',
                            onAction: () => Navigator.pushNamed(
                              context,
                              CartRepository.items.isEmpty ? '/pulsa' : '/cart',
                            ),
                            child: CartRepository.items.isEmpty
                                ? _EmptyInlineCard(
                                    icon: Iconsax.shopping_cart,
                                    title: 'Keranjang masih kosong',
                                    subtitle:
                                        'Simpan beberapa transaksi dulu supaya checkout lebih cepat.',
                                  )
                                : Column(
                                    children: CartRepository.items.take(2).map((item) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: PremiumCard(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 48,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  color: AppColors.surfaceLow,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Icon(
                                                  item.type == TransactionType.data
                                                      ? Iconsax.wifi
                                                      : item.type ==
                                                              TransactionType.electric
                                                          ? Iconsax.flash_1
                                                          : item.type ==
                                                                  TransactionType.topup
                                                              ? Iconsax.wallet_add
                                                              : Iconsax.mobile,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.displayName,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      item.targetNumber,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                formatCurrency(item.price),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        _AnimatedSection(
                          controller: _staggerController,
                          start: 0.34,
                          child: Row(
                            children: [
                              Expanded(
                                child: PremiumCard(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ultra Points',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0, end: rewards.points.toDouble()),
                                        duration: const Duration(milliseconds: 1200),
                                        builder: (context, value, _) => Text(
                                          value.toInt().toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall
                                              ?.copyWith(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        rewards.description,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: PremiumCard(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Referral Aktif',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Ajak teman dan dapat cashback hingga Rp25.000.',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      const SizedBox(height: 14),
                                      InkWell(
                                        onTap: () => Navigator.pushNamed(context, '/referral'),
                                        child: Text(
                                          'Bagikan kode',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        _AnimatedSection(
                          controller: _staggerController,
                          start: 0.40,
                          child: _SectionShell(
                            title: 'Transaksi Terakhir',
                            actionLabel: 'Lihat semua',
                            onAction: () => Navigator.pushNamed(context, '/history'),
                            child: _recentTransactions.isEmpty
                                ? _EmptyInlineCard(
                                    icon: Iconsax.receipt_item,
                                    title: 'Belum ada transaksi',
                                    subtitle:
                                        'Transaksi kamu akan muncul di sini setelah checkout selesai.',
                                  )
                                : Column(
                                    children: _recentTransactions.map((transaction) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: TransactionListTile(
                                          transaction: transaction,
                                          onTap: () => Navigator.pushNamed(
                                            context,
                                            '/transaction-detail',
                                            arguments: transaction,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 130),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: UltraBottomNavBar(
        currentIndex: 0,
        onTap: (index) async {
          final routes = ['/home', '/promo', '/history', '/cart', '/profile'];
          if (index == 0) return;
          await Navigator.pushNamed(context, routes[index]);
          if (mounted) setState(() {});
        },
      ),
    );
  }

  Widget _buildHeroWallet(User user) {
    return AnimatedBuilder(
      animation: _heroController,
      builder: (context, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryGradient],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlphaValue(0.22),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -18 + (_heroController.value * 6),
                top: -20,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlphaValue(0.10),
                  ),
                ),
              ),
              Positioned(
                left: -30,
                bottom: -34 + (_heroController.value * 10),
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlphaValue(0.07),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GlassContainer(
                        opacity: 0.18,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        child: Text(
                          'Wallet Premium',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => setState(() => _hideBalance = !_hideBalance),
                        icon: Icon(
                          _hideBalance ? Iconsax.eye : Iconsax.eye_slash,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Saldo Ultra.X',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withAlphaValue(0.84),
                        ),
                  ),
                  const SizedBox(height: 8),
                  ShaderMask(
                    shaderCallback: (rect) => LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white.withAlphaValue(220),
                        Colors.white,
                      ],
                      stops: [
                        (_heroController.value - 0.2).clamp(0.0, 1.0),
                        _heroController.value.clamp(0.0, 1.0),
                        (_heroController.value + 0.2).clamp(0.0, 1.0),
                      ],
                    ).createShader(rect),
                    child: Text(
                      _hideBalance ? 'Rp•••••••' : formatCurrency(user.balance),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _HeroMetric(
                        label: 'Pengeluaran bulan ini',
                        value: formatCurrency(468000),
                      ),
                      const SizedBox(width: 14),
                      _HeroMetric(
                        label: 'Voucher aktif',
                        value: '${VoucherRepository.vouchers.length} voucher',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: colors),
        ),
      ),
    );
  }
}

class _HeaderBadgeButton extends StatelessWidget {
  const _HeaderBadgeButton({
    required this.icon,
    required this.badge,
    required this.onTap,
  });

  final IconData icon;
  final int badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withAlphaValue(0.82),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 22),
          ),
          if (badge > 0)
            Positioned(
              right: -2,
              top: -2,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1),
                duration: const Duration(milliseconds: 500),
                builder: (context, scale, child) => Transform.scale(
                  scale: scale,
                  child: child,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrangeBright,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge > 9 ? '9+' : '$badge',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AnimatedSection extends StatelessWidget {
  const _AnimatedSection({
    required this.controller,
    required this.start,
    required this.child,
  });

  final AnimationController controller;
  final double start;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(start, (start + 0.45).clamp(0.0, 1.0), curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.08), end: Offset.zero).animate(animation),
        child: child,
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassContainer(
        opacity: 0.16,
        borderRadius: BorderRadius.circular(18),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white.withAlphaValue(0.76),
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutData {
  const _ShortcutData({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

class _ShortcutRow extends StatelessWidget {
  const _ShortcutRow({required this.items});

  final List<_ShortcutData> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.map((item) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: QuickActionButton(
              label: item.label,
              icon: item.icon,
              backgroundColor: item.color,
              onTap: item.onTap,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({
    required this.title,
    required this.child,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            if (actionLabel != null)
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionLabel!,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (label == 'Pulsa') Navigator.pushNamed(context, '/pulsa');
            if (label == 'Data') Navigator.pushNamed(context, '/data');
            if (label == 'PLN') Navigator.pushNamed(context, '/pln');
            if (label == 'E-Wallet') Navigator.pushNamed(context, '/topup');
          },
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.promo});

  final Promo promo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: promo.gradient),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassContainer(
            opacity: 0.18,
            borderRadius: BorderRadius.circular(14),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              promo.discountLabel,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const Spacer(),
          Text(
            promo.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            promo.subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withAlphaValue(0.92),
                ),
          ),
          if (promo.code != null) ...[
            const SizedBox(height: 12),
            Text(
              'Kode: ${promo.code}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyInlineCard extends StatelessWidget {
  const _EmptyInlineCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
