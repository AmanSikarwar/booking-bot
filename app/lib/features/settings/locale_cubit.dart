import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../core/db/database.dart';
import '../../i18n/strings.g.dart';

@injectable
class LocaleCubit extends Cubit<AppLocale> {
  LocaleCubit(this._db) : super(LocaleSettings.currentLocale);

  static const _key = 'locale';
  final AppDatabase _db;

  Future<void> load() async {
    final saved = await _db.meta(_key);
    if (saved != null) await _apply(AppLocaleUtils.parse(saved));
  }

  Future<void> toggle() => _apply(state == AppLocale.en ? AppLocale.hi : AppLocale.en);

  Future<void> _apply(AppLocale locale) async {
    await LocaleSettings.setLocale(locale);
    await _db.setMeta(_key, locale.languageCode);
    emit(locale);
  }
}
