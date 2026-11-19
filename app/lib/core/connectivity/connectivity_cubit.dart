import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'connectivity_service.dart';

@injectable
class ConnectivityCubit extends Cubit<bool> {
  ConnectivityCubit(ConnectivityService service) : super(service.isOnline) {
    _sub = service.changes.listen(emit);
  }

  late final StreamSubscription<bool> _sub;

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
