import 'package:freezed_annotation/freezed_annotation.dart';

import 'models.dart';

part 'chat_event.freezed.dart';

@freezed
sealed class ChatEvent with _$ChatEvent {
  const factory ChatEvent.ack({required bool replay}) = AckEvent;
  const factory ChatEvent.textDelta(String text) = TextDeltaEvent;
  const factory ChatEvent.toolStarted(String tool) = ToolStartedEvent;
  const factory ChatEvent.card(ChatCard card) = CardEvent;
  const factory ChatEvent.error({required String code, required bool retryable, int? retryAfter}) =
      ErrorEvent;
  const factory ChatEvent.done() = DoneEvent;
  const factory ChatEvent.unknown(String name) = UnknownEvent;

  static ChatEvent parse(String name, Map<String, Object?> d) => switch (name) {
    'ack' => ChatEvent.ack(replay: d['replay'] == true),
    'text_delta' => ChatEvent.textDelta(d['text'] as String? ?? ''),
    'tool_started' => ChatEvent.toolStarted(d['tool'] as String? ?? ''),
    'package_cards' => ChatEvent.card(
      ChatCard.packages([
        for (final p in (d['packages'] as List? ?? const []).cast<Map<String, Object?>>())
          PackageSummary.fromJson(p),
      ]),
    ),
    'booking_confirmed' => ChatEvent.card(ChatCard.booking(BookingInfo.fromJson(d))),
    'slot_unavailable' => ChatEvent.card(ChatCard.slots(SlotOffer.fromJson(d))),
    'urgent_care' => ChatEvent.card(ChatCard.urgent(d['category'] as String? ?? '')),
    'crisis_support' => ChatEvent.card(ChatCard.crisis(d['category'] as String? ?? '')),
    'error' => ChatEvent.error(
      code: d['code'] as String? ?? 'unknown',
      retryable: d['retryable'] == true,
      retryAfter: (d['retry_after'] as num?)?.toInt(),
    ),
    'done' => const ChatEvent.done(),
    _ => ChatEvent.unknown(name),
  };
}
