import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/widgets/dupra_accent_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Read-only list of configured fees from [SettingsBloc] ([SettingsDTO.fees]).
class AdminFeesPage extends StatefulWidget {
  const AdminFeesPage({super.key});

  @override
  State<AdminFeesPage> createState() => _AdminFeesPageState();
}

class _AdminFeesPageState extends State<AdminFeesPage> {
  final _feesEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const SettingsEvent.onLoadSettings());
  }

  @override
  void dispose() {
    _feesEmailController.dispose();
    super.dispose();
  }

  Future<void> _sendFeesEmail() async {
    final email = _feesEmailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a recipient email address')),
      );
      return;
    }

    final bloc = appBlocSl<EmailBloc>();
    bloc.add(EmailEvent.onSendFeesEmail(recipientEmail: email));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sending fees email…')),
    );
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<SettingsBloc>()..add(const SettingsEvent.onLoadSettings());
    try {
      await bloc.stream
          .timeout(const Duration(seconds: 45))
          .firstWhere(
            (s) =>
                s.status.status == BaseLoadingStatus.loadingSuccess ||
                s.status.status == BaseLoadingStatus.loadingFailed,
          );
    } on Exception {
      // Stop the indicator even if the request stalls.
    }
  }

  String _money(double v) {
    if (v == v.roundToDouble()) {
      return v.toStringAsFixed(0);
    }
    return v.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final variant = Theme.of(context).colorScheme.onSurfaceVariant;

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final status = state.status.status;
        final err = state.status.message?.trim();

        final items = state.settings.fees.items;
        late final FeesDTO computed;
        String? computeErr;
        if (!items.any((e) => e.feeType == 'SSA')) {
          computed = FeesDTO(items: [...items]);
          computeErr = 'No row with FeeType SSA — showing stored pro-rata only.';
        } else {
          computed = FeesService.calculateProRata(items);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Fees'),
            leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
          ),
          body: switch (status) {
            BaseLoadingStatus.loading ||
            BaseLoadingStatus.initial => const Center(child: CircularProgressIndicator.adaptive()),
            BaseLoadingStatus.loadingFailed => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  err != null && err.isNotEmpty ? err : 'Failed to load settings.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            _ => RefreshIndicator(
              onRefresh: _onRefresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + MediaQuery.paddingOf(context).bottom),
                    sliver: SliverList.list(
                      children: [
                        Text(
                          'Current fee schedule from the server (${SettingsTypeEnum.fees2026.friendlyName}).',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: variant),
                        ),
                        const SizedBox(height: 16),
                        if (items.isNotEmpty) ...[
                          Text(
                            computeErr ?? 'Pro‑rata recomputed with [FeesService] for month ${DateTime.now().month}.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: variant),
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (items.isEmpty)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'No fee rows were returned. If you expect fees here, check the Fees2026 setting in Supabase.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: variant),
                              ),
                            ),
                          )
                        else
                          DupraAccentSectionCard(
                            accentColor: DupraColors.secondary,
                            headerTitle: 'Fees (${items.length})',
                            headerIcon: Icons.payments_outlined,
                            body: Column(
                              children: [
                                for (var i = 0; i < computed.items.length; i++) ...[
                                  if (i > 0) const Divider(height: 1),
                                  _FeeRow(item: computed.items[i], money: _money),
                                ],
                              ],
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          'Fee amounts are read-only in the app. Changes are made in Supabase for now.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: variant),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Email fee schedule',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _feesEmailController,
                          decoration: const InputDecoration(
                            labelText: 'Recipient email',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: items.isEmpty ? null : _sendFeesEmail,
                          icon: const Icon(Icons.mail_outline_rounded),
                          label: const Text('Send current fees'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          },
        );
      },
    );
  }
}

class _FeeRow extends StatelessWidget {
  const _FeeRow({required this.item, required this.money});

  final FeesItemDTO item;
  final String Function(double) money;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pro = item.proRataCost;
    final discount = (pro ?? 0) - (item.cost + 300);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.feeType.isEmpty ? '(unnamed fee)' : item.feeType,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Discount: R ${money(discount.abs())}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pro rata: R ${pro == null ? '—' : money(pro)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text(
            'R ${money(item.cost + 300)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
