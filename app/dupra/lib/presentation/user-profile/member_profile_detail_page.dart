import 'package:client_models/client_models.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/widgets/dupra_avatar.dart';
import 'package:dupra/presentation/widgets/dupra_contact_action_sheet.dart';
import 'package:dupra/presentation/widgets/dupra_contact_icon_row.dart';
import 'package:dupra/presentation/widgets/dupra_icon_row.dart';
import 'package:dupra/presentation/widgets/dupra_profile_hero_sliver.dart';
import 'package:dupra/presentation/widgets/dupra_section.dart';
import 'package:flutter/material.dart';

part 'widgets/member_profile_detail_scroll_body.dart';
part 'widgets/member_profile_header_avatar.dart';
part 'widgets/member_profile_section_rows.dart';

/// Read-only profile for a member; pass as GoRouter `extra` as BasicProfileDTO.
class MemberProfileDetailPage extends StatelessWidget {
  const MemberProfileDetailPage({required this.profile, super.key});

  static const double _headerExtent = 210;
  static const double _avatarRadius = 62;

  final BasicProfileDTO profile;

  String get _resolvedMembershipType {
    final n = profile.extendedProfile?.membershipType?.friendlyName.trim();
    return n?.isEmpty ?? true ? 'Member' : n!;
  }

  String get _resolvedDisplayName {
    final n = profile.displayName.trim();
    return n.isEmpty ? 'Member' : n;
  }

  String? _formattedDob() {
    final raw = profile.dateOfBirth?.trim();
    if (raw == null || raw.isEmpty) return null;
    try {
      final d = DateTime.parse(raw).toLocal();
      final y = d.year.toString().padLeft(4, '0');
      final m = d.month.toString().padLeft(2, '0');
      final day = d.day.toString().padLeft(2, '0');
      return '$y-$m-$day';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ext = profile.extendedProfile;

    final dobStr = _formattedDob();
    final showEmail = (ext?.canShowEmail ?? false) && (profile.email?.trim().isNotEmpty ?? false);
    final showPhone = (ext?.canShowContactNumber ?? false) && (profile.contactNumber?.trim().isNotEmpty ?? false);
    final showDob = (ext?.canShowDateOfBirth ?? false) && dobStr != null;

    final emergency = profile.emergencyContactNumber?.trim();
    final extEmergency = ext?.emergencyContactNumber?.trim();
    final emergencyLine = emergency != null && emergency.isNotEmpty
        ? emergency
        : (extEmergency != null && extEmergency.isNotEmpty)
        ? extEmergency
        : null;

    final contactRows = buildMemberProfileContactRows(
      context: context,
      scheme: scheme,
      textTheme: textTheme,
      showEmail: showEmail,
      email: profile.email?.trim(),
      showPhone: showPhone,
      phone: profile.contactNumber?.trim(),
      showDob: showDob,
      dob: dobStr,
      onOpenUri: dupraLaunchExternalUri,
      telDialString: dupraTelDialForDialer,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(_resolvedDisplayName, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              DupraProfileHeroSliver(
                expandedHeight: _headerExtent,
                avatar: _MemberProfileHeaderAvatar(
                  displayName: _resolvedDisplayName,
                  imageUrl: profile.profilePictureUrl,
                  radius: _avatarRadius,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
                sliver: SliverToBoxAdapter(
                  child: _MemberProfileDetailScrollBody(
                    resolvedMembershipType: _resolvedMembershipType,
                    textTheme: textTheme,
                    scheme: scheme,
                    emergencyLine: emergencyLine,
                    contactRows: contactRows,
                    onOpenEmergencyPressed: emergencyLine != null
                        ? () => showContactInfoBottomSheet(
                            context: context,
                            fieldTitle: 'Emergency contact',
                            actionValue: emergencyLine,
                            kind: DupraActiobSheetKind.phone,
                            launchUri: dupraLaunchExternalUri,
                            telDialString: dupraTelDialForDialer,
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
          // const _MemberProfileOverlayBackButton(),
        ],
      ),
    );
  }
}
