import 'package:dupra/presentation/widgets/dupra_avatar.dart';
import 'package:flutter/material.dart';

/// App-bar profile control: outer circular pad ([Material]) frames [DupraAvatar].
class ProfileAppBarAvatar extends StatelessWidget {
  const ProfileAppBarAvatar({
    required this.displayName,
    super.key,
    this.imageUrl,
    this.cacheKey,
    this.loading = false,
    this.onPressed,
  });

  /// Used for initials when [imageUrl] is absent or fails to load.
  final String displayName;
  final String? imageUrl;
  final String? cacheKey;
  final bool loading;
  final VoidCallback? onPressed;

  static const double _outerSize = 48;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

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
          child: Center(
            child: DupraAvatar(
              displayName: displayName,
              imageUrl: imageUrl,
              cacheKey: cacheKey,
              radius: 17,
              loading: loading,
            ),
          ),
        ),
      ),
    );
  }
}
