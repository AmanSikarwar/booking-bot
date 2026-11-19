const timeWindows = ['07-09', '09-11', '11-13', '16-18'];

DateTime _ist(DateTime now) => now.toUtc().add(const Duration(minutes: 330));

String _iso(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

List<String> bookableDates(DateTime now) {
  final today = _ist(now);
  return [for (var i = 0; i < 8; i++) _iso(today.add(Duration(days: i)))];
}

bool isWindowOpen(String date, String window, DateTime now) {
  final ist = _ist(now);
  if (!bookableDates(now).contains(date)) return false;
  if (date == _iso(ist)) return int.parse(window.substring(0, 2)) > ist.hour + 1;
  return true;
}
