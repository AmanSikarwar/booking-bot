import 'package:material_ui/material_ui.dart';

import '../../../core/db/database.dart';
import '../../../i18n/strings.g.dart';
import '../../catalog/package.dart';
import '../domain/models.dart';

sealed class Suggestion {
  const Suggestion(this.label, this.icon);

  final String label;
  final IconData icon;
}

class SendSuggestion extends Suggestion {
  const SendSuggestion(super.label, super.icon, this.text);

  final String text;
}

class BookSuggestion extends Suggestion {
  const BookSuggestion(super.label, super.icon, this.packageId, this.name);

  final String packageId;
  final Localized name;
}

enum Destination { bookings, catalog }

class OpenSuggestion extends Suggestion {
  const OpenSuggestion(super.label, super.icon, this.destination);

  final Destination destination;
}

const _starterIcons = [
  Icons.biotech_outlined,
  Icons.health_and_safety_outlined,
  Icons.water_drop_outlined,
  Icons.battery_alert_outlined,
];

String shortName(String name) => name.split(' (').first;

List<Suggestion> suggestionsFor(
  Translations t,
  List<Message> rows, {
  required bool flagged,
  required String lang,
}) {
  if (flagged) return const [];
  if (rows.isEmpty) {
    return [
      for (final (i, s) in t.chat.suggestions.indexed)
        SendSuggestion(s, _starterIcons[i % _starterIcons.length], s),
    ];
  }
  final pending = rows.any(
    (r) =>
        (r.role == MessageRole.user && r.status != MessageStatus.sent) ||
        (r.role == MessageRole.assistant && r.status == MessageStatus.streaming),
  );
  if (pending || rows.last.role == MessageRole.user) return const [];

  final f = t.followUps;
  final cards = rows.last.cards;
  if (cards.any((c) => c is BookingFormCard && c.form.submitted == null)) return const [];
  if (cards.any((c) => c is UrgentCard || c is CrisisCard)) return const [];
  if (cards.any((c) => c is BookingCardData)) {
    return [
      SendSuggestion(f.another, Icons.add_circle_outline, f.anotherText),
      OpenSuggestion(f.bookings, Icons.event_note_outlined, Destination.bookings),
      SendSuggestion(f.prepare, Icons.help_outline, f.prepareText),
    ];
  }
  final slots = cards.whereType<SlotsCard>().lastOrNull?.offer;
  if (slots != null) {
    return [BookSuggestion(f.anotherDay, Icons.event_outlined, slots.packageId, slots.packageName)];
  }
  final packages = cards.whereType<PackagesCard>().lastOrNull?.packages;
  if (packages != null && packages.isNotEmpty) {
    final top = packages.first;
    return [
      BookSuggestion(
        f.book(name: shortName(top.name.of(lang))),
        Icons.home_outlined,
        top.id,
        top.name,
      ),
      SendSuggestion(f.cheaper, Icons.savings_outlined, f.cheaperText),
      SendSuggestion(f.noFasting, Icons.restaurant_outlined, f.noFastingText),
    ];
  }
  return [
    SendSuggestion(f.suggest, Icons.auto_awesome_outlined, f.suggestText),
    SendSuggestion(f.fullBody, Icons.health_and_safety_outlined, f.fullBody),
    OpenSuggestion(f.browse, Icons.science_outlined, Destination.catalog),
  ];
}
