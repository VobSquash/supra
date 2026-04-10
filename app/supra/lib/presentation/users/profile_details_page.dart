import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';

import '../shared/widgets/row_item.dart';

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({super.key, required this.profile});

  final BasicProfileDTO profile;

  @override
  Widget build(BuildContext context) {
    final title = profile.displayName.trim().isEmpty
        ? 'Profile details'
        : profile.displayName;
    final extended = profile.extendedProfile;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RowItem(label: 'objectId', value: profile.objectId),
          RowItem(label: 'vobGuid', value: profile.vobGuid),
          RowItem(label: 'firstName', value: profile.firstName),
          RowItem(label: 'lastName', value: profile.lastName),
          RowItem(label: 'email', value: profile.email),
          RowItem(label: 'contactNumber', value: profile.contactNumber),
          RowItem(label: 'dateOfBirth', value: profile.dateOfBirth),
          RowItem(
            label: 'emergencyContactNumber',
            value: profile.emergencyContactNumber,
          ),
          RowItem(label: 'isActive', value: profile.isActive?.toString()),
          RowItem(label: 'profilePictureUrl', value: profile.profilePictureUrl),
          const SizedBox(height: 16),
          Text(
            'Extended profile',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (extended == null) ...[
            const Text('(none)'),
          ] else ...[
            RowItem(label: 'objectId', value: extended.objectId),
            RowItem(label: 'vobGuid', value: extended.vobGuid),
            RowItem(label: 'isCoach', value: extended.isCoach?.toString()),
            RowItem(
              label: 'canShowEmail',
              value: extended.canShowEmail?.toString(),
            ),
            RowItem(
              label: 'canShowContactNumber',
              value: extended.canShowContactNumber?.toString(),
            ),
            RowItem(
              label: 'canShowDateOfBirth',
              value: extended.canShowDateOfBirth?.toString(),
            ),
            RowItem(label: 'SSANumber', value: extended.SSANumber),
            RowItem(
              label: 'membershipType',
              value: extended.membershipType?.toString(),
            ),
            RowItem(
              label: 'emergencyContactNumber',
              value: extended.emergencyContactNumber,
            ),
          ],
        ],
      ),
    );
  }
}
