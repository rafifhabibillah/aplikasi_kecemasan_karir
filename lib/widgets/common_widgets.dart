import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    this.size = 72,
    this.showShadow = true,
  });

  final double size;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppColors.deep.withValues(alpha: 0.22),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/branding/app_icon.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.seed,
            alignment: Alignment.center,
            child: Icon(
              Icons.explore_rounded,
              color: Colors.white,
              size: size * 0.46,
            ),
          );
        },
      ),
    );
  }
}

class AtmosphereBackground extends StatelessWidget {
  const AtmosphereBackground({
    super.key,
    required this.child,
    this.variant = AtmosphereVariant.mist,
  });

  final Widget child;
  final AtmosphereVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = switch (variant) {
      AtmosphereVariant.mist => const [
          Color(0xFFF7FBFA),
          Color(0xFFE8F2EF),
          Color(0xFFD9EBE5),
        ],
      AtmosphereVariant.deep => const [
          Color(0xFF1A5C55),
          Color(0xFF0F3D39),
          Color(0xFF0A2C29),
        ],
    };

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -40,
            child: _GlowOrb(
              size: 220,
              color: variant == AtmosphereVariant.deep
                  ? Colors.white.withValues(alpha: 0.08)
                  : AppColors.seed.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -50,
            child: _GlowOrb(
              size: 180,
              color: variant == AtmosphereVariant.deep
                  ? AppColors.mid.withValues(alpha: 0.25)
                  : AppColors.mid.withValues(alpha: 0.12),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

enum AtmosphereVariant { mist, deep }

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.muted,
                        height: 1.4,
                      ),
                ),
              ],
            ],
          ),
        ),
        ?action,
      ],
    );
  }
}

class SoftPanel extends StatelessWidget {
  const SoftPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color = Colors.white,
    this.elevated = true,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final isWhite = color == Colors.white || color == AppColors.creamSoft;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isWhite
              ? Colors.white.withValues(alpha: 0.65)
              : Colors.white.withValues(alpha: 0.12),
        ),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: AppColors.deep.withValues(alpha: isWhite ? 0.06 : 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

class LevelBadge extends StatelessWidget {
  const LevelBadge({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}
