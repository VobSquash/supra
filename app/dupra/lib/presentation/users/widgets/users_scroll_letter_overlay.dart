part of '../users_page.dart';

/// Letter pill driven by scroll; ignores pointers so gestures reach the list.
class _UsersScrollLetterOverlay extends StatelessWidget {
  const _UsersScrollLetterOverlay({required this.listenable});

  final ValueListenable<String?> listenable;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ValueListenableBuilder<String?>(
      valueListenable: listenable,
      builder: (context, letter, _) {
        if (letter == null || letter.isEmpty) {
          return const SizedBox.shrink();
        }
        return IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.scrim.withValues(alpha: 0.44),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: scheme.outline.withValues(alpha: 0.22)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 24,
                  color: Colors.black.withValues(alpha: 0.35),
                ),
              ],
            ),
            child: Padding(
              padding: context.dupraScaledEdgeInsetsSymmetric(horizontal: 36, vertical: 28),
              child: Text(
                letter,
                textAlign: TextAlign.center,
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: context.dupraTextScaler.scale(64),
                  height: 1,
                  letterSpacing: -1,
                  color: scheme.onSurface.withValues(alpha: 0.9),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
