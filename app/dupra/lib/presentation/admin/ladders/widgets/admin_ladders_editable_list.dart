part of '../../admin_ladders_placeholder_page.dart';

class _EditableLadderList extends StatelessWidget {
  const _EditableLadderList({
    required this.items,
    required this.onChanged,
    required this.onRemove,
  });

  final List<LadderItemDTO> items;
  final ValueChanged<List<LadderItemDTO>> onChanged;
  final ValueChanged<LadderItemDTO> onRemove;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No ladder entries yet.'));
    }
    return ReorderableListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
      itemCount: items.length,
      onReorder: (oldIndex, newIndex) {
        final mutable = List<LadderItemDTO>.of(items);
        if (newIndex > oldIndex) newIndex -= 1;
        final moved = mutable.removeAt(oldIndex);
        mutable.insert(newIndex, moved);
        final normalized = <LadderItemDTO>[];
        for (var i = 0; i < mutable.length; i++) {
          normalized.add(mutable[i].copyWith(order: i + 1));
        }
        onChanged(normalized);
      },
      itemBuilder: (context, index) {
        final item = items[index];
        final title = item.profile?.displayName.trim();
        final name = (title != null && title.isNotEmpty) ? title : '(No name)';
        return Card(
          key: ValueKey('${item.vobGuid ?? 'unknown'}-$index'),
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(name),
            subtitle: Text('Team ${item.team ?? '-'}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Remove from ladder',
                  icon: const Icon(Icons.person_remove_alt_1_outlined),
                  onPressed: () => onRemove(item),
                ),
                const Icon(Icons.drag_indicator_rounded),
              ],
            ),
          ),
        );
      },
    );
  }
}
