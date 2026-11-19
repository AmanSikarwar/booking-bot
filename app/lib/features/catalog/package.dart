import 'package:freezed_annotation/freezed_annotation.dart';

part 'package.freezed.dart';
part 'package.g.dart';

@freezed
abstract class Localized with _$Localized {
  const Localized._();

  const factory Localized({required String en, required String hi}) = _Localized;

  factory Localized.fromJson(Map<String, Object?> json) => _$LocalizedFromJson(json);

  String of(String languageCode) => languageCode == 'hi' ? hi : en;
}

@freezed
abstract class LabPackage with _$LabPackage {
  const factory LabPackage({
    required String id,
    required Localized name,
    required String category,
    required List<String> tests,
    required int testCount,
    required int priceInr,
    required int mrpInr,
    required int fastingHours,
    required String sampleType,
    required int reportTatHours,
    required Localized description,
  }) = _LabPackage;

  factory LabPackage.fromJson(Map<String, Object?> json) => _$LabPackageFromJson(json);
}

@freezed
abstract class Catalog with _$Catalog {
  const factory Catalog({required int version, required List<LabPackage> packages}) = _Catalog;

  factory Catalog.fromJson(Map<String, Object?> json) => _$CatalogFromJson(json);
}
