part of '../users_page.dart';

class _UsersSearchBar extends StatelessWidget {
  const _UsersSearchBar({
    required this.controller,
    required this.searchQueryNotEmpty,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final bool searchQueryNotEmpty;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search name, email, phone…',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchQueryNotEmpty
            ? IconButton(
                tooltip: 'Clear',
                icon: const Icon(Icons.clear),
                onPressed: onClear,
              )
            : null,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: onChanged,
    );
  }
}
