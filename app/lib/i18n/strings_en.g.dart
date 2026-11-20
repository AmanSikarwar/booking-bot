///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'Saathi'
	String get appTitle => 'Saathi';

	late final Translations$chat$en chat = Translations$chat$en.internal(_root);
	late final Translations$status$en status = Translations$status$en.internal(_root);
	late final Translations$fixed$en fixed = Translations$fixed$en.internal(_root);
	late final Translations$offline$en offline = Translations$offline$en.internal(_root);
	late final Translations$package$en package = Translations$package$en.internal(_root);
	late final Translations$booking$en booking = Translations$booking$en.internal(_root);
	late final Translations$slots$en slots = Translations$slots$en.internal(_root);
	late final Translations$urgent$en urgent = Translations$urgent$en.internal(_root);
	late final Translations$actions$en actions = Translations$actions$en.internal(_root);
	late final Translations$bookings$en bookings = Translations$bookings$en.internal(_root);
	late final Translations$catalog$en catalog = Translations$catalog$en.internal(_root);
	Map<String, String> get categories => {
		'general': 'General',
		'diabetes': 'Diabetes',
		'thyroid': 'Thyroid',
		'heart': 'Heart',
		'liver': 'Liver',
		'kidney': 'Kidney',
		'vitamins': 'Vitamins',
		'women': 'Women',
		'senior': 'Senior',
		'fever': 'Fever',
		'fitness': 'Fitness',
	};
	late final Translations$windows$en windows = Translations$windows$en.internal(_root);
	late final Translations$settings$en settings = Translations$settings$en.internal(_root);
	late final Translations$tubes$en tubes = Translations$tubes$en.internal(_root);
	late final Translations$menu$en menu = Translations$menu$en.internal(_root);
	late final Translations$form$en form = Translations$form$en.internal(_root);
	late final Translations$followUps$en followUps = Translations$followUps$en.internal(_root);
	late final Translations$history$en history = Translations$history$en.internal(_root);
}

// Path: chat
class Translations$chat$en {
	Translations$chat$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Saathi'
	String get name => 'Saathi';

	/// en: 'Lab booking assistant'
	String get subtitle => 'Lab booking assistant';

	/// en: 'AI'
	String get aiBadge => 'AI';

	/// en: 'Hi, I'm Saathi from the lab. Tell me what you'd like to check, or how you've been feeling, and I'll suggest the right tests.'
	String get greeting => 'Hi, I\'m Saathi from the lab. Tell me what you\'d like to check, or how you\'ve been feeling, and I\'ll suggest the right tests.';

	/// en: 'Describe a symptom or a test'
	String get inputHint => 'Describe a symptom or a test';

	/// en: 'Send'
	String get send => 'Send';

	/// en: 'New chat'
	String get newChat => 'New chat';

	/// en: 'Finding packages…'
	String get findingPackages => 'Finding packages…';

	/// en: 'Booking your slot…'
	String get bookingSlot => 'Booking your slot…';

	/// en: 'Booking is paused in this chat. Start a new chat for a routine checkup.'
	String get flaggedNote => 'Booking is paused in this chat. Start a new chat for a routine checkup.';

	List<String> get suggestions => [
		'Check my thyroid',
		'Full body checkup',
		'Sugar test for Papa',
		'I feel tired all the time',
	];

	/// en: 'Try asking'
	String get tryAsking => 'Try asking';
}

// Path: status
class Translations$status$en {
	Translations$status$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Queued'
	String get queued => 'Queued';

	/// en: 'Sending'
	String get sending => 'Sending';

	/// en: 'Failed · tap to retry'
	String get failed => 'Failed · tap to retry';

	/// en: 'Interrupted · resuming'
	String get incomplete => 'Interrupted · resuming';
}

// Path: fixed
class Translations$fixed$en {
	Translations$fixed$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'This could need urgent medical care. Please don't wait for a lab test. Call 112 or 108 now, or go to the nearest emergency room.'
	String get urgentCare => 'This could need urgent medical care. Please don\'t wait for a lab test. Call 112 or 108 now, or go to the nearest emergency room.';

	/// en: 'I'm really sorry you're going through this. You don't have to face it alone. Tele-MANAS is free and available 24/7 at 14416.'
	String get crisisSupport => 'I\'m really sorry you\'re going through this. You don\'t have to face it alone. Tele-MANAS is free and available 24/7 at 14416.';

	/// en: 'You're offline. I'll send this as soon as you're back online.'
	String get queuedOffline => 'You\'re offline. I\'ll send this as soon as you\'re back online.';

	/// en: 'I'm taking a short break and will be back at 5:30 am. You can still browse all packages meanwhile.'
	String get quotaExhausted => 'I\'m taking a short break and will be back at 5:30 am. You can still browse all packages meanwhile.';

	/// en: 'You've reached today's message limit. I'll be back at 5:30 am. You can still browse all packages meanwhile.'
	String get userLimit => 'You\'ve reached today\'s message limit. I\'ll be back at 5:30 am. You can still browse all packages meanwhile.';

	/// en: 'That didn't go through. Trying again…'
	String get errorRetrying => 'That didn\'t go through. Trying again…';
}

// Path: offline
class Translations$offline$en {
	Translations$offline$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Offline · messages will send when you're back'
	String get banner => 'Offline · messages will send when you\'re back';
}

// Path: package
class Translations$package$en {
	Translations$package$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '{n} tests'
	String tests({required Object n}) => '${n} tests';

	/// en: 'Fasting {h} hrs'
	String fasting({required Object h}) => 'Fasting ${h} hrs';

	/// en: 'No fasting'
	String get noFasting => 'No fasting';

	/// en: 'Report in {h} hrs'
	String report({required Object h}) => 'Report in ${h} hrs';

	/// en: 'Book home collection'
	String get book => 'Book home collection';

	/// en: 'View tests'
	String get viewTests => 'View tests';

	/// en: 'Hide tests'
	String get hideTests => 'Hide tests';

	/// en: 'Top match'
	String get topMatch => 'Top match';

	/// en: '{n}% off'
	String off({required Object n}) => '${n}% off';

	/// en: 'View all {n} tests'
	String showAll({required Object n}) => 'View all ${n} tests';

	/// en: 'Show fewer tests'
	String get showLess => 'Show fewer tests';
}

// Path: booking
class Translations$booking$en {
	Translations$booking$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Booking confirmed'
	String get confirmed => 'Booking confirmed';

	/// en: 'Saved offline'
	String get savedOffline => 'Saved offline';

	/// en: 'View all bookings'
	String get viewAll => 'View all bookings';

	/// en: 'for {name}'
	String forPatient({required Object name}) => 'for ${name}';

	/// en: 'Copy reference'
	String get copy => 'Copy reference';

	/// en: 'Booking reference copied'
	String get copied => 'Booking reference copied';

	/// en: 'Collector arrives'
	String get collector => 'Collector arrives';
}

// Path: slots
class Translations$slots$en {
	Translations$slots$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'That slot is full. Closest open slots:'
	String get full => 'That slot is full. Closest open slots:';
}

// Path: urgent
class Translations$urgent$en {
	Translations$urgent$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Call 112'
	String get call112 => 'Call 112';

	/// en: 'Call 108'
	String get call108 => 'Call 108';

	/// en: 'Call 14416'
	String get call14416 => 'Call 14416';

	/// en: 'I understand'
	String get understood => 'I understand';
}

// Path: actions
class Translations$actions$en {
	Translations$actions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Book {name} ({id}) on {date} {window} at {address} for {patient}.'
	String bookSlot({required Object name, required Object id, required Object date, required Object window, required Object address, required Object patient}) => 'Book ${name} (${id}) on ${date} ${window} at ${address} for ${patient}.';
}

// Path: bookings
class Translations$bookings$en {
	Translations$bookings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'My bookings'
	String get title => 'My bookings';

	/// en: 'No bookings yet. Ask Saathi to book a home collection.'
	String get empty => 'No bookings yet. Ask Saathi to book a home collection.';
}

// Path: catalog
class Translations$catalog$en {
	Translations$catalog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'All packages'
	String get title => 'All packages';

	/// en: 'All'
	String get all => 'All';

	/// en: 'Ask Saathi'
	String get askSaathi => 'Ask Saathi';

	/// en: 'Browse all packages'
	String get browse => 'Browse all packages';

	/// en: 'Search tests or packages'
	String get search => 'Search tests or packages';

	/// en: 'No packages match “{q}”. Try another word or ask Saathi.'
	String noResults({required Object q}) => 'No packages match “${q}”. Try another word or ask Saathi.';
}

// Path: windows
class Translations$windows$en {
	Translations$windows$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '7–9 am'
	String get w0709 => '7–9 am';

	/// en: '9–11 am'
	String get w0911 => '9–11 am';

	/// en: '11 am–1 pm'
	String get w1113 => '11 am–1 pm';

	/// en: '4–6 pm'
	String get w1618 => '4–6 pm';
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'हिन्दी'
	String get switchTo => 'हिन्दी';
}

// Path: tubes
class Translations$tubes$en {
	Translations$tubes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sample tubes: {names}'
	String label({required Object names}) => 'Sample tubes: ${names}';

	/// en: 'lavender'
	String get lavender => 'lavender';

	/// en: 'grey'
	String get grey => 'grey';

	/// en: 'gold'
	String get gold => 'gold';

	/// en: 'urine cup'
	String get urine => 'urine cup';

	/// en: '(one) {{n} tube} (other) {{n} tubes}'
	String count({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${n} tube',
		other: '${n} tubes',
	);

	/// en: 'urine cup'
	String get urineCup => 'urine cup';

	/// en: '{tubes} + {extra}'
	String and({required Object tubes, required Object extra}) => '${tubes} + ${extra}';
}

// Path: menu
class Translations$menu$en {
	Translations$menu$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'New chat'
	String get newChat => 'New chat';

	/// en: 'All packages'
	String get packages => 'All packages';

	/// en: 'My bookings'
	String get bookings => 'My bookings';

	/// en: 'Chats'
	String get history => 'Chats';
}

// Path: form
class Translations$form$en {
	Translations$form$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Book home collection'
	String get title => 'Book home collection';

	/// en: 'Date'
	String get date => 'Date';

	/// en: 'Time window'
	String get time => 'Time window';

	/// en: 'Collection address'
	String get address => 'Collection address';

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Office'
	String get office => 'Office';

	/// en: 'Other'
	String get other => 'Other';

	/// en: 'e.g. Papa's house'
	String get otherHint => 'e.g. Papa\'s house';

	/// en: 'Patient name'
	String get patient => 'Patient name';

	/// en: 'Who is the sample for?'
	String get patientHint => 'Who is the sample for?';

	/// en: 'Today'
	String get today => 'Today';

	/// en: 'Tomorrow'
	String get tomorrow => 'Tomorrow';

	/// en: 'Full'
	String get full => 'Full';

	/// en: 'Fast for {h} hours before collection'
	String fasting({required Object h}) => 'Fast for ${h} hours before collection';

	/// en: 'Confirm booking'
	String get confirm => 'Confirm booking';

	/// en: 'Required'
	String get required => 'Required';

	/// en: 'Pick a date'
	String get pickDate => 'Pick a date';

	/// en: 'Pick a time window'
	String get pickTime => 'Pick a time window';

	/// en: 'Details sent'
	String get sent => 'Details sent';
}

// Path: followUps
class Translations$followUps$en {
	Translations$followUps$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Book {name}'
	String book({required Object name}) => 'Book ${name}';

	/// en: 'Something cheaper'
	String get cheaper => 'Something cheaper';

	/// en: 'Show me something cheaper'
	String get cheaperText => 'Show me something cheaper';

	/// en: 'No fasting needed'
	String get noFasting => 'No fasting needed';

	/// en: 'Which of these need no fasting?'
	String get noFastingText => 'Which of these need no fasting?';

	/// en: 'Book another test'
	String get another => 'Book another test';

	/// en: 'I want to book another test'
	String get anotherText => 'I want to book another test';

	/// en: 'My bookings'
	String get bookings => 'My bookings';

	/// en: 'How do I prepare?'
	String get prepare => 'How do I prepare?';

	/// en: 'How should I prepare for the sample collection?'
	String get prepareText => 'How should I prepare for the sample collection?';

	/// en: 'Try another day'
	String get anotherDay => 'Try another day';

	/// en: 'Show me open slots on another day'
	String get anotherDayText => 'Show me open slots on another day';

	/// en: 'Suggest tests for me'
	String get suggest => 'Suggest tests for me';

	/// en: 'Which tests would you suggest for a routine checkup?'
	String get suggestText => 'Which tests would you suggest for a routine checkup?';

	/// en: 'Full body checkup'
	String get fullBody => 'Full body checkup';

	/// en: 'Browse all packages'
	String get browse => 'Browse all packages';
}

// Path: history
class Translations$history$en {
	Translations$history$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Chats'
	String get title => 'Chats';

	/// en: 'Your chats with Saathi will appear here.'
	String get empty => 'Your chats with Saathi will appear here.';

	/// en: 'Current'
	String get current => 'Current';

	/// en: 'Booking paused'
	String get paused => 'Booking paused';

	/// en: 'Today, {time}'
	String today({required Object time}) => 'Today, ${time}';

	/// en: 'Yesterday'
	String get yesterday => 'Yesterday';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appTitle' => 'Saathi',
			'chat.name' => 'Saathi',
			'chat.subtitle' => 'Lab booking assistant',
			'chat.aiBadge' => 'AI',
			'chat.greeting' => 'Hi, I\'m Saathi from the lab. Tell me what you\'d like to check, or how you\'ve been feeling, and I\'ll suggest the right tests.',
			'chat.inputHint' => 'Describe a symptom or a test',
			'chat.send' => 'Send',
			'chat.newChat' => 'New chat',
			'chat.findingPackages' => 'Finding packages…',
			'chat.bookingSlot' => 'Booking your slot…',
			'chat.flaggedNote' => 'Booking is paused in this chat. Start a new chat for a routine checkup.',
			'chat.suggestions.0' => 'Check my thyroid',
			'chat.suggestions.1' => 'Full body checkup',
			'chat.suggestions.2' => 'Sugar test for Papa',
			'chat.suggestions.3' => 'I feel tired all the time',
			'chat.tryAsking' => 'Try asking',
			'status.queued' => 'Queued',
			'status.sending' => 'Sending',
			'status.failed' => 'Failed · tap to retry',
			'status.incomplete' => 'Interrupted · resuming',
			'fixed.urgentCare' => 'This could need urgent medical care. Please don\'t wait for a lab test. Call 112 or 108 now, or go to the nearest emergency room.',
			'fixed.crisisSupport' => 'I\'m really sorry you\'re going through this. You don\'t have to face it alone. Tele-MANAS is free and available 24/7 at 14416.',
			'fixed.queuedOffline' => 'You\'re offline. I\'ll send this as soon as you\'re back online.',
			'fixed.quotaExhausted' => 'I\'m taking a short break and will be back at 5:30 am. You can still browse all packages meanwhile.',
			'fixed.userLimit' => 'You\'ve reached today\'s message limit. I\'ll be back at 5:30 am. You can still browse all packages meanwhile.',
			'fixed.errorRetrying' => 'That didn\'t go through. Trying again…',
			'offline.banner' => 'Offline · messages will send when you\'re back',
			'package.tests' => ({required Object n}) => '${n} tests',
			'package.fasting' => ({required Object h}) => 'Fasting ${h} hrs',
			'package.noFasting' => 'No fasting',
			'package.report' => ({required Object h}) => 'Report in ${h} hrs',
			'package.book' => 'Book home collection',
			'package.viewTests' => 'View tests',
			'package.hideTests' => 'Hide tests',
			'package.topMatch' => 'Top match',
			'package.off' => ({required Object n}) => '${n}% off',
			'package.showAll' => ({required Object n}) => 'View all ${n} tests',
			'package.showLess' => 'Show fewer tests',
			'booking.confirmed' => 'Booking confirmed',
			'booking.savedOffline' => 'Saved offline',
			'booking.viewAll' => 'View all bookings',
			'booking.forPatient' => ({required Object name}) => 'for ${name}',
			'booking.copy' => 'Copy reference',
			'booking.copied' => 'Booking reference copied',
			'booking.collector' => 'Collector arrives',
			'slots.full' => 'That slot is full. Closest open slots:',
			'urgent.call112' => 'Call 112',
			'urgent.call108' => 'Call 108',
			'urgent.call14416' => 'Call 14416',
			'urgent.understood' => 'I understand',
			'actions.bookSlot' => ({required Object name, required Object id, required Object date, required Object window, required Object address, required Object patient}) => 'Book ${name} (${id}) on ${date} ${window} at ${address} for ${patient}.',
			'bookings.title' => 'My bookings',
			'bookings.empty' => 'No bookings yet. Ask Saathi to book a home collection.',
			'catalog.title' => 'All packages',
			'catalog.all' => 'All',
			'catalog.askSaathi' => 'Ask Saathi',
			'catalog.browse' => 'Browse all packages',
			'catalog.search' => 'Search tests or packages',
			'catalog.noResults' => ({required Object q}) => 'No packages match “${q}”. Try another word or ask Saathi.',
			'categories.general' => 'General',
			'categories.diabetes' => 'Diabetes',
			'categories.thyroid' => 'Thyroid',
			'categories.heart' => 'Heart',
			'categories.liver' => 'Liver',
			'categories.kidney' => 'Kidney',
			'categories.vitamins' => 'Vitamins',
			'categories.women' => 'Women',
			'categories.senior' => 'Senior',
			'categories.fever' => 'Fever',
			'categories.fitness' => 'Fitness',
			'windows.w0709' => '7–9 am',
			'windows.w0911' => '9–11 am',
			'windows.w1113' => '11 am–1 pm',
			'windows.w1618' => '4–6 pm',
			'settings.language' => 'Language',
			'settings.switchTo' => 'हिन्दी',
			'tubes.label' => ({required Object names}) => 'Sample tubes: ${names}',
			'tubes.lavender' => 'lavender',
			'tubes.grey' => 'grey',
			'tubes.gold' => 'gold',
			'tubes.urine' => 'urine cup',
			'tubes.count' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '${n} tube', other: '${n} tubes', ), 
			'tubes.urineCup' => 'urine cup',
			'tubes.and' => ({required Object tubes, required Object extra}) => '${tubes} + ${extra}',
			'menu.newChat' => 'New chat',
			'menu.packages' => 'All packages',
			'menu.bookings' => 'My bookings',
			'menu.history' => 'Chats',
			'form.title' => 'Book home collection',
			'form.date' => 'Date',
			'form.time' => 'Time window',
			'form.address' => 'Collection address',
			'form.home' => 'Home',
			'form.office' => 'Office',
			'form.other' => 'Other',
			'form.otherHint' => 'e.g. Papa\'s house',
			'form.patient' => 'Patient name',
			'form.patientHint' => 'Who is the sample for?',
			'form.today' => 'Today',
			'form.tomorrow' => 'Tomorrow',
			'form.full' => 'Full',
			'form.fasting' => ({required Object h}) => 'Fast for ${h} hours before collection',
			'form.confirm' => 'Confirm booking',
			'form.required' => 'Required',
			'form.pickDate' => 'Pick a date',
			'form.pickTime' => 'Pick a time window',
			'form.sent' => 'Details sent',
			'followUps.book' => ({required Object name}) => 'Book ${name}',
			'followUps.cheaper' => 'Something cheaper',
			'followUps.cheaperText' => 'Show me something cheaper',
			'followUps.noFasting' => 'No fasting needed',
			'followUps.noFastingText' => 'Which of these need no fasting?',
			'followUps.another' => 'Book another test',
			'followUps.anotherText' => 'I want to book another test',
			'followUps.bookings' => 'My bookings',
			'followUps.prepare' => 'How do I prepare?',
			'followUps.prepareText' => 'How should I prepare for the sample collection?',
			'followUps.anotherDay' => 'Try another day',
			'followUps.anotherDayText' => 'Show me open slots on another day',
			'followUps.suggest' => 'Suggest tests for me',
			'followUps.suggestText' => 'Which tests would you suggest for a routine checkup?',
			'followUps.fullBody' => 'Full body checkup',
			'followUps.browse' => 'Browse all packages',
			'history.title' => 'Chats',
			'history.empty' => 'Your chats with Saathi will appear here.',
			'history.current' => 'Current',
			'history.paused' => 'Booking paused',
			'history.today' => ({required Object time}) => 'Today, ${time}',
			'history.yesterday' => 'Yesterday',
			_ => null,
		};
	}
}
