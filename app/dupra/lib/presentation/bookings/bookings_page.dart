import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/bookings/data/sample_booking.dart';
import 'package:dupra/presentation/bookings/data/sample_bookings.dart';
import 'package:flutter/material.dart';

part 'booking_formatting.dart';
part 'bookings_scroll_view.dart';
part 'widgets/booking_grid_card.dart';
part 'widgets/booking_list_row.dart';
part 'widgets/booking_status_chip.dart';

enum BookingsLayout { grid, list }

/// Bookings tab: layout toggle + grid or list of rows (sample data until API).
class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  BookingsLayout _layout = BookingsLayout.grid;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomPad = 24.0 + bottomInset + 72;

    return _BookingsScrollView(
      layout: _layout,
      onLayoutChanged: (v) => setState(() => _layout = v),
      bookings: kSampleBookings,
      bottomPad: bottomPad,
    );
  }
}
