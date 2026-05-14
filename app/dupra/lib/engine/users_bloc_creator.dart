import 'package:app_bloc/app_bloc.dart';

/// Builds a registered [UsersBloc] from the dependency graph configured by middleware + app bloc.
///
/// `DupraRoot` keeps one instance (`BlocProvider.value`) so shells share roster + current-profile
/// cache. Prefer this getter-style factory over scattering `GetIt` calls.
UsersBloc createUsersBloc() => appBlocSl<UsersBloc>();
