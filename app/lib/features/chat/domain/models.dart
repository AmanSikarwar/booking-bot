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

@Freezed(unionKey: 'type')
sealed class ChatCard with _$ChatCard {
  const factory ChatCard.packages(List<PackageSummary> packages) = PackagesCard;
  const factory ChatCard.booking(BookingInfo booking) = BookingCardData;
  const factory ChatCard.slots(SlotOffer offer) = SlotsCard;
  const factory ChatCard.urgent(String category) = UrgentCard;
  const factory ChatCard.crisis(String category) = CrisisCard;

  factory ChatCard.fromJson(Map<String, Object?> json) => _$ChatCardFromJson(json);
}
