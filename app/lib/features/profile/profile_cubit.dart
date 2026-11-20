import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'profile.dart';
import 'profile_repository.dart';

@injectable
class ProfileCubit extends Cubit<Profile> {
  ProfileCubit(this.repository) : super(sampleProfile) {
    _sub = repository.watch().listen(emit);
  }

  final ProfileRepository repository;
  late final StreamSubscription<Profile> _sub;

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
