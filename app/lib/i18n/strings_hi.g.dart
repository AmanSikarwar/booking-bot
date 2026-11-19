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
	@override late final _Translations$categories$hi categories = _Translations$categories$hi._(_root);
	@override late final _Translations$windows$hi windows = _Translations$windows$hi._(_root);
	@override late final _Translations$settings$hi settings = _Translations$settings$hi._(_root);
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
	@override String bookPackage({required Object name}) => 'मुझे ${name} बुक करना है';
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
}

// Path: categories
class _Translations$categories$hi extends Translations$categories$en {
	_Translations$categories$hi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get general => 'सामान्य';
	@override String get diabetes => 'डायबिटीज़';
	@override String get thyroid => 'थायरॉइड';
	@override String get heart => 'दिल';
	@override String get liver => 'लिवर';
	@override String get kidney => 'किडनी';
	@override String get vitamins => 'विटामिन';
	@override String get women => 'महिला';
	@override String get senior => 'बुज़ुर्ग';
	@override String get fever => 'बुखार';
	@override String get fitness => 'फिटनेस';
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
			'booking.confirmed' => 'बुकिंग पक्की',
			'booking.savedOffline' => 'ऑफ़लाइन सेव',
			'booking.viewAll' => 'सभी बुकिंग देखें',
			'booking.forPatient' => ({required Object name}) => '${name} के लिए',
			'slots.full' => 'वह स्लॉट भर गया है। सबसे नज़दीकी खाली स्लॉट:',
			'urgent.call112' => '112 पर कॉल करें',
			'urgent.call108' => '108 पर कॉल करें',
			'urgent.call14416' => '14416 पर कॉल करें',
			'urgent.understood' => 'समझ आया',
			'actions.bookPackage' => ({required Object name}) => 'मुझे ${name} बुक करना है',
			'actions.bookSlot' => ({required Object name, required Object id, required Object date, required Object window, required Object address, required Object patient}) => '${name} (${id}) ${date} को ${window} बजे, ${address} पर, ${patient} के लिए बुक करें।',
			'bookings.title' => 'मेरी बुकिंग',
			'bookings.empty' => 'अभी कोई बुकिंग नहीं है। घर से सैंपल के लिए साथी से कहें।',
			'catalog.title' => 'सभी पैकेज',
			'catalog.all' => 'सभी',
			'catalog.askSaathi' => 'साथी से पूछें',
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
			_ => null,
		};
	}
}
