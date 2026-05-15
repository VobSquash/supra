import 'package:flutter/material.dart';

class UsersDirectorySearchBar extends StatelessWidget {
  const UsersDirectorySearchBar({
    required this.controller,
    required this.searchQueryNotEmpty,
    required this.onChanged,
    required this.onClear,
    required this.hintText,
    super.key,
  });

  final TextEditingController controller;
  final bool searchQueryNotEmpty;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchQueryNotEmpty
            ? IconButton(tooltip: 'Clear', icon: const Icon(Icons.clear), onPressed: onClear)
            : null,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: onChanged,
    );
  }
}
