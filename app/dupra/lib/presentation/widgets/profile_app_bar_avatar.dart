import 'package:flutter/material.dart';

/// App-bar profile control: outer circular pad ([Material]) frames the inner avatar.
class ProfileAppBarAvatar extends StatelessWidget {
  const ProfileAppBarAvatar({
    required this.displayName,
    super.key,
    this.imageUrl,
    this.loading = false,
    this.onPressed,
  });

  final String displayName;
  final String? imageUrl;
  final bool loading;
  final VoidCallback? onPressed;

  static const double _outerSize = 48;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final Widget inner;
    if (loading) {
      inner = SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2, color: scheme.primary),
      );
    } else if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      inner = CircleAvatar(
        radius: 17,
        backgroundImage: NetworkImage(imageUrl!),
      );
    } else {
      inner = CircleAvatar(
        radius: 17,
        child: Text(
          displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }

    return Material(
      color: scheme.primary.withValues(alpha: 0.2),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: _outerSize,
          height: _outerSize,
          child: Center(child: inner),
        ),
      ),
    );
  }
}
