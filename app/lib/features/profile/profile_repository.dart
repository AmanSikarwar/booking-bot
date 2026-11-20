import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../core/db/database.dart';
import 'profile.dart';

@lazySingleton
class ProfileRepository {
  ProfileRepository(this._db, this._uuid);

  static const _key = 'profile';

  final AppDatabase _db;
  final Uuid _uuid;

  Stream<Profile> watch() => _db.watchMeta(_key).asyncMap((raw) async {
    if (raw != null) return Profile.fromJson(jsonDecode(raw) as Map<String, Object?>);
    await _save(sampleProfile);
    return sampleProfile;
  });

  Future<Profile> current() async {
    final raw = await _db.meta(_key);
    return raw == null ? sampleProfile : Profile.fromJson(jsonDecode(raw) as Map<String, Object?>);
  }

  Future<void> _save(Profile p) => _db.setMeta(_key, jsonEncode(p.toJson()));

  Future<void> update(Profile Function(Profile) change) async => _save(change(await current()));

  Future<void> savePerson(Person person) => update((p) {
    final withId = person.id.isEmpty ? person.copyWith(id: _uuid.v4()) : person;
    final exists = p.people.any((x) => x.id == withId.id);
    return p.copyWith(
      people: exists
          ? [for (final x in p.people) x.id == withId.id ? withId : x]
          : [...p.people, withId],
    );
  });

  Future<void> removePerson(String id) => update(
    (p) => p.copyWith(
      people: [
        for (final x in p.people)
          if (x.id != id || x.relation == Relation.self) x,
      ],
    ),
  );

  Future<void> saveAddress(Address address) => update((p) {
    final withId = address.id.isEmpty ? address.copyWith(id: _uuid.v4()) : address;
    final exists = p.addresses.any((x) => x.id == withId.id);
    return p.copyWith(
      addresses: exists
          ? [for (final x in p.addresses) x.id == withId.id ? withId : x]
          : [...p.addresses, withId],
    );
  });

  Future<void> removeAddress(String id) => update(
    (p) => p.copyWith(
      addresses: [
        for (final x in p.addresses)
          if (x.id != id) x,
      ],
    ),
  );

  Future<void> reset() => _save(sampleProfile);
}
