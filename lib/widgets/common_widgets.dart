import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import '../brand/app_brand.dart';
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
        AppBrand.iconAsset,
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

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({
    super.key,
    this.color,
    this.markSize = 28,
    this.fontSize = 20,
    this.showMark = true,
  });

  final Color? color;
  final double markSize;
  final double fontSize;
  final bool showMark;

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? AppColors.ink;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showMark) ...[
          BrandMark(size: markSize, showShadow: false),
          SizedBox(width: markSize * 0.32),
        ],
        Text(
          AppBrand.name,
          style: GoogleFonts.manrope(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: textColor,
            height: 1,
          ),
        ),
      ],
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
                  : AppColors.accent.withValues(alpha: 0.10),
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

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return SoftPanel(
      elevated: false,
      color: AppColors.creamSoft,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.soft.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.deep, size: 30),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, height: 1.45),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 14),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

class PracticeIconBadge extends StatelessWidget {
  const PracticeIconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 48,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.18),
            AppColors.accentSoft.withValues(alpha: 0.55),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Icon(icon, color: color, size: size * 0.46),
    );
  }
}

class WeekSparkline extends StatelessWidget {
  const WeekSparkline({super.key, required this.levels});

  /// 7 nilai 1–5 atau null.
  final List<int?> levels;

  @override
  Widget build(BuildContext context) {
    const labels = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];
    final today = DateTime.now();
    final dayLabels = List.generate(7, (i) {
      final d = today.subtract(Duration(days: 6 - i));
      // Senin=1 … Minggu=7 → ringkas inisial ID
      const id = ['', 'S', 'S', 'R', 'K', 'J', 'S', 'M'];
      return id[d.weekday];
    });

    return SoftPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Check-in 7 hari',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            'Semakin tinggi batang, semakin cemas di hari itu.',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 96,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(levels.length, (i) {
                final level = levels[i];
                final has = level != null;
                final h = has ? (level.clamp(1, 5) / 5) * 72.0 : 8.0;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          height: h,
                          decoration: BoxDecoration(
                            color: has
                                ? Color.lerp(
                                    AppColors.low,
                                    AppColors.high,
                                    (level - 1) / 4,
                                  )
                                : AppColors.soft,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dayLabels.length == 7 ? dayLabels[i] : labels[i],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: i == 6 ? AppColors.deep : AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class StreakCalendarStrip extends StatelessWidget {
  const StreakCalendarStrip({
    super.key,
    required this.activeDays,
    this.days = 14,
  });

  final Set<DateTime> activeDays;
  final int days;

  @override
  Widget build(BuildContext context) {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    return SoftPanel(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jejak aktivitas',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(days, (i) {
              final day = today.subtract(Duration(days: days - 1 - i));
              final active = activeDays.contains(day);
              final isToday = day == today;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.seed
                            : AppColors.soft.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                        border: isToday
                            ? Border.all(color: AppColors.accent, width: 2)
                            : null,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          const Text(
            'Kotak hijau = ada aktivitas. Bingkai oranye = hari ini.',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
