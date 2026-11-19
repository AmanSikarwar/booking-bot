// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ChatEvent()';
}


}

/// @nodoc
class $ChatEventCopyWith<$Res>  {
$ChatEventCopyWith(ChatEvent _, $Res Function(ChatEvent) __);
}


/// Adds pattern-matching-related methods to [ChatEvent].
extension ChatEventPatterns on ChatEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AckEvent value)?  ack,TResult Function( TextDeltaEvent value)?  textDelta,TResult Function( ToolStartedEvent value)?  toolStarted,TResult Function( CardEvent value)?  card,TResult Function( ErrorEvent value)?  error,TResult Function( DoneEvent value)?  done,TResult Function( UnknownEvent value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AckEvent() when ack != null:
return ack(_that);case TextDeltaEvent() when textDelta != null:
return textDelta(_that);case ToolStartedEvent() when toolStarted != null:
return toolStarted(_that);case CardEvent() when card != null:
return card(_that);case ErrorEvent() when error != null:
return error(_that);case DoneEvent() when done != null:
return done(_that);case UnknownEvent() when unknown != null:
return unknown(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AckEvent value)  ack,required TResult Function( TextDeltaEvent value)  textDelta,required TResult Function( ToolStartedEvent value)  toolStarted,required TResult Function( CardEvent value)  card,required TResult Function( ErrorEvent value)  error,required TResult Function( DoneEvent value)  done,required TResult Function( UnknownEvent value)  unknown,}){
final _that = this;
switch (_that) {
case AckEvent():
return ack(_that);case TextDeltaEvent():
return textDelta(_that);case ToolStartedEvent():
return toolStarted(_that);case CardEvent():
return card(_that);case ErrorEvent():
return error(_that);case DoneEvent():
return done(_that);case UnknownEvent():
return unknown(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AckEvent value)?  ack,TResult? Function( TextDeltaEvent value)?  textDelta,TResult? Function( ToolStartedEvent value)?  toolStarted,TResult? Function( CardEvent value)?  card,TResult? Function( ErrorEvent value)?  error,TResult? Function( DoneEvent value)?  done,TResult? Function( UnknownEvent value)?  unknown,}){
final _that = this;
switch (_that) {
case AckEvent() when ack != null:
return ack(_that);case TextDeltaEvent() when textDelta != null:
return textDelta(_that);case ToolStartedEvent() when toolStarted != null:
return toolStarted(_that);case CardEvent() when card != null:
return card(_that);case ErrorEvent() when error != null:
return error(_that);case DoneEvent() when done != null:
return done(_that);case UnknownEvent() when unknown != null:
return unknown(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool replay)?  ack,TResult Function( String text)?  textDelta,TResult Function( String tool)?  toolStarted,TResult Function( ChatCard card)?  card,TResult Function( String code,  bool retryable,  int? retryAfter)?  error,TResult Function()?  done,TResult Function( String name)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AckEvent() when ack != null:
return ack(_that.replay);case TextDeltaEvent() when textDelta != null:
return textDelta(_that.text);case ToolStartedEvent() when toolStarted != null:
return toolStarted(_that.tool);case CardEvent() when card != null:
return card(_that.card);case ErrorEvent() when error != null:
return error(_that.code,_that.retryable,_that.retryAfter);case DoneEvent() when done != null:
return done();case UnknownEvent() when unknown != null:
return unknown(_that.name);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool replay)  ack,required TResult Function( String text)  textDelta,required TResult Function( String tool)  toolStarted,required TResult Function( ChatCard card)  card,required TResult Function( String code,  bool retryable,  int? retryAfter)  error,required TResult Function()  done,required TResult Function( String name)  unknown,}) {final _that = this;
switch (_that) {
case AckEvent():
return ack(_that.replay);case TextDeltaEvent():
return textDelta(_that.text);case ToolStartedEvent():
return toolStarted(_that.tool);case CardEvent():
return card(_that.card);case ErrorEvent():
return error(_that.code,_that.retryable,_that.retryAfter);case DoneEvent():
return done();case UnknownEvent():
return unknown(_that.name);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool replay)?  ack,TResult? Function( String text)?  textDelta,TResult? Function( String tool)?  toolStarted,TResult? Function( ChatCard card)?  card,TResult? Function( String code,  bool retryable,  int? retryAfter)?  error,TResult? Function()?  done,TResult? Function( String name)?  unknown,}) {final _that = this;
switch (_that) {
case AckEvent() when ack != null:
return ack(_that.replay);case TextDeltaEvent() when textDelta != null:
return textDelta(_that.text);case ToolStartedEvent() when toolStarted != null:
return toolStarted(_that.tool);case CardEvent() when card != null:
return card(_that.card);case ErrorEvent() when error != null:
return error(_that.code,_that.retryable,_that.retryAfter);case DoneEvent() when done != null:
return done();case UnknownEvent() when unknown != null:
return unknown(_that.name);case _:
  return null;

}
}

}

/// @nodoc


class AckEvent implements ChatEvent {
  const AckEvent({required this.replay});
  

 final  bool replay;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AckEventCopyWith<AckEvent> get copyWith => _$AckEventCopyWithImpl<AckEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AckEvent&&(identical(other.replay, replay) || other.replay == replay));
}


@override
int get hashCode {
    return Object.hash(runtimeType,replay);
}

@override
String toString() {
    return 'ChatEvent.ack(replay: $replay)';
}


}

/// @nodoc
abstract mixin class $AckEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $AckEventCopyWith(AckEvent value, $Res Function(AckEvent) _then) = _$AckEventCopyWithImpl;
@useResult
$Res call({
 bool replay
});




}
/// @nodoc
class _$AckEventCopyWithImpl<$Res>
    implements $AckEventCopyWith<$Res> {
  _$AckEventCopyWithImpl(this._self, this._then);

  final AckEvent _self;
  final $Res Function(AckEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? replay = null,}) {
  return _then(AckEvent(
replay: null == replay ? _self.replay : replay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class TextDeltaEvent implements ChatEvent {
  const TextDeltaEvent(this.text);
  

 final  String text;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextDeltaEventCopyWith<TextDeltaEvent> get copyWith => _$TextDeltaEventCopyWithImpl<TextDeltaEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TextDeltaEvent&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text);
}

@override
String toString() {
    return 'ChatEvent.textDelta(text: $text)';
}


}

/// @nodoc
abstract mixin class $TextDeltaEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $TextDeltaEventCopyWith(TextDeltaEvent value, $Res Function(TextDeltaEvent) _then) = _$TextDeltaEventCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$TextDeltaEventCopyWithImpl<$Res>
    implements $TextDeltaEventCopyWith<$Res> {
  _$TextDeltaEventCopyWithImpl(this._self, this._then);

  final TextDeltaEvent _self;
  final $Res Function(TextDeltaEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(TextDeltaEvent(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ToolStartedEvent implements ChatEvent {
  const ToolStartedEvent(this.tool);
  

 final  String tool;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToolStartedEventCopyWith<ToolStartedEvent> get copyWith => _$ToolStartedEventCopyWithImpl<ToolStartedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ToolStartedEvent&&(identical(other.tool, tool) || other.tool == tool));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tool);
}

@override
String toString() {
    return 'ChatEvent.toolStarted(tool: $tool)';
}


}

/// @nodoc
abstract mixin class $ToolStartedEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ToolStartedEventCopyWith(ToolStartedEvent value, $Res Function(ToolStartedEvent) _then) = _$ToolStartedEventCopyWithImpl;
@useResult
$Res call({
 String tool
});




}
/// @nodoc
class _$ToolStartedEventCopyWithImpl<$Res>
    implements $ToolStartedEventCopyWith<$Res> {
  _$ToolStartedEventCopyWithImpl(this._self, this._then);

  final ToolStartedEvent _self;
  final $Res Function(ToolStartedEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tool = null,}) {
  return _then(ToolStartedEvent(
null == tool ? _self.tool : tool // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CardEvent implements ChatEvent {
  const CardEvent(this.card);
  

 final  ChatCard card;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CardEventCopyWith<CardEvent> get copyWith => _$CardEventCopyWithImpl<CardEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CardEvent&&(identical(other.card, card) || other.card == card));
}


@override
int get hashCode {
    return Object.hash(runtimeType,card);
}

@override
String toString() {
    return 'ChatEvent.card(card: $card)';
}


}

/// @nodoc
abstract mixin class $CardEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $CardEventCopyWith(CardEvent value, $Res Function(CardEvent) _then) = _$CardEventCopyWithImpl;
@useResult
$Res call({
 ChatCard card
});


$ChatCardCopyWith<$Res> get card;

}
/// @nodoc
class _$CardEventCopyWithImpl<$Res>
    implements $CardEventCopyWith<$Res> {
  _$CardEventCopyWithImpl(this._self, this._then);

  final CardEvent _self;
  final $Res Function(CardEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? card = null,}) {
  return _then(CardEvent(
null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as ChatCard,
  ));
}

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatCardCopyWith<$Res> get card {
  
  return $ChatCardCopyWith<$Res>(_self.card, (value) {
    return _then(_self.copyWith(card: value));
  });
}
}

/// @nodoc


class ErrorEvent implements ChatEvent {
  const ErrorEvent({required this.code, required this.retryable, this.retryAfter});
  

 final  String code;
 final  bool retryable;
 final  int? retryAfter;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorEventCopyWith<ErrorEvent> get copyWith => _$ErrorEventCopyWithImpl<ErrorEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorEvent&&(identical(other.code, code) || other.code == code)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.retryAfter, retryAfter) || other.retryAfter == retryAfter));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,retryable,retryAfter);
}

@override
String toString() {
    return 'ChatEvent.error(code: $code, retryable: $retryable, retryAfter: $retryAfter)';
}


}

/// @nodoc
abstract mixin class $ErrorEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ErrorEventCopyWith(ErrorEvent value, $Res Function(ErrorEvent) _then) = _$ErrorEventCopyWithImpl;
@useResult
$Res call({
 String code, bool retryable, int? retryAfter
});




}
/// @nodoc
class _$ErrorEventCopyWithImpl<$Res>
    implements $ErrorEventCopyWith<$Res> {
  _$ErrorEventCopyWithImpl(this._self, this._then);

  final ErrorEvent _self;
  final $Res Function(ErrorEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,Object? retryable = null,Object? retryAfter = freezed,}) {
  return _then(ErrorEvent(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,retryAfter: freezed == retryAfter ? _self.retryAfter : retryAfter // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class DoneEvent implements ChatEvent {
  const DoneEvent();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DoneEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ChatEvent.done()';
}


}




/// @nodoc


class UnknownEvent implements ChatEvent {
  const UnknownEvent(this.name);
  

 final  String name;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownEventCopyWith<UnknownEvent> get copyWith => _$UnknownEventCopyWithImpl<UnknownEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownEvent&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name);
}

@override
String toString() {
    return 'ChatEvent.unknown(name: $name)';
}


}

/// @nodoc
abstract mixin class $UnknownEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $UnknownEventCopyWith(UnknownEvent value, $Res Function(UnknownEvent) _then) = _$UnknownEventCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$UnknownEventCopyWithImpl<$Res>
    implements $UnknownEventCopyWith<$Res> {
  _$UnknownEventCopyWithImpl(this._self, this._then);

  final UnknownEvent _self;
  final $Res Function(UnknownEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(UnknownEvent(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
