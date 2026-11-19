// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PackageSummary _$PackageSummaryFromJson(Map<String, dynamic> json) => _PackageSummary(
  id: json['id'] as String,
  name: Localized.fromJson(json['name'] as Map<String, dynamic>),
  priceInr: (json['price_inr'] as num).toInt(),
  mrpInr: (json['mrp_inr'] as num).toInt(),
  testCount: (json['test_count'] as num).toInt(),
  topTests: (json['top_tests'] as List<dynamic>).map((e) => e as String).toList(),
  fastingHours: (json['fasting_hours'] as num).toInt(),
  reportTatHours: (json['report_tat_hours'] as num).toInt(),
  matchReason: Localized.fromJson(json['match_reason'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PackageSummaryToJson(_PackageSummary instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name.toJson(),
  'price_inr': instance.priceInr,
  'mrp_inr': instance.mrpInr,
  'test_count': instance.testCount,
  'top_tests': instance.topTests,
  'fasting_hours': instance.fastingHours,
  'report_tat_hours': instance.reportTatHours,
  'match_reason': instance.matchReason.toJson(),
};

_BookingInfo _$BookingInfoFromJson(Map<String, dynamic> json) => _BookingInfo(
  bookingRef: json['booking_ref'] as String,
  packageId: json['package_id'] as String,
  packageName: Localized.fromJson(json['package_name'] as Map<String, dynamic>),
  date: json['date'] as String,
  timeWindow: json['time_window'] as String,
  addressLabel: json['address_label'] as String,
  patientName: json['patient_name'] as String,
  status: json['status'] as String,
  fastingHours: (json['fasting_hours'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$BookingInfoToJson(_BookingInfo instance) => <String, dynamic>{
  'booking_ref': instance.bookingRef,
  'package_id': instance.packageId,
  'package_name': instance.packageName.toJson(),
  'date': instance.date,
  'time_window': instance.timeWindow,
  'address_label': instance.addressLabel,
  'patient_name': instance.patientName,
  'status': instance.status,
  'fasting_hours': instance.fastingHours,
};

_Slot _$SlotFromJson(Map<String, dynamic> json) =>
    _Slot(date: json['date'] as String, timeWindow: json['time_window'] as String);

Map<String, dynamic> _$SlotToJson(_Slot instance) => <String, dynamic>{
  'date': instance.date,
  'time_window': instance.timeWindow,
};

_SlotOffer _$SlotOfferFromJson(Map<String, dynamic> json) => _SlotOffer(
  requested: Slot.fromJson(json['requested'] as Map<String, dynamic>),
  alternatives: (json['alternatives'] as List<dynamic>)
      .map((e) => Slot.fromJson(e as Map<String, dynamic>))
      .toList(),
  packageId: json['package_id'] as String,
  packageName: Localized.fromJson(json['package_name'] as Map<String, dynamic>),
  addressLabel: json['address_label'] as String,
  patientName: json['patient_name'] as String,
);

Map<String, dynamic> _$SlotOfferToJson(_SlotOffer instance) => <String, dynamic>{
  'requested': instance.requested.toJson(),
  'alternatives': instance.alternatives.map((e) => e.toJson()).toList(),
  'package_id': instance.packageId,
  'package_name': instance.packageName.toJson(),
  'address_label': instance.addressLabel,
  'patient_name': instance.patientName,
};

PackagesCard _$PackagesCardFromJson(Map<String, dynamic> json) => PackagesCard(
  (json['packages'] as List<dynamic>)
      .map((e) => PackageSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$PackagesCardToJson(PackagesCard instance) => <String, dynamic>{
  'packages': instance.packages.map((e) => e.toJson()).toList(),
  'type': instance.$type,
};

BookingCardData _$BookingCardDataFromJson(Map<String, dynamic> json) => BookingCardData(
  BookingInfo.fromJson(json['booking'] as Map<String, dynamic>),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$BookingCardDataToJson(BookingCardData instance) => <String, dynamic>{
  'booking': instance.booking.toJson(),
  'type': instance.$type,
};

SlotsCard _$SlotsCardFromJson(Map<String, dynamic> json) => SlotsCard(
  SlotOffer.fromJson(json['offer'] as Map<String, dynamic>),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$SlotsCardToJson(SlotsCard instance) => <String, dynamic>{
  'offer': instance.offer.toJson(),
  'type': instance.$type,
};

UrgentCard _$UrgentCardFromJson(Map<String, dynamic> json) =>
    UrgentCard(json['category'] as String, $type: json['type'] as String?);

Map<String, dynamic> _$UrgentCardToJson(UrgentCard instance) => <String, dynamic>{
  'category': instance.category,
  'type': instance.$type,
};

CrisisCard _$CrisisCardFromJson(Map<String, dynamic> json) =>
    CrisisCard(json['category'] as String, $type: json['type'] as String?);

Map<String, dynamic> _$CrisisCardToJson(CrisisCard instance) => <String, dynamic>{
  'category': instance.category,
  'type': instance.$type,
};
