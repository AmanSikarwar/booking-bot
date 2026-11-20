import 'package:drift/native.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:saathi/core/db/database.dart';
import 'package:saathi/core/theme.dart';
import 'package:saathi/features/profile/profile.dart';
import 'package:saathi/features/profile/profile_cubit.dart';
import 'package:saathi/features/profile/profile_repository.dart';
import 'package:saathi/features/profile/profile_screen.dart';
import 'package:saathi/features/settings/locale_cubit.dart';
import 'package:saathi/i18n/strings.g.dart';
import 'package:uuid/uuid.dart';

void main() {
  late AppDatabase db;
  late ProfileRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = ProfileRepository(db, const Uuid());
  });

  tearDown(() => db.close());

  test('first read seeds the sample profile', () async {
    expect(await repo.watch().first, sampleProfile);
    expect(await db.meta('profile'), isNotNull);
  });

  test('add, edit and remove family; self cannot be removed', () async {
    await repo.watch().first;
    await repo.savePerson(
      const Person(
        id: '',
        name: 'Kamla Devi',
        relation: Relation.other,
        age: 70,
        gender: Gender.female,
      ),
    );
    var p = await repo.current();
    final kamla = p.people.last;
    expect([kamla.name, kamla.id.isNotEmpty], ['Kamla Devi', true]);
    await repo.savePerson(kamla.copyWith(age: 71));
    p = await repo.current();
    expect(p.people.where((x) => x.name == 'Kamla Devi').single.age, 71);
    await repo.removePerson(kamla.id);
    await repo.removePerson(p.self.id);
    p = await repo.current();
    expect(p.people.map((x) => x.name), [
      'Priya Sharma',
      'Ramesh Sharma',
      'Sunita Sharma',
      'Arjun Sharma',
    ]);
  });

  test('addresses can be added and removed; reset restores the sample', () async {
    await repo.saveAddress(
      const Address(id: '', label: 'Gym', line1: 'Plot 4', city: 'Gurugram', pincode: '122003'),
    );
    expect((await repo.current()).addressLabelled('gym')?.line1, 'Plot 4');
    await repo.removeAddress('a-home');
    expect((await repo.current()).addressLabelled('Home'), isNull);
    await repo.reset();
    expect(await repo.current(), sampleProfile);
  });

  test('profile lookups match names and labels loosely, and share only names and labels', () {
    expect(sampleProfile.personNamed('ramesh')?.relation, Relation.father);
    expect(sampleProfile.personNamed('Ramesh Kumar')?.relation, Relation.father);
    expect(sampleProfile.personNamed('Kamla'), isNull);
    expect(sampleProfile.addressLabelled("PAPA'S HOUSE")?.id, 'a-parents');
    final agent = sampleProfile.forAgent().toString();
    expect(agent, isNot(contains('122001')));
    expect(agent, isNot(contains('90000')));
  });

  testWidgets('profile screen lists people and addresses and edits a family member', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    LocaleSettings.setLocaleSync(AppLocale.en);
    final cubit = ProfileCubit(repo);
    addTearDown(cubit.close);
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: cubit),
            BlocProvider(create: (_) => LocaleCubit(db)),
          ],
          child: MaterialApp(theme: buildTheme(), home: const ProfileScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Priya Sharma'), findsOneWidget);
    expect(find.text('+91 90000 00001'), findsOneWidget);
    expect(find.text('Father, 64 yrs · Male'), findsOneWidget);
    expect(find.text('Flat 302, Sunrise Apartments, Sector 14, Gurugram 122001'), findsOneWidget);

    await tester.tap(find.text('Ramesh Sharma'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Age'), '65');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Father, 65 yrs · Male'), findsOneWidget);

    await tester.tap(find.text('Add address'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Label, e.g. Home'), 'Gym');
    await tester.enterText(find.widgetWithText(TextField, 'House or flat, building'), 'Plot 4');
    await tester.enterText(find.widgetWithText(TextField, 'Pincode'), '12');
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Enter a 6-digit pincode'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextField, 'Pincode'), '122003');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Plot 4, Gurugram 122003'), findsOneWidget);
  });
}
