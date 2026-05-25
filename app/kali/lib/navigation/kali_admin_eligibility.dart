import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';

/// Dupra [`MainShellPage._sessionAllowsAdminShell`] parity: **`profileTypeId`** on [SessionSnapshot].
bool kaliAuthIsAdminOrElevated(AuthState auth) {
  return auth.maybeWhen(
    authenticated: (snapshot) {
      final id = snapshot.profileTypeId;
      if (id == null) return false;
      return ProfileTypeEnum.get(id).isAdminOrElevated;
    },
    orElse: () => false,
  );
}

/// Routes / UI that require [**ProfileTypeEnum.isAdminOrElevated**].
const String kaliAdminBookingsPath = '/admin-bookings';
