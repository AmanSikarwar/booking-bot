// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Localized _$LocalizedFromJson(Map<String, dynamic> json) =>
    _Localized(en: json['en'] as String, hi: json['hi'] as String);

Map<String, dynamic> _$LocalizedToJson(_Localized instance) => <String, dynamic>{
  'en': instance.en,
  'hi': instance.hi,
};

_LabPackage _$LabPackageFromJson(Map<String, dynamic> json) => _LabPackage(
  id: json['id'] as String,
  name: Localized.fromJson(json['name'] as Map<String, dynamic>),
  category: json['category'] as String,
  tests: (json['tests'] as List<dynamic>).map((e) => e as String).toList(),
  testCount: (json['test_count'] as num).toInt(),
  priceInr: (json['price_inr'] as num).toInt(),
  mrpInr: (json['mrp_inr'] as num).toInt(),
  fastingHours: (json['fasting_hours'] as num).toInt(),
  sampleType: json['sample_type'] as String,
  reportTatHours: (json['report_tat_hours'] as num).toInt(),
  description: Localized.fromJson(json['description'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LabPackageToJson(_LabPackage instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name.toJson(),
  'category': instance.category,
  'tests': instance.tests,
  'test_count': instance.testCount,
  'price_inr': instance.priceInr,
  'mrp_inr': instance.mrpInr,
  'fasting_hours': instance.fastingHours,
  'sample_type': instance.sampleType,
  'report_tat_hours': instance.reportTatHours,
  'description': instance.description.toJson(),
};

_Catalog _$CatalogFromJson(Map<String, dynamic> json) => _Catalog(
  version: (json['version'] as num).toInt(),
  packages: (json['packages'] as List<dynamic>)
      .map((e) => LabPackage.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CatalogToJson(_Catalog instance) => <String, dynamic>{
  'version': instance.version,
  'packages': instance.packages.map((e) => e.toJson()).toList(),
};
