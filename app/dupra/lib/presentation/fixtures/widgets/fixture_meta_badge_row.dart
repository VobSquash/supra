import 'package:client_models/client_models.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/fixtures/data/fixture_display_helpers.dart';
import 'package:flutter/material.dart';

/// Home/Away and catering chips with fixed height so both blocks align visually.
class FixtureMetaBadgeRow extends StatelessWidget {
  const FixtureMetaBadgeRow({required this.fixture, super.key});

  final LeagueFixtureDto fixture;

  static const double rowHeight = 44;

  @override
  Widget build(BuildContext context) {
    final isHome = isVobHomeFixture(fixture);
    final catering = fixture.clubCaptain?.isCatering ?? false;

    return SizedBox(
      height: rowHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: _FixtureHomeAwayBadge(isHome: isHome),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: _FixtureCateringTag(isCatering: catering),
            ),
          ),
        ],
      ),
    );
  }
}

class _FixtureHomeAwayBadge extends StatelessWidget {
  const _FixtureHomeAwayBadge({required this.isHome, super.key});

  final bool isHome;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isHome ? DupraColors.secondary.withValues(alpha: 0.22) : DupraColors.tertiary.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isHome ? DupraColors.secondary : DupraColors.tertiary),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          isHome ? 'Home' : 'Away',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
      ),
    );
  }
}

class _FixtureCateringTag extends StatelessWidget {
  const _FixtureCateringTag({required this.isCatering, super.key});

  final bool isCatering;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    const icon = Icons.restaurant_outlined;
    final text = isCatering ? 'Catering' : 'No catering';
    final color = isCatering ? scheme.tertiary : DupraColors.warning;
    final backgroundColor = isCatering
        ? scheme.tertiary.withValues(alpha: 0.2)
        : DupraColors.warning.withValues(alpha: 0.1);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              text,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
