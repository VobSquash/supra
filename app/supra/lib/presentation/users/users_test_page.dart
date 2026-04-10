import 'package:app_bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../engine/route.dart';

class UsersTestPage extends StatefulWidget {
  const UsersTestPage({super.key});

  @override
  State<UsersTestPage> createState() => _UsersTestPageState();
}

class _UsersTestPageState extends State<UsersTestPage> {
  @override
  void initState() {
    super.initState();
    context.read<UsersBloc>().add(const UsersEvent.onLoadActiveProfiles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active profiles')),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          final status = state.status.status;
          final message = state.status.message?.trim();

          if (status == BaseLoadingStatus.loading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (status == BaseLoadingStatus.loadingFailed) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  message?.isNotEmpty == true
                      ? message!
                      : 'Failed to load profiles',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state.profiles.isEmpty) {
            return const Center(child: Text('No active profiles found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.profiles.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final p = state.profiles[index];
              return ListTile(
                title: Text(
                  p.displayName.trim().isEmpty ? '(no name)' : p.displayName,
                ),
                subtitle: Text(
                  (p.email ?? '').isEmpty ? '(no email)' : p.email!,
                ),
                trailing: Text(p.isActive == true ? 'active' : 'inactive'),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    RouteNames.profileDetails,
                    arguments: p,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
