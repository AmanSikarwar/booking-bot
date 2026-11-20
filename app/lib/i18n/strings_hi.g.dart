///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsHi extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsHi({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.hi,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <hi>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsHi _root = this; // ignore: unused_field

	@override 
	TranslationsHi $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsHi(meta: meta ?? this.$meta);

	// Translations
	@override String get appTitle => 'साथी';
	@override late final _Translations$chat$hi chat = _Translations$chat$hi._(_root);
	@override late final _Translations$status$hi status = _Translations$status$hi._(_root);
	@override late final _Translations$fixed$hi fixed = _Translations$fixed$hi._(_root);
	@override late final _Translations$offline$hi offline = _Translations$offline$hi._(_root);
	@override late final _Translations$package$hi package = _Translations$package$hi._(_root);
	@override late final _Translations$booking$hi booking = _Translations$booking$hi._(_root);
	@override late final _Translations$slots$hi slots = _Translations$slots$hi._(_root);
	@override late final _Translations$urgent$hi urgent = _Translations$urgent$hi._(_root);
	@override late final _Translations$actions$hi actions = _Translations$actions$hi._(_root);
	@override late final _Translations$bookings$hi bookings = _Translations$bookings$hi._(_root);
	@override late final _Translations$catalog$hi catalog = _Translations$catalog$hi._(_root);
	@override Map<String, String> get categories => {
		'general': 'सामान्य',
		'diabetes': 'डायबिटीज़',
		'thyroid': 'थायरॉइड',
		'heart': 'दिल',
		'liver': 'लिवर',
		'kidney': 'किडनी',
		'vitamins': 'विटामिन',
		'women': 'महिला',
		'senior': 'बुज़ुर्ग',
		'fever': 'बुखार',
		'fitness': 'फिटनेस',
	};
	@override late final _Translations$windows$hi windows = _Translations$windows$hi._(_root);
	@override late final _Translations$settings$hi settings = _Translations$settings$hi._(_root);
	@override late final _Translations$tubes$hi tubes = _Translations$tubes$hi._(_root);
	@override late final _Translations$menu$hi menu = _Translations$menu$hi._(_root);
	@override late final _Translations$form$hi form = _Translations$form$hi._(_root);
	@override late final _Translations$followUps$hi followUps = _Translations$followUps$hi._(_root);
	@override late final _Translations$history$hi history = _Translations$history$hi._(_root);
	@override late final _Translations$nav$hi nav = _Translations$nav$hi._(_root);
	@override late final _Translations$details$hi details = _Translations$details$hi._(_root);
}

// Path: chat
class _Translations$chat$hi extends Translations$chat$en {
	_Translations$chat$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get name => 'साथी';
	@override String get subtitle => 'लैब बुकिंग असिस्टेंट';
	@override String get aiBadge => 'AI';
	@override String get greeting => 'नमस्ते, मैं लैब से साथी हूँ। बताइए आप क्या जाँच करवाना चाहते हैं, या आपकी तबीयत कैसी है, मैं सही टेस्ट सुझाऊँगा।';
	@override String get inputHint => 'कोई लक्षण या टेस्ट लिखें';
	@override String get send => 'भेजें';
	@override String get newChat => 'नई चैट';
	@override String get findingPackages => 'पैकेज ढूँढ रहा हूँ…';
	@override String get bookingSlot => 'स्लॉट बुक कर रहा हूँ…';
	@override String get flaggedNote => 'इस चैट में बुकिंग रोकी गई है। रूटीन जाँच के लिए नई चैट शुरू करें।';
	@override List<String> get suggestions => [
		'थायरॉइड की जाँच',
		'फुल बॉडी चेकअप',
		'पापा के लिए शुगर टेस्ट',
		'मुझे हर समय थकान रहती है',
	];
	@override String get tryAsking => 'ऐसे पूछें';
}

// Path: status
class _Translations$status$hi extends Translations$status$en {
	_Translations$status$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get queued => 'कतार में';
	@override String get sending => 'भेज रहा हूँ';
	@override String get failed => 'नहीं भेजा गया · दोबारा भेजने के लिए टैप करें';
	@override String get incomplete => 'रुक गया · फिर से जुड़ रहा हूँ';
}

// Path: fixed
class _Translations$fixed$hi extends Translations$fixed$en {
	_Translations$fixed$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get urgentCare => 'यह गंभीर हो सकता है। कृपया लैब टेस्ट का इंतज़ार न करें। अभी 112 या 108 पर कॉल करें, या नज़दीकी इमरजेंसी में जाएँ।';
	@override String get crisisSupport => 'मुझे बहुत दुख है कि आप इससे गुज़र रहे हैं। आप अकेले नहीं हैं। Tele-MANAS पर 14416 पर 24 घंटे मुफ़्त बात कर सकते हैं।';
	@override String get queuedOffline => 'आप ऑफ़लाइन हैं। इंटरनेट आते ही मैं यह भेज दूँगा।';
	@override String get quotaExhausted => 'मैं थोड़ी देर के लिए रुका हूँ, सुबह 5:30 बजे वापस आऊँगा। तब तक आप सभी पैकेज देख सकते हैं।';
	@override String get userLimit => 'आज के संदेशों की सीमा पूरी हो गई है। मैं सुबह 5:30 बजे वापस आऊँगा। तब तक आप सभी पैकेज देख सकते हैं।';
	@override String get errorRetrying => 'यह नहीं पहुँचा। फिर से कोशिश कर रहा हूँ…';
}

// Path: offline
class _Translations$offline$hi extends Translations$offline$en {
	_Translations$offline$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get banner => 'ऑफ़लाइन · इंटरनेट आने पर संदेश भेजे जाएँगे';
}

// Path: package
class _Translations$package$hi extends Translations$package$en {
	_Translations$package$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String tests({required Object n}) => '${n} टेस्ट';
	@override String fasting({required Object h}) => '${h} घंटे खाली पेट';
	@override String get noFasting => 'खाली पेट ज़रूरी नहीं';
	@override String report({required Object h}) => 'रिपोर्ट ${h} घंटे में';
	@override String get book => 'घर पर सैंपल बुक करें';
	@override String get viewTests => 'टेस्ट देखें';
	@override String get hideTests => 'टेस्ट छिपाएँ';
	@override String get topMatch => 'सबसे सही';
	@override String off({required Object n}) => '${n}% छूट';
}

// Path: booking
class _Translations$booking$hi extends Translations$booking$en {
	_Translations$booking$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get confirmed => 'बुकिंग पक्की';
	@override String get savedOffline => 'ऑफ़लाइन सेव';
	@override String get viewAll => 'सभी बुकिंग देखें';
	@override String forPatient({required Object name}) => '${name} के लिए';
	@override String get copy => 'रेफ़रेंस कॉपी करें';
	@override String get copied => 'बुकिंग रेफ़रेंस कॉपी हो गया';
	@override String get collector => 'सैंपल लेने वाले आएँगे';
}

// Path: slots
class _Translations$slots$hi extends Translations$slots$en {
	_Translations$slots$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get full => 'वह स्लॉट भर गया है। सबसे नज़दीकी खाली स्लॉट:';
}

// Path: urgent
class _Translations$urgent$hi extends Translations$urgent$en {
	_Translations$urgent$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get call112 => '112 पर कॉल करें';
	@override String get call108 => '108 पर कॉल करें';
	@override String get call14416 => '14416 पर कॉल करें';
	@override String get understood => 'समझ आया';
}

// Path: actions
class _Translations$actions$hi extends Translations$actions$en {
	_Translations$actions$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String bookSlot({required Object name, required Object id, required Object date, required Object window, required Object address, required Object patient}) => '${name} (${id}) ${date} को ${window} बजे, ${address} पर, ${patient} के लिए बुक करें।';
}

// Path: bookings
class _Translations$bookings$hi extends Translations$bookings$en {
	_Translations$bookings$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'मेरी बुकिंग';
	@override String get empty => 'अभी कोई बुकिंग नहीं है। घर से सैंपल के लिए साथी से कहें।';
}

// Path: catalog
class _Translations$catalog$hi extends Translations$catalog$en {
	_Translations$catalog$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'सभी पैकेज';
	@override String get all => 'सभी';
	@override String get askSaathi => 'साथी से पूछें';
	@override String get browse => 'सभी पैकेज देखें';
	@override String get search => 'टेस्ट या पैकेज खोजें';
	@override String noResults({required Object q}) => '“${q}” से कोई पैकेज नहीं मिला। कोई दूसरा शब्द लिखें या साथी से पूछें।';
}

// Path: windows
class _Translations$windows$hi extends Translations$windows$en {
	_Translations$windows$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get w0709 => 'सुबह 7–9';
	@override String get w0911 => 'सुबह 9–11';
	@override String get w1113 => 'सुबह 11–दोपहर 1';
	@override String get w1618 => 'शाम 4–6';
}

// Path: settings
class _Translations$settings$hi extends Translations$settings$en {
	_Translations$settings$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get language => 'भाषा';
	@override String get switchTo => 'English';
}

// Path: tubes
class _Translations$tubes$hi extends Translations$tubes$en {
	_Translations$tubes$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String label({required Object names}) => 'सैंपल ट्यूब: ${names}';
	@override String get lavender => 'बैंगनी';
	@override String get grey => 'स्लेटी';
	@override String get gold => 'सुनहरी';
	@override String get urine => 'यूरिन कप';
	@override String count({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('hi'))(n,
		one: '${n} ट्यूब',
		other: '${n} ट्यूब',
	);
	@override String get urineCup => 'यूरिन कप';
	@override String and({required Object tubes, required Object extra}) => '${tubes} + ${extra}';
}

// Path: menu
class _Translations$menu$hi extends Translations$menu$en {
	_Translations$menu$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get newChat => 'नई चैट';
	@override String get packages => 'सभी पैकेज';
	@override String get bookings => 'मेरी बुकिंग';
	@override String get history => 'इतिहास';
}

// Path: form
class _Translations$form$hi extends Translations$form$en {
	_Translations$form$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'घर से सैंपल बुक करें';
	@override String get date => 'तारीख़';
	@override String get time => 'समय';
	@override String get address => 'सैंपल का पता';
	@override String get home => 'घर';
	@override String get office => 'ऑफ़िस';
	@override String get other => 'दूसरा';
	@override String get otherHint => 'जैसे पापा का घर';
	@override String get patient => 'मरीज़ का नाम';
	@override String get patientHint => 'सैंपल किसका है?';
	@override String get today => 'आज';
	@override String get tomorrow => 'कल';
	@override String get full => 'भरा';
	@override String fasting({required Object h}) => 'सैंपल से पहले ${h} घंटे खाली पेट रहें';
	@override String get confirm => 'बुकिंग पक्की करें';
	@override String get required => 'ज़रूरी है';
	@override String get pickDate => 'तारीख़ चुनें';
	@override String get pickTime => 'समय चुनें';
	@override String get sent => 'जानकारी भेज दी';
}

// Path: followUps
class _Translations$followUps$hi extends Translations$followUps$en {
	_Translations$followUps$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String book({required Object name}) => '${name} बुक करें';
	@override String get cheaper => 'कुछ सस्ता';
	@override String get cheaperText => 'मुझे कुछ सस्ता दिखाइए';
	@override String get noFasting => 'बिना खाली पेट वाले';
	@override String get noFastingText => 'इनमें से किसके लिए खाली पेट ज़रूरी नहीं है?';
	@override String get another => 'एक और टेस्ट बुक करें';
	@override String get anotherText => 'मुझे एक और टेस्ट बुक करना है';
	@override String get bookings => 'मेरी बुकिंग';
	@override String get prepare => 'तैयारी कैसे करूँ?';
	@override String get prepareText => 'सैंपल कलेक्शन के लिए तैयारी कैसे करूँ?';
	@override String get anotherDay => 'दूसरा दिन';
	@override String get suggest => 'मेरे लिए टेस्ट सुझाएँ';
	@override String get suggestText => 'रूटीन चेकअप के लिए आप कौन से टेस्ट सुझाएँगे?';
	@override String get fullBody => 'फुल बॉडी चेकअप';
	@override String get browse => 'सभी पैकेज देखें';
}

// Path: history
class _Translations$history$hi extends Translations$history$en {
	_Translations$history$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'इतिहास';
	@override String get empty => 'साथी के साथ आपकी चैट यहाँ दिखेंगी।';
	@override String get current => 'अभी की';
	@override String get paused => 'बुकिंग रुकी है';
	@override String today({required Object time}) => 'आज, ${time}';
	@override String get yesterday => 'कल';
}

// Path: nav
class _Translations$nav$hi extends Translations$nav$en {
	_Translations$nav$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get chat => 'चैट';
	@override String get history => 'इतिहास';
	@override String get bookings => 'बुकिंग';
	@override String get packages => 'पैकेज';
	@override String get back => 'चैट पर वापस';
}

// Path: details
class _Translations$details$hi extends Translations$details$en {
	_Translations$details$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get view => 'जानकारी';
	@override String get about => 'पैकेज के बारे में';
	@override String get facts => 'एक नज़र में';
	@override String get included => 'इसमें शामिल';
	@override String get prep => 'तैयारी कैसे करें';
	@override String fastPrep({required Object h}) => 'सैंपल से पहले ${h} घंटे खाली पेट रहें। सादा पानी पी सकते हैं।';
	@override String get noFastPrep => 'खाली पेट रहने की ज़रूरत नहीं। आप हमेशा की तरह खा-पी सकते हैं।';
	@override String get sample => 'सैंपल';
	@override String get blood => 'खून';
	@override String get urine => 'यूरिन';
	@override String get doctorNote => 'इन टेस्ट से निदान नहीं होता। रिपोर्ट का मतलब डॉक्टर बता सकते हैं।';
	@override String get close => 'बंद करें';
	@override String more({required Object n}) => '+${n} और';
}

/// The flat map containing all translations for locale <hi>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsHi {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appTitle' => 'साथी',
			'chat.name' => 'साथी',
			'chat.subtitle' => 'लैब बुकिंग असिस्टेंट',
			'chat.aiBadge' => 'AI',
			'chat.greeting' => 'नमस्ते, मैं लैब से साथी हूँ। बताइए आप क्या जाँच करवाना चाहते हैं, या आपकी तबीयत कैसी है, मैं सही टेस्ट सुझाऊँगा।',
			'chat.inputHint' => 'कोई लक्षण या टेस्ट लिखें',
			'chat.send' => 'भेजें',
			'chat.newChat' => 'नई चैट',
			'chat.findingPackages' => 'पैकेज ढूँढ रहा हूँ…',
			'chat.bookingSlot' => 'स्लॉट बुक कर रहा हूँ…',
			'chat.flaggedNote' => 'इस चैट में बुकिंग रोकी गई है। रूटीन जाँच के लिए नई चैट शुरू करें।',
			'chat.suggestions.0' => 'थायरॉइड की जाँच',
			'chat.suggestions.1' => 'फुल बॉडी चेकअप',
			'chat.suggestions.2' => 'पापा के लिए शुगर टेस्ट',
			'chat.suggestions.3' => 'मुझे हर समय थकान रहती है',
			'chat.tryAsking' => 'ऐसे पूछें',
			'status.queued' => 'कतार में',
			'status.sending' => 'भेज रहा हूँ',
			'status.failed' => 'नहीं भेजा गया · दोबारा भेजने के लिए टैप करें',
			'status.incomplete' => 'रुक गया · फिर से जुड़ रहा हूँ',
			'fixed.urgentCare' => 'यह गंभीर हो सकता है। कृपया लैब टेस्ट का इंतज़ार न करें। अभी 112 या 108 पर कॉल करें, या नज़दीकी इमरजेंसी में जाएँ।',
			'fixed.crisisSupport' => 'मुझे बहुत दुख है कि आप इससे गुज़र रहे हैं। आप अकेले नहीं हैं। Tele-MANAS पर 14416 पर 24 घंटे मुफ़्त बात कर सकते हैं।',
			'fixed.queuedOffline' => 'आप ऑफ़लाइन हैं। इंटरनेट आते ही मैं यह भेज दूँगा।',
			'fixed.quotaExhausted' => 'मैं थोड़ी देर के लिए रुका हूँ, सुबह 5:30 बजे वापस आऊँगा। तब तक आप सभी पैकेज देख सकते हैं।',
			'fixed.userLimit' => 'आज के संदेशों की सीमा पूरी हो गई है। मैं सुबह 5:30 बजे वापस आऊँगा। तब तक आप सभी पैकेज देख सकते हैं।',
			'fixed.errorRetrying' => 'यह नहीं पहुँचा। फिर से कोशिश कर रहा हूँ…',
			'offline.banner' => 'ऑफ़लाइन · इंटरनेट आने पर संदेश भेजे जाएँगे',
			'package.tests' => ({required Object n}) => '${n} टेस्ट',
			'package.fasting' => ({required Object h}) => '${h} घंटे खाली पेट',
			'package.noFasting' => 'खाली पेट ज़रूरी नहीं',
			'package.report' => ({required Object h}) => 'रिपोर्ट ${h} घंटे में',
			'package.book' => 'घर पर सैंपल बुक करें',
			'package.viewTests' => 'टेस्ट देखें',
			'package.hideTests' => 'टेस्ट छिपाएँ',
			'package.topMatch' => 'सबसे सही',
			'package.off' => ({required Object n}) => '${n}% छूट',
			'booking.confirmed' => 'बुकिंग पक्की',
			'booking.savedOffline' => 'ऑफ़लाइन सेव',
			'booking.viewAll' => 'सभी बुकिंग देखें',
			'booking.forPatient' => ({required Object name}) => '${name} के लिए',
			'booking.copy' => 'रेफ़रेंस कॉपी करें',
			'booking.copied' => 'बुकिंग रेफ़रेंस कॉपी हो गया',
			'booking.collector' => 'सैंपल लेने वाले आएँगे',
			'slots.full' => 'वह स्लॉट भर गया है। सबसे नज़दीकी खाली स्लॉट:',
			'urgent.call112' => '112 पर कॉल करें',
			'urgent.call108' => '108 पर कॉल करें',
			'urgent.call14416' => '14416 पर कॉल करें',
			'urgent.understood' => 'समझ आया',
			'actions.bookSlot' => ({required Object name, required Object id, required Object date, required Object window, required Object address, required Object patient}) => '${name} (${id}) ${date} को ${window} बजे, ${address} पर, ${patient} के लिए बुक करें।',
			'bookings.title' => 'मेरी बुकिंग',
			'bookings.empty' => 'अभी कोई बुकिंग नहीं है। घर से सैंपल के लिए साथी से कहें।',
			'catalog.title' => 'सभी पैकेज',
			'catalog.all' => 'सभी',
			'catalog.askSaathi' => 'साथी से पूछें',
			'catalog.browse' => 'सभी पैकेज देखें',
			'catalog.search' => 'टेस्ट या पैकेज खोजें',
			'catalog.noResults' => ({required Object q}) => '“${q}” से कोई पैकेज नहीं मिला। कोई दूसरा शब्द लिखें या साथी से पूछें।',
			'categories.general' => 'सामान्य',
			'categories.diabetes' => 'डायबिटीज़',
			'categories.thyroid' => 'थायरॉइड',
			'categories.heart' => 'दिल',
			'categories.liver' => 'लिवर',
			'categories.kidney' => 'किडनी',
			'categories.vitamins' => 'विटामिन',
			'categories.women' => 'महिला',
			'categories.senior' => 'बुज़ुर्ग',
			'categories.fever' => 'बुखार',
			'categories.fitness' => 'फिटनेस',
			'windows.w0709' => 'सुबह 7–9',
			'windows.w0911' => 'सुबह 9–11',
			'windows.w1113' => 'सुबह 11–दोपहर 1',
			'windows.w1618' => 'शाम 4–6',
			'settings.language' => 'भाषा',
			'settings.switchTo' => 'English',
			'tubes.label' => ({required Object names}) => 'सैंपल ट्यूब: ${names}',
			'tubes.lavender' => 'बैंगनी',
			'tubes.grey' => 'स्लेटी',
			'tubes.gold' => 'सुनहरी',
			'tubes.urine' => 'यूरिन कप',
			'tubes.count' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('hi'))(n, one: '${n} ट्यूब', other: '${n} ट्यूब', ), 
			'tubes.urineCup' => 'यूरिन कप',
			'tubes.and' => ({required Object tubes, required Object extra}) => '${tubes} + ${extra}',
			'menu.newChat' => 'नई चैट',
			'menu.packages' => 'सभी पैकेज',
			'menu.bookings' => 'मेरी बुकिंग',
			'menu.history' => 'इतिहास',
			'form.title' => 'घर से सैंपल बुक करें',
			'form.date' => 'तारीख़',
			'form.time' => 'समय',
			'form.address' => 'सैंपल का पता',
			'form.home' => 'घर',
			'form.office' => 'ऑफ़िस',
			'form.other' => 'दूसरा',
			'form.otherHint' => 'जैसे पापा का घर',
			'form.patient' => 'मरीज़ का नाम',
			'form.patientHint' => 'सैंपल किसका है?',
			'form.today' => 'आज',
			'form.tomorrow' => 'कल',
			'form.full' => 'भरा',
			'form.fasting' => ({required Object h}) => 'सैंपल से पहले ${h} घंटे खाली पेट रहें',
			'form.confirm' => 'बुकिंग पक्की करें',
			'form.required' => 'ज़रूरी है',
			'form.pickDate' => 'तारीख़ चुनें',
			'form.pickTime' => 'समय चुनें',
			'form.sent' => 'जानकारी भेज दी',
			'followUps.book' => ({required Object name}) => '${name} बुक करें',
			'followUps.cheaper' => 'कुछ सस्ता',
			'followUps.cheaperText' => 'मुझे कुछ सस्ता दिखाइए',
			'followUps.noFasting' => 'बिना खाली पेट वाले',
			'followUps.noFastingText' => 'इनमें से किसके लिए खाली पेट ज़रूरी नहीं है?',
			'followUps.another' => 'एक और टेस्ट बुक करें',
			'followUps.anotherText' => 'मुझे एक और टेस्ट बुक करना है',
			'followUps.bookings' => 'मेरी बुकिंग',
			'followUps.prepare' => 'तैयारी कैसे करूँ?',
			'followUps.prepareText' => 'सैंपल कलेक्शन के लिए तैयारी कैसे करूँ?',
			'followUps.anotherDay' => 'दूसरा दिन',
			'followUps.suggest' => 'मेरे लिए टेस्ट सुझाएँ',
			'followUps.suggestText' => 'रूटीन चेकअप के लिए आप कौन से टेस्ट सुझाएँगे?',
			'followUps.fullBody' => 'फुल बॉडी चेकअप',
			'followUps.browse' => 'सभी पैकेज देखें',
			'history.title' => 'इतिहास',
			'history.empty' => 'साथी के साथ आपकी चैट यहाँ दिखेंगी।',
			'history.current' => 'अभी की',
			'history.paused' => 'बुकिंग रुकी है',
			'history.today' => ({required Object time}) => 'आज, ${time}',
			'history.yesterday' => 'कल',
			'nav.chat' => 'चैट',
			'nav.history' => 'इतिहास',
			'nav.bookings' => 'बुकिंग',
			'nav.packages' => 'पैकेज',
			'nav.back' => 'चैट पर वापस',
			'details.view' => 'जानकारी',
			'details.about' => 'पैकेज के बारे में',
			'details.facts' => 'एक नज़र में',
			'details.included' => 'इसमें शामिल',
			'details.prep' => 'तैयारी कैसे करें',
			'details.fastPrep' => ({required Object h}) => 'सैंपल से पहले ${h} घंटे खाली पेट रहें। सादा पानी पी सकते हैं।',
			'details.noFastPrep' => 'खाली पेट रहने की ज़रूरत नहीं। आप हमेशा की तरह खा-पी सकते हैं।',
			'details.sample' => 'सैंपल',
			'details.blood' => 'खून',
			'details.urine' => 'यूरिन',
			'details.doctorNote' => 'इन टेस्ट से निदान नहीं होता। रिपोर्ट का मतलब डॉक्टर बता सकते हैं।',
			'details.close' => 'बंद करें',
			'details.more' => ({required Object n}) => '+${n} और',
			_ => null,
		};
	}
}
