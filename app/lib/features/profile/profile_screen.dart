import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/app_shell.dart';
import '../../core/layout.dart';
import '../../core/motion.dart';
import '../../core/theme.dart';
import '../../i18n/strings.g.dart';
import '../settings/locale_cubit.dart';
import 'profile.dart';
import 'profile_cubit.dart';
import 'profile_labels.dart';
import 'profile_repository.dart';

String initials(String name) => name
    .split(' ')
    .where((p) => p.isNotEmpty)
    .take(2)
    .map((p) => p.characters.first.toUpperCase())
    .join();

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.name, this.size = 40});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Palette.tealSoft, shape: BoxShape.circle),
      child: Text(
        initials(name),
        style: TextStyle(color: Palette.teal, fontWeight: FontWeight.w700, fontSize: size * 0.38),
      ),
    ),
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.profile;
    final profile = context.watch<ProfileCubit>().state;
    final repo = context.read<ProfileCubit>().repository;
    final self = profile.self;
    final family = profile.people.where((p) => p.relation != Relation.self).toList();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: backToChat(context),
        title: Text(t.title),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: staggered(context, [
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ProfileAvatar(name: self.name, size: 56),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    self.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Palette.ink,
                                    ),
                                  ),
                                  Text(
                                    '${t.years(n: self.age)} · ${genderLabel(context.t, self.gender)}',
                                    style: const TextStyle(color: Palette.inkMuted),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: t.editPerson,
                              onPressed: () => _editPerson(context, self),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                          ],
                        ),
                        const Divider(height: 24, color: Palette.line),
                        _Line(Icons.phone_outlined, t.phone, profile.phone),
                        _Line(Icons.mail_outline, t.email, profile.email),
                      ],
                    ),
                  ),
                  _Heading(t.family),
                  _Card(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (final p in family)
                          _Tile(
                            leading: ProfileAvatar(name: p.name),
                            title: p.name,
                            subtitle:
                                '${personLine(context.t, p)} · ${genderLabel(context.t, p.gender)}',
                            onTap: () => _editPerson(context, p),
                          ),
                        _AddTile(
                          label: t.addPerson,
                          onTap: () => _editPerson(
                            context,
                            const Person(
                              id: '',
                              name: '',
                              relation: Relation.other,
                              age: 30,
                              gender: Gender.female,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _Heading(t.addresses),
                  _Card(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (final a in profile.addresses)
                          _Tile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Palette.tealSoft,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                switch (a.label.toLowerCase()) {
                                  'home' || 'घर' => Icons.home_outlined,
                                  'office' || 'work' || 'ऑफ़िस' => Icons.work_outline,
                                  _ => Icons.place_outlined,
                                },
                                color: Palette.teal,
                                size: 20,
                              ),
                            ),
                            title: a.label,
                            subtitle: fullAddress(a),
                            onTap: () => _editAddress(context, a),
                          ),
                        _AddTile(
                          label: t.addAddress,
                          onTap: () => _editAddress(
                            context,
                            const Address(
                              id: '',
                              label: '',
                              line1: '',
                              city: 'Gurugram',
                              pincode: '',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _Heading(context.t.settings.language),
                  _Card(
                    child: SegmentedButton<AppLocale>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(value: AppLocale.en, label: Text('English')),
                        ButtonSegment(value: AppLocale.hi, label: Text('हिन्दी')),
                      ],
                      selected: {context.watch<LocaleCubit>().state},
                      onSelectionChanged: (s) {
                        if (s.first != context.read<LocaleCubit>().state) {
                          unawaited(context.read<LocaleCubit>().toggle());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Palette.tealSoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.shield_outlined, size: 18, color: Palette.teal),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            t.sample,
                            style: const TextStyle(fontSize: 13, color: Palette.ink, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton.icon(
                      onPressed: () => unawaited(repo.reset()),
                      icon: const Icon(Icons.restart_alt),
                      label: Text(t.reset),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showEditor(BuildContext context, Widget child) {
  if (context.windowSize == WindowSize.compact) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Palette.surface,
      builder: (sheet) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheet).bottom),
        child: child,
      ),
    );
  }
  return showDialog<void>(
    context: context,
    useRootNavigator: true,
    builder: (_) => Dialog(
      backgroundColor: Palette.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 480), child: child),
    ),
  );
}

void _editPerson(BuildContext context, Person person) => unawaited(
  _showEditor(context, PersonEditor(person: person, repo: context.read<ProfileCubit>().repository)),
);

void _editAddress(BuildContext context, Address address) => unawaited(
  _showEditor(
    context,
    AddressEditor(address: address, repo: context.read<ProfileCubit>().repository),
  ),
);

class PersonEditor extends StatefulWidget {
  const PersonEditor({super.key, required this.person, required this.repo});

  final Person person;
  final ProfileRepository repo;

  @override
  State<PersonEditor> createState() => _PersonEditorState();
}

class _PersonEditorState extends State<PersonEditor> {
  late final _name = TextEditingController(text: widget.person.name);
  late final _age = TextEditingController(
    text: widget.person.id.isEmpty ? '' : '${widget.person.age}',
  );
  late Relation _relation = widget.person.relation;
  late Gender _gender = widget.person.gender;
  bool _showErrors = false;

  bool get _isSelf => widget.person.relation == Relation.self;

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    super.dispose();
  }

  int? get _ageValue {
    final v = int.tryParse(_age.text.trim());
    return v != null && v >= 0 && v <= 120 ? v : null;
  }

  void _save() {
    if (_name.text.trim().isEmpty || _ageValue == null) {
      setState(() => _showErrors = true);
      return;
    }
    unawaited(
      widget.repo.savePerson(
        widget.person.copyWith(
          name: _name.text.trim(),
          age: _ageValue!,
          relation: _relation,
          gender: _gender,
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.profile;
    final compact = context.windowSize == WindowSize.compact;
    return _EditorFrame(
      title: widget.person.id.isEmpty ? t.addPerson : t.editPerson,
      onSave: _save,
      onRemove: widget.person.id.isEmpty || _isSelf
          ? null
          : () {
              unawaited(widget.repo.removePerson(widget.person.id));
              Navigator.of(context).pop();
            },
      children: [
        _field(
          _name,
          t.name,
          error: _showErrors && _name.text.trim().isEmpty ? context.t.form.required : null,
          caps: TextCapitalization.words,
        ),
        _field(
          _age,
          t.age,
          error: _showErrors && _ageValue == null ? t.invalidAge : null,
          keyboard: TextInputType.number,
          formatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
        ),
        if (!_isSelf) ...[
          _EditorLabel(t.relation),
          Wrap(
            spacing: compact ? 6 : 8,
            runSpacing: compact ? 4 : 8,
            children: [
              for (final r in Relation.values.where((r) => r != Relation.self))
                ChoiceChip(
                  label: Text(relationLabel(context.t, r)),
                  selected: _relation == r,
                  onSelected: (_) => setState(() => _relation = r),
                ),
            ],
          ),
        ],
        _EditorLabel(t.gender),
        Wrap(
          spacing: compact ? 6 : 8,
          children: [
            for (final g in Gender.values)
              ChoiceChip(
                label: Text(genderLabel(context.t, g)),
                selected: _gender == g,
                onSelected: (_) => setState(() => _gender = g),
              ),
          ],
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    String? error,
    TextInputType? keyboard,
    List<TextInputFormatter>? formatters,
    TextCapitalization caps = TextCapitalization.none,
  }) => Padding(
    padding: EdgeInsets.only(bottom: context.windowSize == WindowSize.compact ? 8 : 12),
    child: TextField(
      controller: c,
      keyboardType: keyboard,
      inputFormatters: formatters,
      textCapitalization: caps,
      onChanged: (_) => setState(() {}),
      decoration: _decoration(label, error),
    ),
  );
}

class AddressEditor extends StatefulWidget {
  const AddressEditor({super.key, required this.address, required this.repo});

  final Address address;
  final ProfileRepository repo;

  @override
  State<AddressEditor> createState() => _AddressEditorState();
}

class _AddressEditorState extends State<AddressEditor> {
  late final _label = TextEditingController(text: widget.address.label);
  late final _line1 = TextEditingController(text: widget.address.line1);
  late final _line2 = TextEditingController(text: widget.address.line2);
  late final _city = TextEditingController(text: widget.address.city);
  late final _pin = TextEditingController(text: widget.address.pincode);
  bool _showErrors = false;

  @override
  void dispose() {
    for (final c in [_label, _line1, _line2, _city, _pin]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _pinOk => RegExp(r'^\d{6}$').hasMatch(_pin.text.trim());

  void _save() {
    if ([_label, _line1, _city].any((c) => c.text.trim().isEmpty) || !_pinOk) {
      setState(() => _showErrors = true);
      return;
    }
    unawaited(
      widget.repo.saveAddress(
        widget.address.copyWith(
          label: _label.text.trim(),
          line1: _line1.text.trim(),
          line2: _line2.text.trim(),
          city: _city.text.trim(),
          pincode: _pin.text.trim(),
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.profile;
    final compact = context.windowSize == WindowSize.compact;
    String? req(TextEditingController c) =>
        _showErrors && c.text.trim().isEmpty ? context.t.form.required : null;
    Widget field(TextEditingController c, String label, {String? error, TextInputType? keyboard}) =>
        Padding(
          padding: EdgeInsets.only(bottom: compact ? 8 : 12),
          child: TextField(
            controller: c,
            keyboardType: keyboard,
            onChanged: (_) => setState(() {}),
            decoration: _decoration(label, error),
          ),
        );
    return _EditorFrame(
      title: widget.address.id.isEmpty ? t.addAddress : t.editAddress,
      onSave: _save,
      onRemove: widget.address.id.isEmpty
          ? null
          : () {
              unawaited(widget.repo.removeAddress(widget.address.id));
              Navigator.of(context).pop();
            },
      children: [
        field(_label, t.label, error: req(_label)),
        field(_line1, t.line1, error: req(_line1)),
        field(_line2, t.line2),
        field(_city, t.city, error: req(_city)),
        field(
          _pin,
          t.pincode,
          keyboard: TextInputType.number,
          error: _showErrors && !_pinOk ? t.invalidPin : null,
        ),
      ],
    );
  }
}

InputDecoration _decoration(String label, String? error) => InputDecoration(
  labelText: label,
  errorText: error,
  filled: true,
  fillColor: Palette.paper,
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

class _EditorFrame extends StatelessWidget {
  const _EditorFrame({
    required this.title,
    required this.children,
    required this.onSave,
    this.onRemove,
  });

  final String title;
  final List<Widget> children;
  final VoidCallback onSave;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final t = context.t.profile;
    final compact = context.windowSize == WindowSize.compact;
    return SingleChildScrollView(
      padding: compact
          ? const EdgeInsets.fromLTRB(16, 8, 16, 16)
          : const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Palette.ink),
          ),
          SizedBox(height: compact ? 12 : 16),
          ...children,
          SizedBox(height: compact ? 12 : 16),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: compact ? 4 : 8,
            children: [
              if (onRemove != null)
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Palette.urgent),
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                  label: Text(t.remove),
                ),
              OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: Text(t.cancel)),
              FilledButton(onPressed: onSave, child: Text(t.save)),
            ],
          ),
        ],
      ),
    );
  }
}

class _EditorLabel extends StatelessWidget {
  const _EditorLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: 4, bottom: context.windowSize == WindowSize.compact ? 6 : 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Palette.ink),
    ),
  );
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding = const EdgeInsets.all(16)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    padding: padding,
    decoration: BoxDecoration(
      color: Palette.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Palette.line),
    ),
    child: child,
  );
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Palette.inkMuted),
    ),
  );
}

class _Line extends StatelessWidget {
  const _Line(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(icon, size: 18, color: Palette.inkMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Palette.inkMuted)),
              Text(value, style: const TextStyle(color: Palette.ink)),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Palette.ink),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Palette.inkMuted, height: 1.35),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Palette.inkMuted),
        ],
      ),
    ),
  );
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Palette.line)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.add_circle_outline, color: Palette.teal),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, color: Palette.teal),
            ),
          ),
        ],
      ),
    ),
  );
}
