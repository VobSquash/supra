part of '../users_page.dart';

class _UsersMembershipChipRow extends StatelessWidget {
  const _UsersMembershipChipRow({
    required this.selected,
    required this.onSelected,
  });

  final UsersMembershipFilter selected;
  final ValueChanged<UsersMembershipFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final f in UsersMembershipFilter.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(usersMembershipFilterLabel(f)),
                selected: selected == f,
                onSelected: (chosen) {
                  if (!chosen) return;
                  onSelected(f);
                },
              ),
            ),
        ],
      ),
    );
  }
}
