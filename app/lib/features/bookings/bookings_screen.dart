import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/app_shell.dart';

import '../../core/db/database.dart';
import '../../core/di.dart';
import '../../core/layout.dart';
import '../../core/motion.dart';
import '../../core/theme.dart';
import '../../i18n/strings.g.dart';
import '../catalog/package.dart';
import '../chat/domain/models.dart';
import '../chat/presentation/cards.dart';
import '../profile/profile_cubit.dart';
import 'bookings_cubit.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: backToChat(context),
        title: Text(context.t.bookings.title),
      ),
      body: const BookingsList(padding: EdgeInsets.all(16), maxWidth: 1100),
    );
  }
}

class BookingsList extends StatelessWidget {
  const BookingsList({super.key, required this.padding, this.maxWidth = double.infinity});

  final EdgeInsets padding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BookingsCubit>(),
      child: BlocBuilder<BookingsCubit, List<Booking>?>(
        builder: (context, bookings) {
          if (bookings == null) return const SizedBox.shrink();
          if (bookings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.event_available_outlined, size: 40, color: Palette.line),
                    const SizedBox(height: 12),
                    Text(
                      context.t.bookings.empty,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Palette.inkMuted, fontSize: 15, height: 1.4),
                    ),
                  ],
                ),
              ),
            );
          }
          final fasting = {for (final p in getIt<Catalog>().packages) p.id: p.fastingHours};
          return SingleChildScrollView(
            padding: padding,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: ResponsiveWrap(
                  minItemWidth: 320,
                  children: [
                    for (final (i, b) in bookings.indexed)
                      BookingCardView(
                        onViewAll: null,
                        profile: context.watch<ProfileCubit>().state,
                        booking: BookingInfo(
                          bookingRef: b.bookingRef,
                          packageId: b.packageId,
                          packageName: Localized(en: b.packageNameEn, hi: b.packageNameHi),
                          date: b.slotDate,
                          timeWindow: b.timeWindow,
                          addressLabel: b.addressLabel,
                          patientName: b.patientName,
                          status: b.status,
                          fastingHours: fasting[b.packageId] ?? 0,
                          addressLine: b.addressLine,
                        ),
                      ).enter(context, delay: Motion.stagger * min(i, 8)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
