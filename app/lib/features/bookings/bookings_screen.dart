import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/db/database.dart';
import '../../core/di.dart';
import '../../core/theme.dart';
import '../../i18n/strings.g.dart';
import '../catalog/package.dart';
import '../chat/domain/models.dart';
import '../chat/presentation/cards.dart';
import 'bookings_cubit.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BookingsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text(context.t.bookings.title)),
        body: BlocBuilder<BookingsCubit, List<Booking>?>(
          builder: (context, bookings) {
            if (bookings == null) return const SizedBox.shrink();
            if (bookings.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    context.t.bookings.empty,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Palette.inkMuted, fontSize: 15),
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final b = bookings[i];
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: BookingCardView(
                      onViewAll: null,
                      booking: BookingInfo(
                        bookingRef: b.bookingRef,
                        packageId: b.packageId,
                        packageName: Localized(en: b.packageNameEn, hi: b.packageNameHi),
                        date: b.slotDate,
                        timeWindow: b.timeWindow,
                        addressLabel: b.addressLabel,
                        patientName: b.patientName,
                        status: b.status,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
