import 'package:client_models/client_models.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/fixtures/data/fixture_display_helpers.dart';
import 'package:dupra/presentation/fixtures/widgets/fixture_meta_badge_row.dart';
import 'package:dupra/presentation/fixtures/widgets/fixture_opposition_captain_block.dart';
import 'package:dupra/presentation/widgets/dupra_accent_section_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Fixture card: ladder-style accent header with match title; details below.
class DupraLeagueFixtureCard extends StatelessWidget {
  const DupraLeagueFixtureCard({required this.fixture, super.key});

  final LeagueFixtureDto fixture;

  static final _dateFormat = DateFormat('EEEE, d MMMM y');

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final isHome = isVobHomeFixture(fixture);
    final cap = fixture.clubCaptain;
    final venue = !isHome ? 'Playing at: ${displayVenueForFixture(fixture)}' : '';
    final dateLabel = _dateFormat.format(fixture.fixtureDate);
    final matchTitle = '${fixture.homeTeam} vs ${fixture.awayTeam}';
    final accent = accentStripeColorForFixture(fixture);

    return DupraAccentSectionCard(
      accentColor: accent,
      headerTitle: matchTitle,
      headerTrailing: Text(
        dateLabel,
        textAlign: TextAlign.right,
        style: textTheme.titleSmall?.copyWith(
          color: DupraColors.textSecondary,
          fontWeight: FontWeight.w600,
          height: 1.25,
        ),
        maxLines: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FixtureMetaBadgeRow(fixture: fixture),
            const SizedBox(height: 12),
            if (!isHome) ...[
              Text(venue, style: textTheme.bodyLarge?.copyWith(height: 1.35)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Divider(height: 1, color: scheme.tertiary.withValues(alpha: 0.45)),
              ),
            ],
            FixtureOppositionCaptainBlock(
              captainName: cap?.captainName,
              phone: cap?.captainContactNo,
              scheme: scheme,
              textTheme: textTheme,
            ),
          ],
        ),
      ),
    );
  }
}
