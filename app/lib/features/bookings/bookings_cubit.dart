import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../core/db/database.dart';

@injectable
class BookingsCubit extends Cubit<List<Booking>?> {
  BookingsCubit(AppDatabase db) : super(null) {
    _sub = db.watchBookings().listen(emit);
  }

  late final StreamSubscription<List<Booking>> _sub;

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
