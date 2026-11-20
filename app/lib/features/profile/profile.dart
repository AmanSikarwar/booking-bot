import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

enum Relation { self, father, mother, spouse, son, daughter, brother, sister, other }

enum Gender { female, male, other }

@freezed
abstract class Person with _$Person {
  const factory Person({
    required String id,
    required String name,
    required Relation relation,
    required int age,
    required Gender gender,
  }) = _Person;

  factory Person.fromJson(Map<String, Object?> json) => _$PersonFromJson(json);
}

@freezed
abstract class Address with _$Address {
  const factory Address({
    required String id,
    required String label,
    required String line1,
    @Default('') String line2,
    required String city,
    required String pincode,
  }) = _Address;

  factory Address.fromJson(Map<String, Object?> json) => _$AddressFromJson(json);
}

@freezed
abstract class Profile with _$Profile {
  const Profile._();

  const factory Profile({
    required String phone,
    required String email,
    required List<Person> people,
    required List<Address> addresses,
  }) = _Profile;

  factory Profile.fromJson(Map<String, Object?> json) => _$ProfileFromJson(json);

  Person get self => people.firstWhere((p) => p.relation == Relation.self);

  Person? personNamed(String name) {
    final n = name.trim().toLowerCase();
    if (n.isEmpty) return null;
    return people.where((p) => p.name.toLowerCase() == n).firstOrNull ??
        people
            .where((p) => p.name.toLowerCase().split(' ').first == n.split(' ').first)
            .firstOrNull;
  }

  Address? addressLabelled(String label) {
    final l = label.trim().toLowerCase();
    return addresses.where((a) => a.label.toLowerCase() == l).firstOrNull;
  }

  Map<String, Object?> forAgent() => {
    'patients': [
      for (final p in people) {'name': p.name, 'relation': p.relation.name},
    ],
    'addresses': [for (final a in addresses) a.label],
  };
}

String fullAddress(Address a) =>
    [a.line1, a.line2, '${a.city} ${a.pincode}'].where((s) => s.trim().isNotEmpty).join(', ');

const sampleProfile = Profile(
  phone: '+91 90000 00001',
  email: 'priya.sharma@example.com',
  people: [
    Person(
      id: 'p-self',
      name: 'Priya Sharma',
      relation: Relation.self,
      age: 32,
      gender: Gender.female,
    ),
    Person(
      id: 'p-father',
      name: 'Ramesh Sharma',
      relation: Relation.father,
      age: 64,
      gender: Gender.male,
    ),
    Person(
      id: 'p-mother',
      name: 'Sunita Sharma',
      relation: Relation.mother,
      age: 60,
      gender: Gender.female,
    ),
    Person(
      id: 'p-spouse',
      name: 'Arjun Sharma',
      relation: Relation.spouse,
      age: 34,
      gender: Gender.male,
    ),
  ],
  addresses: [
    Address(
      id: 'a-home',
      label: 'Home',
      line1: 'Flat 302, Sunrise Apartments',
      line2: 'Sector 14',
      city: 'Gurugram',
      pincode: '122001',
    ),
    Address(
      id: 'a-office',
      label: 'Office',
      line1: '4th Floor, Tower B, Cyber City',
      city: 'Gurugram',
      pincode: '122002',
    ),
    Address(
      id: 'a-parents',
      label: "Papa's house",
      line1: 'House 21, Block C',
      line2: 'Sector 9',
      city: 'Gurugram',
      pincode: '122001',
    ),
  ],
);
