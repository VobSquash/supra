import 'package:app_bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationsTestPage extends StatefulWidget {
  const LocationsTestPage({super.key, this.nested = false});

  /// When true, omits outer [Scaffold]/[AppBar] so a parent shell can host this page.
  final bool nested;

  @override
  State<LocationsTestPage> createState() => _LocationsTestPageState();
}

class _LocationsTestPageState extends State<LocationsTestPage> {
  @override
  void initState() {
    super.initState();
    context.read<LocationsBloc>().add(const LocationsEvent.onLoadLocations());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationsBloc, LocationsState>(
      builder: (context, state) {
        final status = state.status.status;
        final message = state.status.message?.trim();

        Widget body;
        if (status == BaseLoadingStatus.loading) {
          body = const Center(child: CircularProgressIndicator.adaptive());
        } else if (status == BaseLoadingStatus.loadingFailed) {
          body = Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                message?.isNotEmpty == true
                    ? message!
                    : 'Failed to load locations',
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (state.locations.isEmpty) {
          body = const Center(child: Text('No locations found.'));
        } else {
          body = ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.locations.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final loc = state.locations[index];
              final title = (loc.name ?? '').trim().isEmpty
                  ? '(no name)'
                  : loc.name!;
              final subtitle = [
                if ((loc.vobGuid ?? '').trim().isNotEmpty) loc.vobGuid!,
                if ((loc.latitude ?? '').trim().isNotEmpty ||
                    (loc.longitude ?? '').trim().isNotEmpty)
                  '${loc.latitude ?? '—'}, ${loc.longitude ?? '—'}',
              ].join(' · ');
              return ListTile(
                title: Text(title),
                subtitle: Text(subtitle.isEmpty ? '(no details)' : subtitle),
              );
            },
          );
        }

        if (widget.nested) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.35),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    'Locations',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              Expanded(child: body),
            ],
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Locations')),
          body: body,
        );
      },
    );
  }
}
