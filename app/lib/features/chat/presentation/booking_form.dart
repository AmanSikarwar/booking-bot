import 'package:material_ui/material_ui.dart';

import '../../../core/motion.dart';
import '../../../core/theme.dart';
import '../../../i18n/strings.g.dart';
import '../../profile/profile.dart';
import '../../profile/profile_labels.dart';
import '../domain/models.dart';
import '../domain/slots.dart';
import 'cards.dart';

class BookingFormView extends StatefulWidget {
  const BookingFormView({
    super.key,
    required this.form,
    required this.profile,
    required this.onSubmit,
    this.now,
  });

  final BookingFormData form;
  final Profile profile;
  final void Function(SlotRequest request)? onSubmit;
  final DateTime? now;

  @override
  State<BookingFormView> createState() => _BookingFormViewState();
}

const _other = 'other';

class _BookingFormViewState extends State<BookingFormView> {
  late final DateTime _now = widget.now ?? DateTime.now();
  late final List<String> _dates = bookableDates(_now);
  late String? _date = _validDate(widget.form.prefill.date);
  late String? _window = _validWindow(_date, widget.form.prefill.timeWindow);
  late String _addressId = _initialAddress();
  late String _personId = _initialPerson();
  late final _otherAddress = TextEditingController(
    text: _addressId == _other ? widget.form.prefill.addressLabel : null,
  );
  late final _otherPatient = TextEditingController(
    text: _personId == _other ? widget.form.prefill.patientName : null,
  );
  bool _showErrors = false;

  @override
  void dispose() {
    _otherAddress.dispose();
    _otherPatient.dispose();
    super.dispose();
  }

  String _initialAddress() {
    final label = widget.form.prefill.addressLabel?.trim() ?? '';
    final saved = widget.profile.addressLabelled(label);
    if (saved != null) return saved.id;
    if (label.isNotEmpty) return _other;
    return widget.profile.addresses.firstOrNull?.id ?? _other;
  }

  String _initialPerson() {
    final name = widget.form.prefill.patientName?.trim() ?? '';
    final saved = widget.profile.personNamed(name);
    if (saved != null) return saved.id;
    if (name.isNotEmpty) return _other;
    return widget.profile.self.id;
  }

  List<String> _open(String date) => [
    for (final w in timeWindows)
      if (isWindowOpen(date, w, _now) &&
          (widget.form.availability == null ||
              (widget.form.availability![date]?.contains(w) ?? false)))
        w,
  ];

  String? _validDate(String? d) =>
      d != null && _dates.contains(d) && _open(d).isNotEmpty ? d : null;

  String? _validWindow(String? d, String? w) =>
      d != null && w != null && _open(d).contains(w) ? w : null;

  String get _addressLabel => _addressId == _other
      ? _otherAddress.text.trim()
      : widget.profile.addresses.firstWhere((a) => a.id == _addressId).label;

  String get _patientName => _personId == _other
      ? _otherPatient.text.trim()
      : widget.profile.people.firstWhere((p) => p.id == _personId).name;

  String _dayLabel(BuildContext context, String date) {
    final i = _dates.indexOf(date);
    if (i == 0) return context.t.form.today;
    if (i == 1) return context.t.form.tomorrow;
    return dateLabel(context, date);
  }

  void _submit() {
    final address = _addressLabel;
    final patient = _patientName;
    if (_date == null || _window == null || address.isEmpty || patient.isEmpty) {
      setState(() => _showErrors = true);
      return;
    }
    widget.onSubmit!(
      SlotRequest(date: _date!, timeWindow: _window!, addressLabel: address, patientName: patient),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.form;
    final lang = TranslationProvider.of(context).flutterLocale.languageCode;
    final submitted = widget.form.submitted;
    return Container(
      decoration: BoxDecoration(
        color: Palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Palette.line),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.home_outlined, color: Palette.teal, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  t.title,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Palette.teal),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            widget.form.packageName.of(lang),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Palette.ink),
          ),
          if (widget.form.fastingHours > 0)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                t.fasting(h: widget.form.fastingHours),
                style: const TextStyle(fontSize: 13, color: Palette.inkMuted),
              ),
            ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: Motion.on(context) ? Motion.normal : Duration.zero,
            switchInCurve: Motion.curve,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                alignment: AlignmentDirectional.topStart,
                child: child,
              ),
            ),
            child: submitted != null
                ? _Summary(
                    key: const ValueKey('summary'),
                    request: submitted,
                    profile: widget.profile,
                  )
                : Column(
                    key: const ValueKey('fields'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _fields(context),
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _fields(BuildContext context) {
    final t = context.t.form;
    final enabled = widget.onSubmit != null;
    final dateError = _showErrors && _date == null;
    final timeError = _showErrors && _date != null && _window == null;
    final addressError = _showErrors && _addressId == _other && _otherAddress.text.trim().isEmpty;
    final patientError = _showErrors && _personId == _other && _otherPatient.text.trim().isEmpty;
    final tp = context.t.profile;
    final selectedAddress = widget.profile.addresses.where((a) => a.id == _addressId).firstOrNull;
    return [
      _Label(t.date, error: dateError ? t.pickDate : null),
      SizedBox(
        height: 44,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (final d in _dates)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: ChoiceChip(
                  label: Text(_dayLabel(context, d)),
                  selected: _date == d,
                  onSelected: enabled && _open(d).isNotEmpty
                      ? (_) => setState(() {
                          _date = d;
                          if (!_open(d).contains(_window)) _window = null;
                        })
                      : null,
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      _Label(t.time, error: timeError ? t.pickTime : null),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final w in timeWindows)
            _windowChip(context, w, enabled && (_date == null || _open(_date!).contains(w))),
        ],
      ),
      const SizedBox(height: 12),
      _Label(t.patient),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final p in widget.profile.people)
            ChoiceChip(
              label: Text(personChip(context.t, p)),
              selected: _personId == p.id,
              onSelected: enabled ? (_) => setState(() => _personId = p.id) : null,
            ),
          ChoiceChip(
            label: Text(tp.someoneElse),
            selected: _personId == _other,
            onSelected: enabled ? (_) => setState(() => _personId = _other) : null,
          ),
        ],
      ),
      if (_personId == _other)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: TextField(
            controller: _otherPatient,
            enabled: enabled,
            maxLength: 80,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.name],
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() {}),
            decoration: _input(t.patientHint, error: patientError ? t.required : null),
          ),
        ),
      const SizedBox(height: 12),
      _Label(t.address),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final a in widget.profile.addresses)
            ChoiceChip(
              label: Text(a.label),
              selected: _addressId == a.id,
              onSelected: enabled ? (_) => setState(() => _addressId = a.id) : null,
            ),
          ChoiceChip(
            label: Text(t.other),
            selected: _addressId == _other,
            onSelected: enabled ? (_) => setState(() => _addressId = _other) : null,
          ),
        ],
      ),
      if (selectedAddress != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.place_outlined, size: 16, color: Palette.inkMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  fullAddress(selectedAddress),
                  style: const TextStyle(fontSize: 13, color: Palette.inkMuted, height: 1.35),
                ),
              ),
            ],
          ),
        ),
      if (_addressId == _other)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: TextField(
            controller: _otherAddress,
            enabled: enabled,
            maxLength: 60,
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
            decoration: _input(t.otherHint, error: addressError ? t.required : null),
          ),
        ),
      const SizedBox(height: 14),
      SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: enabled ? _submit : null,
          icon: const Icon(Icons.check, size: 18),
          label: Text(t.confirm),
        ),
      ),
    ];
  }

  Widget _windowChip(BuildContext context, String w, bool open) {
    final label = windowLabel(context, w);
    final full = _date != null && !open && isWindowOpen(_date!, w, _now);
    return ChoiceChip(
      label: Text(full ? '$label · ${context.t.form.full}' : label),
      selected: _window == w,
      onSelected: open ? (_) => setState(() => _window = w) : null,
    );
  }

  InputDecoration _input(String hint, {String? error}) => InputDecoration(
    hintText: hint,
    errorText: error,
    counterText: '',
    isDense: true,
    filled: true,
    fillColor: Palette.paper,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Palette.line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Palette.teal, width: 1.5),
    ),
  );
}

class _Label extends StatelessWidget {
  const _Label(this.text, {this.error});

  final String text;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Wrap(
        spacing: 8,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Palette.ink),
          ),
          if (error != null)
            Text(error!, style: const TextStyle(fontSize: 13, color: Palette.urgent)),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({super.key, required this.request, required this.profile});

  final SlotRequest request;
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${dateLabel(context, request.date)} · ${windowLabel(context, request.timeWindow)}',
          style: const TextStyle(color: Palette.ink),
        ),
        Text(
          '${request.addressLabel} · ${t.booking.forPatient(name: request.patientName)}',
          style: const TextStyle(color: Palette.inkMuted),
        ),
        if (profile.addressLabelled(request.addressLabel) case final a?)
          Text(fullAddress(a), style: const TextStyle(fontSize: 12, color: Palette.inkMuted)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.check_circle_outline, size: 16, color: Palette.success),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                t.form.sent,
                style: const TextStyle(fontSize: 13, color: Palette.success),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
