import 'package:freezed_annotation/freezed_annotation.dart';

import '../../catalog/package.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
abstract class PackageSummary with _$PackageSummary {
  const factory PackageSummary({
    required String id,
    required Localized name,
    required int priceInr,
    required int mrpInr,
    required int testCount,
    required List<String> topTests,
    required int fastingHours,
    required int reportTatHours,
    required Localized matchReason,
  }) = _PackageSummary;

  factory PackageSummary.fromJson(Map<String, Object?> json) => _$PackageSummaryFromJson(json);
}

@freezed
abstract class BookingInfo with _$BookingInfo {
  const factory BookingInfo({
    required String bookingRef,
    required String packageId,
    required Localized packageName,
    required String date,
    required String timeWindow,
    required String addressLabel,
    required String patientName,
    required String status,
    @Default(0) int fastingHours,
  }) = _BookingInfo;

  factory BookingInfo.fromJson(Map<String, Object?> json) => _$BookingInfoFromJson(json);
}

@freezed
abstract class Slot with _$Slot {
  const factory Slot({required String date, required String timeWindow}) = _Slot;

  factory Slot.fromJson(Map<String, Object?> json) => _$SlotFromJson(json);
}

@freezed
abstract class SlotOffer with _$SlotOffer {
  const factory SlotOffer({
    required Slot requested,
    required List<Slot> alternatives,
    required String packageId,
    required Localized packageName,
    required String addressLabel,
    required String patientName,
  }) = _SlotOffer;

  factory SlotOffer.fromJson(Map<String, Object?> json) => _$SlotOfferFromJson(json);
}

@freezed
abstract class SlotRequest with _$SlotRequest {
  const factory SlotRequest({
    required String date,
    required String timeWindow,
    required String addressLabel,
    required String patientName,
  }) = _SlotRequest;

  factory SlotRequest.fromJson(Map<String, Object?> json) => _$SlotRequestFromJson(json);
}

@freezed
abstract class FormPrefill with _$FormPrefill {
  const factory FormPrefill({
    String? date,
    String? timeWindow,
    String? addressLabel,
    String? patientName,
  }) = _FormPrefill;

  factory FormPrefill.fromJson(Map<String, Object?> json) => _$FormPrefillFromJson(json);
}

@freezed
abstract class BookingFormData with _$BookingFormData {
  const factory BookingFormData({
    required String packageId,
    required Localized packageName,
    @Default(0) int fastingHours,
    @Default(FormPrefill()) FormPrefill prefill,
    Map<String, List<String>>? availability,
    SlotRequest? submitted,
  }) = _BookingFormData;

  factory BookingFormData.fromJson(Map<String, Object?> json) => _$BookingFormDataFromJson(json);
}

@Freezed(unionKey: 'type')
sealed class ChatCard with _$ChatCard {
  const factory ChatCard.packages(List<PackageSummary> packages) = PackagesCard;
  const factory ChatCard.booking(BookingInfo booking) = BookingCardData;
  const factory ChatCard.slots(SlotOffer offer) = SlotsCard;
  const factory ChatCard.urgent(String category) = UrgentCard;
  const factory ChatCard.crisis(String category) = CrisisCard;
  const factory ChatCard.bookingForm(BookingFormData form) = BookingFormCard;

  factory ChatCard.fromJson(Map<String, Object?> json) => _$ChatCardFromJson(json);
}
