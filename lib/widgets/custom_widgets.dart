import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/constants.dart';

// Premium Hero Balance Card
class HeroBalanceCard extends StatefulWidget {
  final double balance;
  final String userName;
  final VoidCallback onTap;

  const HeroBalanceCard({
    Key? key,
    required this.balance,
    required this.userName,
    required this.onTap,
  }) : super(key: key);

  @override
  State<HeroBalanceCard> createState() => _HeroBalanceCardState();
}

class _HeroBalanceCardState extends State<HeroBalanceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryGradient,
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Floating blobs background - animated very slowly
            Positioned(
              right: -50,
              top: -50,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.2)
                    .animate(CurvedAnimation(
                      parent: _shimmerController,
                      curve: Curves.easeInOut,
                    )),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
            ),
            Positioned(
              left: -30,
              bottom: -30,
              child: ScaleTransition(
                scale: Tween<double>(begin: 1.2, end: 0.8)
                    .animate(CurvedAnimation(
                      parent: _shimmerController,
                      curve: Curves.easeInOut,
                    )),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top section: Logo + Card type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ultra.X',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Premium',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ],
                  ),
                  // Balance section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saldo Anda',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Rp${widget.balance.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                  // Bottom section: Card number + expire
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '•••• •••• •••• 2024',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: Colors.white.withOpacity(0.7),
                              letterSpacing: 2,
                            ),
                      ),
                      Text(
                        '12/26',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: Colors.white.withOpacity(0.7),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Quick Action Button
class QuickActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const QuickActionButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  State<QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<QuickActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.95).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? AppColors.surfaceLow,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: (widget.backgroundColor ?? AppColors.surfaceLow)
                        .withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                color: widget.iconColor ?? AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

// Premium Card
class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double elevation;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;

  const PremiumCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.elevation = 0,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceCard,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.lg),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
      ),
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}

// Status Badge/Chip
class StatusChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const StatusChip({
    Key? key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: backgroundColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

// Premium Button with Shadow & Animation
class PremiumButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double width;
  final double? height;
  final IconData? icon;

  const PremiumButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.width = double.infinity,
    this.height,
    this.icon,
  }) : super(key: key);

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 0.98).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      ),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: Container(
          width: widget.width,
          height: widget.height ?? 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.backgroundColor ?? AppColors.primary,
                (widget.backgroundColor ?? AppColors.primary).withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: [
              BoxShadow(
                color: (widget.backgroundColor ?? AppColors.primary)
                    .withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.foregroundColor ?? Colors.white,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: widget.foregroundColor ?? Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Text(
                          widget.label,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: widget.foregroundColor ?? Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// Shimmer Loading Skeleton
class ShimmerSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerSkeleton({
    Key? key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.surfaceLow,
                AppColors.surfaceHigh.withOpacity(0.5),
                AppColors.surfaceLow,
              ],
              stops: [
                _controller.value - 0.5,
                _controller.value,
                _controller.value + 0.5,
              ],
            ),
          ),
        );
      },
    );
  }
}

// Glass Morphism Container
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;
  final double opacity;
  final Color backgroundColor;
  final EdgeInsets padding;
  final BorderRadiusGeometry borderRadius;

  const GlassContainer({
    Key? key,
    required this.child,
    this.sigmaX = 10,
    this.sigmaY = 10,
    this.opacity = 0.1,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.lg)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(opacity),
        borderRadius: borderRadius,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: child,
    );
  }
}
