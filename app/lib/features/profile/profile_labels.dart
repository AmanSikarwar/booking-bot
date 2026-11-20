import '../../i18n/strings.g.dart';
import 'profile.dart';

String relationLabel(Translations t, Relation r) => switch (r) {
  Relation.self => t.profile.relations.self,
  Relation.father => t.profile.relations.father,
  Relation.mother => t.profile.relations.mother,
  Relation.spouse => t.profile.relations.spouse,
  Relation.son => t.profile.relations.son,
  Relation.daughter => t.profile.relations.daughter,
  Relation.brother => t.profile.relations.brother,
  Relation.sister => t.profile.relations.sister,
  Relation.other => t.profile.relations.other,
};

String genderLabel(Translations t, Gender g) => switch (g) {
  Gender.female => t.profile.genders.female,
  Gender.male => t.profile.genders.male,
  Gender.other => t.profile.genders.other,
};

String personChip(Translations t, Person p) =>
    '${p.name.split(' ').first} · ${relationLabel(t, p.relation)}';

String personLine(Translations t, Person p) =>
    '${relationLabel(t, p.relation)}, ${t.profile.years(n: p.age)}';
