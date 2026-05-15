part of '../../admin_ladders_placeholder_page.dart';

class _SelectProfileDialog extends StatefulWidget {
  const _SelectProfileDialog({required this.profiles});

  final List<BasicProfileDTO> profiles;

  @override
  State<_SelectProfileDialog> createState() => _SelectProfileDialogState();
}

class _SelectProfileDialogState extends State<_SelectProfileDialog> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _search.text.trim().toLowerCase();
    final filtered = widget.profiles.where((p) {
      if (q.isEmpty) return true;
      final n = p.displayName.toLowerCase();
      final e = (p.email ?? '').toLowerCase();
      return n.contains(q) || e.contains(q);
    }).toList(growable: false);

    return AlertDialog(
      title: const Text('Add member to ladder'),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _search,
              decoration: const InputDecoration(
                hintText: 'Search member',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: filtered.isEmpty
                  ? const Center(child: Text('No matching members.'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final p = filtered[index];
                        return ListTile(
                          dense: true,
                          title: Text(p.displayName),
                          subtitle: Text((p.email ?? '').trim()),
                          onTap: () => Navigator.of(context).pop(p),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
