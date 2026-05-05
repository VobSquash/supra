part of 'bookings_page.dart';

class _BookingsScrollView extends StatelessWidget {
  const _BookingsScrollView({
    required this.layout,
    required this.onLayoutChanged,
    required this.bookings,
    required this.bottomPad,
  });

  final BookingsLayout layout;
  final ValueChanged<BookingsLayout> onLayoutChanged;
  final List<SampleBooking> bookings;
  final double bottomPad;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your bookings',
                  style: textTheme.headlineSmall?.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Switch layout — production will load from the same booking API.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                SegmentedButton<BookingsLayout>(
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: DupraColors.secondary.withValues(alpha: 0.22),
                    selectedForegroundColor: DupraColors.secondary,
                  ),
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: BookingsLayout.grid,
                      label: Text('Grid'),
                      icon: Icon(Icons.grid_view_rounded, size: 18),
                    ),
                    ButtonSegment(
                      value: BookingsLayout.list,
                      label: Text('List'),
                      icon: Icon(Icons.view_list_rounded, size: 18),
                    ),
                  ],
                  selected: {layout},
                  onSelectionChanged: (s) => onLayoutChanged(s.first),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        if (layout == BookingsLayout.grid)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.92,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _BookingGridCard(booking: bookings[index]),
                childCount: bookings.length,
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
              itemCount: bookings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) => _BookingListRow(booking: bookings[index]),
            ),
          ),
        SliverToBoxAdapter(child: SizedBox(height: bottomPad)),
      ],
    );
  }
}
