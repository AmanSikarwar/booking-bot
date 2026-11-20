// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Person _$PersonFromJson(Map<String, dynamic> json) => _Person(
  id: json['id'] as String,
  name: json['name'] as String,
  relation: $enumDecode(_$RelationEnumMap, json['relation']),
  age: (json['age'] as num).toInt(),
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
);

Map<String, dynamic> _$PersonToJson(_Person instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'relation': _$RelationEnumMap[instance.relation]!,
  'age': instance.age,
  'gender': _$GenderEnumMap[instance.gender]!,
};

const _$RelationEnumMap = {
  Relation.self: 'self',
  Relation.father: 'father',
  Relation.mother: 'mother',
  Relation.spouse: 'spouse',
  Relation.son: 'son',
  Relation.daughter: 'daughter',
  Relation.brother: 'brother',
  Relation.sister: 'sister',
  Relation.other: 'other',
};

const _$GenderEnumMap = {Gender.female: 'female', Gender.male: 'male', Gender.other: 'other'};

_Address _$AddressFromJson(Map<String, dynamic> json) => _Address(
  id: json['id'] as String,
  label: json['label'] as String,
  line1: json['line1'] as String,
  line2: json['line2'] as String? ?? '',
  city: json['city'] as String,
  pincode: json['pincode'] as String,
);

Map<String, dynamic> _$AddressToJson(_Address instance) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'line1': instance.line1,
  'line2': instance.line2,
  'city': instance.city,
  'pincode': instance.pincode,
};

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  phone: json['phone'] as String,
  email: json['email'] as String,
  people: (json['people'] as List<dynamic>)
      .map((e) => Person.fromJson(e as Map<String, dynamic>))
      .toList(),
  addresses: (json['addresses'] as List<dynamic>)
      .map((e) => Address.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'phone': instance.phone,
  'email': instance.email,
  'people': instance.people.map((e) => e.toJson()).toList(),
  'addresses': instance.addresses.map((e) => e.toJson()).toList(),
};
