enum RedFlagOutcome { urgent, crisis }

class RedFlagResult {
  const RedFlagResult(this.outcome, this.categories, this.matches, {this.soft = false});

  final RedFlagOutcome outcome;
  final List<String> categories;
  final List<String> matches;
  final bool soft;
}

class _Category {
  _Category(this.id, this.outcome, this.phrases, this.combos);

  final String id;
  final RedFlagOutcome outcome;
  final List<String> phrases;
  final List<List<List<String>>> combos;
}

final _punctuation = RegExp(r'[\p{P}\p{S}]', unicode: true);
final _spaces = RegExp(r'\s+');
final _apostrophes = RegExp('[\'’`]');
const _nuktaLetters = {
  'क़': 'क',
  'ख़': 'ख',
  'ग़': 'ग',
  'ज़': 'ज',
  'ड़': 'ड',
  'ढ़': 'ढ',
  'फ़': 'फ',
  'य़': 'य',
};

String normalize(String text, Map<String, String> variants) {
  final buffer = StringBuffer();
  for (final rune in text.toLowerCase().runes) {
    final ch = String.fromCharCode(rune);
    if (ch == '़') continue;
    buffer.write(_nuktaLetters[ch] ?? (ch == 'ँ' ? 'ं' : ch));
  }
  final cleaned = buffer
      .toString()
      .replaceAll(_apostrophes, '')
      .replaceAll(_punctuation, ' ')
      .replaceAll(_spaces, ' ')
      .trim();
  if (cleaned.isEmpty) return '';
  return cleaned.split(' ').map((t) => variants[t] ?? t).join(' ');
}

class RedFlagDetector {
  RedFlagDetector(Map<String, Object?> rules)
    : _variants = Map<String, String>.from(rules['variants'] as Map),
      _categories = [],
      _acute = [],
      _soften = [] {
    String n(Object? s) => normalize(s as String, _variants);
    List<String> all(Object? list) =>
        (list as List? ?? const []).map(n).where((p) => p.isNotEmpty).toList();
    final soften = rules['soften'] as Map<String, Object?>? ?? const {};
    _acute.addAll(all(soften['acute']));
    for (final r in (soften['rules'] as List? ?? const []).cast<Map<String, Object?>>()) {
      _soften.add((phrases: all(r['phrases']), context: all(r['context'])));
    }
    for (final c in (rules['categories'] as List).cast<Map<String, Object?>>()) {
      _categories.add(
        _Category(
          c['id'] as String,
          RedFlagOutcome.values.byName(c['outcome'] as String),
          (c['phrases'] as List).map(n).where((p) => p.isNotEmpty).toList(),
          (c['combos'] as List)
              .map(
                (groups) => (groups as List)
                    .map((g) => (g as List).map(n).where((w) => w.isNotEmpty).toList())
                    .toList(),
              )
              .toList(),
        ),
      );
    }
  }

  final Map<String, String> _variants;
  final List<_Category> _categories;
  final List<String> _acute;
  final List<({List<String> phrases, List<String> context})> _soften;

  RedFlagResult? detect(String text) {
    final norm = normalize(text, _variants);
    if (norm.isEmpty) return null;
    final padded = ' $norm';
    final words = ' $norm ';
    bool has(String w) => words.contains(' $w ');
    final tokens = norm.split(' ');
    bool present(String w) => tokens.any((t) => t.startsWith(w));
    final categories = <String>[];
    final matches = <String>[];
    RedFlagOutcome? outcome;
    var soft = !_acute.any(has);
    for (final c in _categories) {
      final found = c.phrases.where((p) => padded.contains(' $p')).toList();
      final phrase = found.firstOrNull;
      final combo = phrase != null
          ? null
          : c.combos.where((groups) => groups.every((g) => g.any(present))).firstOrNull;
      if (phrase == null && combo == null) continue;
      soft =
          soft &&
          found.isNotEmpty &&
          found.every((p) => _soften.any((r) => r.phrases.contains(p) && r.context.any(has)));
      categories.add(c.id);
      matches.add(phrase ?? combo!.map((g) => g.firstWhere(present)).join('+'));
      if (c.outcome == RedFlagOutcome.urgent || outcome == null) outcome = c.outcome;
    }
    return outcome == null ? null : RedFlagResult(outcome, categories, matches, soft: soft);
  }
}
