// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PackageSummary {

 String get id; Localized get name; int get priceInr; int get mrpInr; int get testCount; List<String> get topTests; int get fastingHours; int get reportTatHours; Localized get matchReason;
/// Create a copy of PackageSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageSummaryCopyWith<PackageSummary> get copyWith => _$PackageSummaryCopyWithImpl<PackageSummary>(this as PackageSummary, _$identity);

  /// Serializes this PackageSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PackageSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackageSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.priceInr, _this.priceInr) || other.priceInr == _this.priceInr)&&(identical(other.mrpInr, _this.mrpInr) || other.mrpInr == _this.mrpInr)&&(identical(other.testCount, _this.testCount) || other.testCount == _this.testCount)&&const DeepCollectionEquality().equals(other.topTests, _this.topTests)&&(identical(other.fastingHours, _this.fastingHours) || other.fastingHours == _this.fastingHours)&&(identical(other.reportTatHours, _this.reportTatHours) || other.reportTatHours == _this.reportTatHours)&&(identical(other.matchReason, _this.matchReason) || other.matchReason == _this.matchReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PackageSummary;
  return Object.hash(runtimeType,_this.id,_this.name,_this.priceInr,_this.mrpInr,_this.testCount,const DeepCollectionEquality().hash(_this.topTests),_this.fastingHours,_this.reportTatHours,_this.matchReason);
}

@override
String toString() {
  final _this = this as PackageSummary;
  return 'PackageSummary(id: ${_this.id}, name: ${_this.name}, priceInr: ${_this.priceInr}, mrpInr: ${_this.mrpInr}, testCount: ${_this.testCount}, topTests: ${_this.topTests}, fastingHours: ${_this.fastingHours}, reportTatHours: ${_this.reportTatHours}, matchReason: ${_this.matchReason})';
}


}

/// @nodoc
abstract mixin class $PackageSummaryCopyWith<$Res>  {
  factory $PackageSummaryCopyWith(PackageSummary value, $Res Function(PackageSummary) _then) = _$PackageSummaryCopyWithImpl;
@useResult
$Res call({
 String id, Localized name, int priceInr, int mrpInr, int testCount, List<String> topTests, int fastingHours, int reportTatHours, Localized matchReason
});


$LocalizedCopyWith<$Res> get name;$LocalizedCopyWith<$Res> get matchReason;

}
/// @nodoc
class _$PackageSummaryCopyWithImpl<$Res>
    implements $PackageSummaryCopyWith<$Res> {
  _$PackageSummaryCopyWithImpl(this._self, this._then);

  final PackageSummary _self;
  final $Res Function(PackageSummary) _then;

/// Create a copy of PackageSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? priceInr = null,Object? mrpInr = null,Object? testCount = null,Object? topTests = null,Object? fastingHours = null,Object? reportTatHours = null,Object? matchReason = null,}) {
  return _then(PackageSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as Localized,priceInr: null == priceInr ? _self.priceInr : priceInr // ignore: cast_nullable_to_non_nullable
as int,mrpInr: null == mrpInr ? _self.mrpInr : mrpInr // ignore: cast_nullable_to_non_nullable
as int,testCount: null == testCount ? _self.testCount : testCount // ignore: cast_nullable_to_non_nullable
as int,topTests: null == topTests ? _self.topTests : topTests // ignore: cast_nullable_to_non_nullable
as List<String>,fastingHours: null == fastingHours ? _self.fastingHours : fastingHours // ignore: cast_nullable_to_non_nullable
as int,reportTatHours: null == reportTatHours ? _self.reportTatHours : reportTatHours // ignore: cast_nullable_to_non_nullable
as int,matchReason: null == matchReason ? _self.matchReason : matchReason // ignore: cast_nullable_to_non_nullable
as Localized,
  ));
}
/// Create a copy of PackageSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedCopyWith<$Res> get name {
  
  return $LocalizedCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of PackageSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedCopyWith<$Res> get matchReason {
  
  return $LocalizedCopyWith<$Res>(_self.matchReason, (value) {
    return _then(_self.copyWith(matchReason: value));
  });
}
}


/// Adds pattern-matching-related methods to [PackageSummary].
extension PackageSummaryPatterns on PackageSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackageSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackageSummary() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackageSummary value)  $default,){
final _that = this;
switch (_that) {
case _PackageSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackageSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PackageSummary() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Localized name,  int priceInr,  int mrpInr,  int testCount,  List<String> topTests,  int fastingHours,  int reportTatHours,  Localized matchReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackageSummary() when $default != null:
return $default(_that.id,_that.name,_that.priceInr,_that.mrpInr,_that.testCount,_that.topTests,_that.fastingHours,_that.reportTatHours,_that.matchReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Localized name,  int priceInr,  int mrpInr,  int testCount,  List<String> topTests,  int fastingHours,  int reportTatHours,  Localized matchReason)  $default,) {final _that = this;
switch (_that) {
case _PackageSummary():
return $default(_that.id,_that.name,_that.priceInr,_that.mrpInr,_that.testCount,_that.topTests,_that.fastingHours,_that.reportTatHours,_that.matchReason);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Localized name,  int priceInr,  int mrpInr,  int testCount,  List<String> topTests,  int fastingHours,  int reportTatHours,  Localized matchReason)?  $default,) {final _that = this;
switch (_that) {
case _PackageSummary() when $default != null:
return $default(_that.id,_that.name,_that.priceInr,_that.mrpInr,_that.testCount,_that.topTests,_that.fastingHours,_that.reportTatHours,_that.matchReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PackageSummary implements PackageSummary {
  const _PackageSummary({required this.id, required this.name, required this.priceInr, required this.mrpInr, required this.testCount, required  List<String> topTests, required this.fastingHours, required this.reportTatHours, required this.matchReason}): _topTests = topTests;
  factory _PackageSummary.fromJson(Map<String, dynamic> json) => _$PackageSummaryFromJson(json);

@override final  String id;
@override final  Localized name;
@override final  int priceInr;
@override final  int mrpInr;
@override final  int testCount;
 final  List<String> _topTests;
@override List<String> get topTests {
  if (_topTests is EqualUnmodifiableListView) return _topTests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topTests);
}

@override final  int fastingHours;
@override final  int reportTatHours;
@override final  Localized matchReason;

/// Create a copy of PackageSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageSummaryCopyWith<_PackageSummary> get copyWith => __$PackageSummaryCopyWithImpl<_PackageSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackageSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackageSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceInr, priceInr) || other.priceInr == priceInr)&&(identical(other.mrpInr, mrpInr) || other.mrpInr == mrpInr)&&(identical(other.testCount, testCount) || other.testCount == testCount)&&const DeepCollectionEquality().equals(other.topTests, _topTests)&&(identical(other.fastingHours, fastingHours) || other.fastingHours == fastingHours)&&(identical(other.reportTatHours, reportTatHours) || other.reportTatHours == reportTatHours)&&(identical(other.matchReason, matchReason) || other.matchReason == matchReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,priceInr,mrpInr,testCount,const DeepCollectionEquality().hash(_topTests),fastingHours,reportTatHours,matchReason);
}

@override
String toString() {
    return 'PackageSummary(id: $id, name: $name, priceInr: $priceInr, mrpInr: $mrpInr, testCount: $testCount, topTests: $topTests, fastingHours: $fastingHours, reportTatHours: $reportTatHours, matchReason: $matchReason)';
}


}

/// @nodoc
abstract mixin class _$PackageSummaryCopyWith<$Res> implements $PackageSummaryCopyWith<$Res> {
  factory _$PackageSummaryCopyWith(_PackageSummary value, $Res Function(_PackageSummary) _then) = __$PackageSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, Localized name, int priceInr, int mrpInr, int testCount, List<String> topTests, int fastingHours, int reportTatHours, Localized matchReason
});


@override $LocalizedCopyWith<$Res> get name;@override $LocalizedCopyWith<$Res> get matchReason;

}
/// @nodoc
class __$PackageSummaryCopyWithImpl<$Res>
    implements _$PackageSummaryCopyWith<$Res> {
  __$PackageSummaryCopyWithImpl(this._self, this._then);

  final _PackageSummary _self;
  final $Res Function(_PackageSummary) _then;

/// Create a copy of PackageSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? priceInr = null,Object? mrpInr = null,Object? testCount = null,Object? topTests = null,Object? fastingHours = null,Object? reportTatHours = null,Object? matchReason = null,}) {
  return _then(_PackageSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as Localized,priceInr: null == priceInr ? _self.priceInr : priceInr // ignore: cast_nullable_to_non_nullable
as int,mrpInr: null == mrpInr ? _self.mrpInr : mrpInr // ignore: cast_nullable_to_non_nullable
as int,testCount: null == testCount ? _self.testCount : testCount // ignore: cast_nullable_to_non_nullable
as int,topTests: null == topTests ? _self._topTests : topTests // ignore: cast_nullable_to_non_nullable
as List<String>,fastingHours: null == fastingHours ? _self.fastingHours : fastingHours // ignore: cast_nullable_to_non_nullable
as int,reportTatHours: null == reportTatHours ? _self.reportTatHours : reportTatHours // ignore: cast_nullable_to_non_nullable
as int,matchReason: null == matchReason ? _self.matchReason : matchReason // ignore: cast_nullable_to_non_nullable
as Localized,
  ));
}

/// Create a copy of PackageSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedCopyWith<$Res> get name {
  
  return $LocalizedCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of PackageSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedCopyWith<$Res> get matchReason {
  
  return $LocalizedCopyWith<$Res>(_self.matchReason, (value) {
    return _then(_self.copyWith(matchReason: value));
  });
}
}


/// @nodoc
mixin _$BookingInfo {

 String get bookingRef; String get packageId; Localized get packageName; String get date; String get timeWindow; String get addressLabel; String get patientName; String get status; int get fastingHours;
/// Create a copy of BookingInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingInfoCopyWith<BookingInfo> get copyWith => _$BookingInfoCopyWithImpl<BookingInfo>(this as BookingInfo, _$identity);

  /// Serializes this BookingInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BookingInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingInfo&&(identical(other.bookingRef, _this.bookingRef) || other.bookingRef == _this.bookingRef)&&(identical(other.packageId, _this.packageId) || other.packageId == _this.packageId)&&(identical(other.packageName, _this.packageName) || other.packageName == _this.packageName)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.timeWindow, _this.timeWindow) || other.timeWindow == _this.timeWindow)&&(identical(other.addressLabel, _this.addressLabel) || other.addressLabel == _this.addressLabel)&&(identical(other.patientName, _this.patientName) || other.patientName == _this.patientName)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.fastingHours, _this.fastingHours) || other.fastingHours == _this.fastingHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BookingInfo;
  return Object.hash(runtimeType,_this.bookingRef,_this.packageId,_this.packageName,_this.date,_this.timeWindow,_this.addressLabel,_this.patientName,_this.status,_this.fastingHours);
}

@override
String toString() {
  final _this = this as BookingInfo;
  return 'BookingInfo(bookingRef: ${_this.bookingRef}, packageId: ${_this.packageId}, packageName: ${_this.packageName}, date: ${_this.date}, timeWindow: ${_this.timeWindow}, addressLabel: ${_this.addressLabel}, patientName: ${_this.patientName}, status: ${_this.status}, fastingHours: ${_this.fastingHours})';
}


}

/// @nodoc
abstract mixin class $BookingInfoCopyWith<$Res>  {
  factory $BookingInfoCopyWith(BookingInfo value, $Res Function(BookingInfo) _then) = _$BookingInfoCopyWithImpl;
@useResult
$Res call({
 String bookingRef, String packageId, Localized packageName, String date, String timeWindow, String addressLabel, String patientName, String status, int fastingHours
});


$LocalizedCopyWith<$Res> get packageName;

}
/// @nodoc
class _$BookingInfoCopyWithImpl<$Res>
    implements $BookingInfoCopyWith<$Res> {
  _$BookingInfoCopyWithImpl(this._self, this._then);

  final BookingInfo _self;
  final $Res Function(BookingInfo) _then;

/// Create a copy of BookingInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookingRef = null,Object? packageId = null,Object? packageName = null,Object? date = null,Object? timeWindow = null,Object? addressLabel = null,Object? patientName = null,Object? status = null,Object? fastingHours = null,}) {
  return _then(BookingInfo(
bookingRef: null == bookingRef ? _self.bookingRef : bookingRef // ignore: cast_nullable_to_non_nullable
as String,packageId: null == packageId ? _self.packageId : packageId // ignore: cast_nullable_to_non_nullable
as String,packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as Localized,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,timeWindow: null == timeWindow ? _self.timeWindow : timeWindow // ignore: cast_nullable_to_non_nullable
as String,addressLabel: null == addressLabel ? _self.addressLabel : addressLabel // ignore: cast_nullable_to_non_nullable
as String,patientName: null == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,fastingHours: null == fastingHours ? _self.fastingHours : fastingHours // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of BookingInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedCopyWith<$Res> get packageName {
  
  return $LocalizedCopyWith<$Res>(_self.packageName, (value) {
    return _then(_self.copyWith(packageName: value));
  });
}
}


/// Adds pattern-matching-related methods to [BookingInfo].
extension BookingInfoPatterns on BookingInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingInfo() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingInfo value)  $default,){
final _that = this;
switch (_that) {
case _BookingInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingInfo value)?  $default,){
final _that = this;
switch (_that) {
case _BookingInfo() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bookingRef,  String packageId,  Localized packageName,  String date,  String timeWindow,  String addressLabel,  String patientName,  String status,  int fastingHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingInfo() when $default != null:
return $default(_that.bookingRef,_that.packageId,_that.packageName,_that.date,_that.timeWindow,_that.addressLabel,_that.patientName,_that.status,_that.fastingHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bookingRef,  String packageId,  Localized packageName,  String date,  String timeWindow,  String addressLabel,  String patientName,  String status,  int fastingHours)  $default,) {final _that = this;
switch (_that) {
case _BookingInfo():
return $default(_that.bookingRef,_that.packageId,_that.packageName,_that.date,_that.timeWindow,_that.addressLabel,_that.patientName,_that.status,_that.fastingHours);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bookingRef,  String packageId,  Localized packageName,  String date,  String timeWindow,  String addressLabel,  String patientName,  String status,  int fastingHours)?  $default,) {final _that = this;
switch (_that) {
case _BookingInfo() when $default != null:
return $default(_that.bookingRef,_that.packageId,_that.packageName,_that.date,_that.timeWindow,_that.addressLabel,_that.patientName,_that.status,_that.fastingHours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingInfo implements BookingInfo {
  const _BookingInfo({required this.bookingRef, required this.packageId, required this.packageName, required this.date, required this.timeWindow, required this.addressLabel, required this.patientName, required this.status, this.fastingHours = 0});
  factory _BookingInfo.fromJson(Map<String, dynamic> json) => _$BookingInfoFromJson(json);

@override final  String bookingRef;
@override final  String packageId;
@override final  Localized packageName;
@override final  String date;
@override final  String timeWindow;
@override final  String addressLabel;
@override final  String patientName;
@override final  String status;
@override@JsonKey() final  int fastingHours;

/// Create a copy of BookingInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingInfoCopyWith<_BookingInfo> get copyWith => __$BookingInfoCopyWithImpl<_BookingInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingInfo&&(identical(other.bookingRef, bookingRef) || other.bookingRef == bookingRef)&&(identical(other.packageId, packageId) || other.packageId == packageId)&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.date, date) || other.date == date)&&(identical(other.timeWindow, timeWindow) || other.timeWindow == timeWindow)&&(identical(other.addressLabel, addressLabel) || other.addressLabel == addressLabel)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.status, status) || other.status == status)&&(identical(other.fastingHours, fastingHours) || other.fastingHours == fastingHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,bookingRef,packageId,packageName,date,timeWindow,addressLabel,patientName,status,fastingHours);
}

@override
String toString() {
    return 'BookingInfo(bookingRef: $bookingRef, packageId: $packageId, packageName: $packageName, date: $date, timeWindow: $timeWindow, addressLabel: $addressLabel, patientName: $patientName, status: $status, fastingHours: $fastingHours)';
}


}

/// @nodoc
abstract mixin class _$BookingInfoCopyWith<$Res> implements $BookingInfoCopyWith<$Res> {
  factory _$BookingInfoCopyWith(_BookingInfo value, $Res Function(_BookingInfo) _then) = __$BookingInfoCopyWithImpl;
@override @useResult
$Res call({
 String bookingRef, String packageId, Localized packageName, String date, String timeWindow, String addressLabel, String patientName, String status, int fastingHours
});


@override $LocalizedCopyWith<$Res> get packageName;

}
/// @nodoc
class __$BookingInfoCopyWithImpl<$Res>
    implements _$BookingInfoCopyWith<$Res> {
  __$BookingInfoCopyWithImpl(this._self, this._then);

  final _BookingInfo _self;
  final $Res Function(_BookingInfo) _then;

/// Create a copy of BookingInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookingRef = null,Object? packageId = null,Object? packageName = null,Object? date = null,Object? timeWindow = null,Object? addressLabel = null,Object? patientName = null,Object? status = null,Object? fastingHours = null,}) {
  return _then(_BookingInfo(
bookingRef: null == bookingRef ? _self.bookingRef : bookingRef // ignore: cast_nullable_to_non_nullable
as String,packageId: null == packageId ? _self.packageId : packageId // ignore: cast_nullable_to_non_nullable
as String,packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as Localized,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,timeWindow: null == timeWindow ? _self.timeWindow : timeWindow // ignore: cast_nullable_to_non_nullable
as String,addressLabel: null == addressLabel ? _self.addressLabel : addressLabel // ignore: cast_nullable_to_non_nullable
as String,patientName: null == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,fastingHours: null == fastingHours ? _self.fastingHours : fastingHours // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of BookingInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedCopyWith<$Res> get packageName {
  
  return $LocalizedCopyWith<$Res>(_self.packageName, (value) {
    return _then(_self.copyWith(packageName: value));
  });
}
}


/// @nodoc
mixin _$Slot {

 String get date; String get timeWindow;
/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotCopyWith<Slot> get copyWith => _$SlotCopyWithImpl<Slot>(this as Slot, _$identity);

  /// Serializes this Slot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Slot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Slot&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.timeWindow, _this.timeWindow) || other.timeWindow == _this.timeWindow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Slot;
  return Object.hash(runtimeType,_this.date,_this.timeWindow);
}

@override
String toString() {
  final _this = this as Slot;
  return 'Slot(date: ${_this.date}, timeWindow: ${_this.timeWindow})';
}


}

/// @nodoc
abstract mixin class $SlotCopyWith<$Res>  {
  factory $SlotCopyWith(Slot value, $Res Function(Slot) _then) = _$SlotCopyWithImpl;
@useResult
$Res call({
 String date, String timeWindow
});




}
/// @nodoc
class _$SlotCopyWithImpl<$Res>
    implements $SlotCopyWith<$Res> {
  _$SlotCopyWithImpl(this._self, this._then);

  final Slot _self;
  final $Res Function(Slot) _then;

/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? timeWindow = null,}) {
  return _then(Slot(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,timeWindow: null == timeWindow ? _self.timeWindow : timeWindow // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Slot].
extension SlotPatterns on Slot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Slot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Slot() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Slot value)  $default,){
final _that = this;
switch (_that) {
case _Slot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Slot value)?  $default,){
final _that = this;
switch (_that) {
case _Slot() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  String timeWindow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Slot() when $default != null:
return $default(_that.date,_that.timeWindow);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  String timeWindow)  $default,) {final _that = this;
switch (_that) {
case _Slot():
return $default(_that.date,_that.timeWindow);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  String timeWindow)?  $default,) {final _that = this;
switch (_that) {
case _Slot() when $default != null:
return $default(_that.date,_that.timeWindow);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Slot implements Slot {
  const _Slot({required this.date, required this.timeWindow});
  factory _Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);

@override final  String date;
@override final  String timeWindow;

/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlotCopyWith<_Slot> get copyWith => __$SlotCopyWithImpl<_Slot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Slot&&(identical(other.date, date) || other.date == date)&&(identical(other.timeWindow, timeWindow) || other.timeWindow == timeWindow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,timeWindow);
}

@override
String toString() {
    return 'Slot(date: $date, timeWindow: $timeWindow)';
}


}

/// @nodoc
abstract mixin class _$SlotCopyWith<$Res> implements $SlotCopyWith<$Res> {
  factory _$SlotCopyWith(_Slot value, $Res Function(_Slot) _then) = __$SlotCopyWithImpl;
@override @useResult
$Res call({
 String date, String timeWindow
});




}
/// @nodoc
class __$SlotCopyWithImpl<$Res>
    implements _$SlotCopyWith<$Res> {
  __$SlotCopyWithImpl(this._self, this._then);

  final _Slot _self;
  final $Res Function(_Slot) _then;

/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? timeWindow = null,}) {
  return _then(_Slot(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,timeWindow: null == timeWindow ? _self.timeWindow : timeWindow // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SlotOffer {

 Slot get requested; List<Slot> get alternatives; String get packageId; Localized get packageName; String get addressLabel; String get patientName;
/// Create a copy of SlotOffer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotOfferCopyWith<SlotOffer> get copyWith => _$SlotOfferCopyWithImpl<SlotOffer>(this as SlotOffer, _$identity);

  /// Serializes this SlotOffer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SlotOffer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlotOffer&&(identical(other.requested, _this.requested) || other.requested == _this.requested)&&const DeepCollectionEquality().equals(other.alternatives, _this.alternatives)&&(identical(other.packageId, _this.packageId) || other.packageId == _this.packageId)&&(identical(other.packageName, _this.packageName) || other.packageName == _this.packageName)&&(identical(other.addressLabel, _this.addressLabel) || other.addressLabel == _this.addressLabel)&&(identical(other.patientName, _this.patientName) || other.patientName == _this.patientName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SlotOffer;
  return Object.hash(runtimeType,_this.requested,const DeepCollectionEquality().hash(_this.alternatives),_this.packageId,_this.packageName,_this.addressLabel,_this.patientName);
}

@override
String toString() {
  final _this = this as SlotOffer;
  return 'SlotOffer(requested: ${_this.requested}, alternatives: ${_this.alternatives}, packageId: ${_this.packageId}, packageName: ${_this.packageName}, addressLabel: ${_this.addressLabel}, patientName: ${_this.patientName})';
}


}

/// @nodoc
abstract mixin class $SlotOfferCopyWith<$Res>  {
  factory $SlotOfferCopyWith(SlotOffer value, $Res Function(SlotOffer) _then) = _$SlotOfferCopyWithImpl;
@useResult
$Res call({
 Slot requested, List<Slot> alternatives, String packageId, Localized packageName, String addressLabel, String patientName
});


$SlotCopyWith<$Res> get requested;$LocalizedCopyWith<$Res> get packageName;

}
/// @nodoc
class _$SlotOfferCopyWithImpl<$Res>
    implements $SlotOfferCopyWith<$Res> {
  _$SlotOfferCopyWithImpl(this._self, this._then);

  final SlotOffer _self;
  final $Res Function(SlotOffer) _then;

/// Create a copy of SlotOffer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requested = null,Object? alternatives = null,Object? packageId = null,Object? packageName = null,Object? addressLabel = null,Object? patientName = null,}) {
  return _then(SlotOffer(
requested: null == requested ? _self.requested : requested // ignore: cast_nullable_to_non_nullable
as Slot,alternatives: null == alternatives ? _self.alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<Slot>,packageId: null == packageId ? _self.packageId : packageId // ignore: cast_nullable_to_non_nullable
as String,packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as Localized,addressLabel: null == addressLabel ? _self.addressLabel : addressLabel // ignore: cast_nullable_to_non_nullable
as String,patientName: null == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of SlotOffer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SlotCopyWith<$Res> get requested {
  
  return $SlotCopyWith<$Res>(_self.requested, (value) {
    return _then(_self.copyWith(requested: value));
  });
}/// Create a copy of SlotOffer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedCopyWith<$Res> get packageName {
  
  return $LocalizedCopyWith<$Res>(_self.packageName, (value) {
    return _then(_self.copyWith(packageName: value));
  });
}
}


/// Adds pattern-matching-related methods to [SlotOffer].
extension SlotOfferPatterns on SlotOffer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SlotOffer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SlotOffer() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SlotOffer value)  $default,){
final _that = this;
switch (_that) {
case _SlotOffer():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SlotOffer value)?  $default,){
final _that = this;
switch (_that) {
case _SlotOffer() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Slot requested,  List<Slot> alternatives,  String packageId,  Localized packageName,  String addressLabel,  String patientName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SlotOffer() when $default != null:
return $default(_that.requested,_that.alternatives,_that.packageId,_that.packageName,_that.addressLabel,_that.patientName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Slot requested,  List<Slot> alternatives,  String packageId,  Localized packageName,  String addressLabel,  String patientName)  $default,) {final _that = this;
switch (_that) {
case _SlotOffer():
return $default(_that.requested,_that.alternatives,_that.packageId,_that.packageName,_that.addressLabel,_that.patientName);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Slot requested,  List<Slot> alternatives,  String packageId,  Localized packageName,  String addressLabel,  String patientName)?  $default,) {final _that = this;
switch (_that) {
case _SlotOffer() when $default != null:
return $default(_that.requested,_that.alternatives,_that.packageId,_that.packageName,_that.addressLabel,_that.patientName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SlotOffer implements SlotOffer {
  const _SlotOffer({required this.requested, required  List<Slot> alternatives, required this.packageId, required this.packageName, required this.addressLabel, required this.patientName}): _alternatives = alternatives;
  factory _SlotOffer.fromJson(Map<String, dynamic> json) => _$SlotOfferFromJson(json);

@override final  Slot requested;
 final  List<Slot> _alternatives;
@override List<Slot> get alternatives {
  if (_alternatives is EqualUnmodifiableListView) return _alternatives;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alternatives);
}

@override final  String packageId;
@override final  Localized packageName;
@override final  String addressLabel;
@override final  String patientName;

/// Create a copy of SlotOffer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlotOfferCopyWith<_SlotOffer> get copyWith => __$SlotOfferCopyWithImpl<_SlotOffer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlotOfferToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SlotOffer&&(identical(other.requested, requested) || other.requested == requested)&&const DeepCollectionEquality().equals(other.alternatives, _alternatives)&&(identical(other.packageId, packageId) || other.packageId == packageId)&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.addressLabel, addressLabel) || other.addressLabel == addressLabel)&&(identical(other.patientName, patientName) || other.patientName == patientName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,requested,const DeepCollectionEquality().hash(_alternatives),packageId,packageName,addressLabel,patientName);
}

@override
String toString() {
    return 'SlotOffer(requested: $requested, alternatives: $alternatives, packageId: $packageId, packageName: $packageName, addressLabel: $addressLabel, patientName: $patientName)';
}


}

/// @nodoc
abstract mixin class _$SlotOfferCopyWith<$Res> implements $SlotOfferCopyWith<$Res> {
  factory _$SlotOfferCopyWith(_SlotOffer value, $Res Function(_SlotOffer) _then) = __$SlotOfferCopyWithImpl;
@override @useResult
$Res call({
 Slot requested, List<Slot> alternatives, String packageId, Localized packageName, String addressLabel, String patientName
});


@override $SlotCopyWith<$Res> get requested;@override $LocalizedCopyWith<$Res> get packageName;

}
/// @nodoc
class __$SlotOfferCopyWithImpl<$Res>
    implements _$SlotOfferCopyWith<$Res> {
  __$SlotOfferCopyWithImpl(this._self, this._then);

  final _SlotOffer _self;
  final $Res Function(_SlotOffer) _then;

/// Create a copy of SlotOffer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requested = null,Object? alternatives = null,Object? packageId = null,Object? packageName = null,Object? addressLabel = null,Object? patientName = null,}) {
  return _then(_SlotOffer(
requested: null == requested ? _self.requested : requested // ignore: cast_nullable_to_non_nullable
as Slot,alternatives: null == alternatives ? _self._alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<Slot>,packageId: null == packageId ? _self.packageId : packageId // ignore: cast_nullable_to_non_nullable
as String,packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as Localized,addressLabel: null == addressLabel ? _self.addressLabel : addressLabel // ignore: cast_nullable_to_non_nullable
as String,patientName: null == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of SlotOffer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SlotCopyWith<$Res> get requested {
  
  return $SlotCopyWith<$Res>(_self.requested, (value) {
    return _then(_self.copyWith(requested: value));
  });
}/// Create a copy of SlotOffer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedCopyWith<$Res> get packageName {
  
  return $LocalizedCopyWith<$Res>(_self.packageName, (value) {
    return _then(_self.copyWith(packageName: value));
  });
}
}

ChatCard _$ChatCardFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'packages':
          return PackagesCard.fromJson(
            json
          );
                case 'booking':
          return BookingCardData.fromJson(
            json
          );
                case 'slots':
          return SlotsCard.fromJson(
            json
          );
                case 'urgent':
          return UrgentCard.fromJson(
            json
          );
                case 'crisis':
          return CrisisCard.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'ChatCard',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$ChatCard {



  /// Serializes this ChatCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatCard);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ChatCard()';
}


}

/// @nodoc
class $ChatCardCopyWith<$Res>  {
$ChatCardCopyWith(ChatCard _, $Res Function(ChatCard) __);
}


/// Adds pattern-matching-related methods to [ChatCard].
extension ChatCardPatterns on ChatCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PackagesCard value)?  packages,TResult Function( BookingCardData value)?  booking,TResult Function( SlotsCard value)?  slots,TResult Function( UrgentCard value)?  urgent,TResult Function( CrisisCard value)?  crisis,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PackagesCard() when packages != null:
return packages(_that);case BookingCardData() when booking != null:
return booking(_that);case SlotsCard() when slots != null:
return slots(_that);case UrgentCard() when urgent != null:
return urgent(_that);case CrisisCard() when crisis != null:
return crisis(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PackagesCard value)  packages,required TResult Function( BookingCardData value)  booking,required TResult Function( SlotsCard value)  slots,required TResult Function( UrgentCard value)  urgent,required TResult Function( CrisisCard value)  crisis,}){
final _that = this;
switch (_that) {
case PackagesCard():
return packages(_that);case BookingCardData():
return booking(_that);case SlotsCard():
return slots(_that);case UrgentCard():
return urgent(_that);case CrisisCard():
return crisis(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PackagesCard value)?  packages,TResult? Function( BookingCardData value)?  booking,TResult? Function( SlotsCard value)?  slots,TResult? Function( UrgentCard value)?  urgent,TResult? Function( CrisisCard value)?  crisis,}){
final _that = this;
switch (_that) {
case PackagesCard() when packages != null:
return packages(_that);case BookingCardData() when booking != null:
return booking(_that);case SlotsCard() when slots != null:
return slots(_that);case UrgentCard() when urgent != null:
return urgent(_that);case CrisisCard() when crisis != null:
return crisis(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<PackageSummary> packages)?  packages,TResult Function( BookingInfo booking)?  booking,TResult Function( SlotOffer offer)?  slots,TResult Function( String category)?  urgent,TResult Function( String category)?  crisis,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PackagesCard() when packages != null:
return packages(_that.packages);case BookingCardData() when booking != null:
return booking(_that.booking);case SlotsCard() when slots != null:
return slots(_that.offer);case UrgentCard() when urgent != null:
return urgent(_that.category);case CrisisCard() when crisis != null:
return crisis(_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<PackageSummary> packages)  packages,required TResult Function( BookingInfo booking)  booking,required TResult Function( SlotOffer offer)  slots,required TResult Function( String category)  urgent,required TResult Function( String category)  crisis,}) {final _that = this;
switch (_that) {
case PackagesCard():
return packages(_that.packages);case BookingCardData():
return booking(_that.booking);case SlotsCard():
return slots(_that.offer);case UrgentCard():
return urgent(_that.category);case CrisisCard():
return crisis(_that.category);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<PackageSummary> packages)?  packages,TResult? Function( BookingInfo booking)?  booking,TResult? Function( SlotOffer offer)?  slots,TResult? Function( String category)?  urgent,TResult? Function( String category)?  crisis,}) {final _that = this;
switch (_that) {
case PackagesCard() when packages != null:
return packages(_that.packages);case BookingCardData() when booking != null:
return booking(_that.booking);case SlotsCard() when slots != null:
return slots(_that.offer);case UrgentCard() when urgent != null:
return urgent(_that.category);case CrisisCard() when crisis != null:
return crisis(_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class PackagesCard implements ChatCard {
  const PackagesCard( List<PackageSummary> packages, { String? $type}): _packages = packages,$type = $type ?? 'packages';
  factory PackagesCard.fromJson(Map<String, dynamic> json) => _$PackagesCardFromJson(json);

 final  List<PackageSummary> _packages;
 List<PackageSummary> get packages {
  if (_packages is EqualUnmodifiableListView) return _packages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_packages);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of ChatCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackagesCardCopyWith<PackagesCard> get copyWith => _$PackagesCardCopyWithImpl<PackagesCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackagesCardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PackagesCard&&const DeepCollectionEquality().equals(other.packages, _packages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_packages));
}

@override
String toString() {
    return 'ChatCard.packages(packages: $packages)';
}


}

/// @nodoc
abstract mixin class $PackagesCardCopyWith<$Res> implements $ChatCardCopyWith<$Res> {
  factory $PackagesCardCopyWith(PackagesCard value, $Res Function(PackagesCard) _then) = _$PackagesCardCopyWithImpl;
@useResult
$Res call({
 List<PackageSummary> packages
});




}
/// @nodoc
class _$PackagesCardCopyWithImpl<$Res>
    implements $PackagesCardCopyWith<$Res> {
  _$PackagesCardCopyWithImpl(this._self, this._then);

  final PackagesCard _self;
  final $Res Function(PackagesCard) _then;

/// Create a copy of ChatCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? packages = null,}) {
  return _then(PackagesCard(
null == packages ? _self._packages : packages // ignore: cast_nullable_to_non_nullable
as List<PackageSummary>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class BookingCardData implements ChatCard {
  const BookingCardData(this.booking, { String? $type}): $type = $type ?? 'booking';
  factory BookingCardData.fromJson(Map<String, dynamic> json) => _$BookingCardDataFromJson(json);

 final  BookingInfo booking;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ChatCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCardDataCopyWith<BookingCardData> get copyWith => _$BookingCardDataCopyWithImpl<BookingCardData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingCardDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingCardData&&(identical(other.booking, booking) || other.booking == booking));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,booking);
}

@override
String toString() {
    return 'ChatCard.booking(booking: $booking)';
}


}

/// @nodoc
abstract mixin class $BookingCardDataCopyWith<$Res> implements $ChatCardCopyWith<$Res> {
  factory $BookingCardDataCopyWith(BookingCardData value, $Res Function(BookingCardData) _then) = _$BookingCardDataCopyWithImpl;
@useResult
$Res call({
 BookingInfo booking
});


$BookingInfoCopyWith<$Res> get booking;

}
/// @nodoc
class _$BookingCardDataCopyWithImpl<$Res>
    implements $BookingCardDataCopyWith<$Res> {
  _$BookingCardDataCopyWithImpl(this._self, this._then);

  final BookingCardData _self;
  final $Res Function(BookingCardData) _then;

/// Create a copy of ChatCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? booking = null,}) {
  return _then(BookingCardData(
null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as BookingInfo,
  ));
}

/// Create a copy of ChatCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingInfoCopyWith<$Res> get booking {
  
  return $BookingInfoCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class SlotsCard implements ChatCard {
  const SlotsCard(this.offer, { String? $type}): $type = $type ?? 'slots';
  factory SlotsCard.fromJson(Map<String, dynamic> json) => _$SlotsCardFromJson(json);

 final  SlotOffer offer;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ChatCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotsCardCopyWith<SlotsCard> get copyWith => _$SlotsCardCopyWithImpl<SlotsCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlotsCardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SlotsCard&&(identical(other.offer, offer) || other.offer == offer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,offer);
}

@override
String toString() {
    return 'ChatCard.slots(offer: $offer)';
}


}

/// @nodoc
abstract mixin class $SlotsCardCopyWith<$Res> implements $ChatCardCopyWith<$Res> {
  factory $SlotsCardCopyWith(SlotsCard value, $Res Function(SlotsCard) _then) = _$SlotsCardCopyWithImpl;
@useResult
$Res call({
 SlotOffer offer
});


$SlotOfferCopyWith<$Res> get offer;

}
/// @nodoc
class _$SlotsCardCopyWithImpl<$Res>
    implements $SlotsCardCopyWith<$Res> {
  _$SlotsCardCopyWithImpl(this._self, this._then);

  final SlotsCard _self;
  final $Res Function(SlotsCard) _then;

/// Create a copy of ChatCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? offer = null,}) {
  return _then(SlotsCard(
null == offer ? _self.offer : offer // ignore: cast_nullable_to_non_nullable
as SlotOffer,
  ));
}

/// Create a copy of ChatCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SlotOfferCopyWith<$Res> get offer {
  
  return $SlotOfferCopyWith<$Res>(_self.offer, (value) {
    return _then(_self.copyWith(offer: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class UrgentCard implements ChatCard {
  const UrgentCard(this.category, { String? $type}): $type = $type ?? 'urgent';
  factory UrgentCard.fromJson(Map<String, dynamic> json) => _$UrgentCardFromJson(json);

 final  String category;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ChatCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UrgentCardCopyWith<UrgentCard> get copyWith => _$UrgentCardCopyWithImpl<UrgentCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UrgentCardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UrgentCard&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,category);
}

@override
String toString() {
    return 'ChatCard.urgent(category: $category)';
}


}

/// @nodoc
abstract mixin class $UrgentCardCopyWith<$Res> implements $ChatCardCopyWith<$Res> {
  factory $UrgentCardCopyWith(UrgentCard value, $Res Function(UrgentCard) _then) = _$UrgentCardCopyWithImpl;
@useResult
$Res call({
 String category
});




}
/// @nodoc
class _$UrgentCardCopyWithImpl<$Res>
    implements $UrgentCardCopyWith<$Res> {
  _$UrgentCardCopyWithImpl(this._self, this._then);

  final UrgentCard _self;
  final $Res Function(UrgentCard) _then;

/// Create a copy of ChatCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? category = null,}) {
  return _then(UrgentCard(
null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class CrisisCard implements ChatCard {
  const CrisisCard(this.category, { String? $type}): $type = $type ?? 'crisis';
  factory CrisisCard.fromJson(Map<String, dynamic> json) => _$CrisisCardFromJson(json);

 final  String category;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ChatCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrisisCardCopyWith<CrisisCard> get copyWith => _$CrisisCardCopyWithImpl<CrisisCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrisisCardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CrisisCard&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,category);
}

@override
String toString() {
    return 'ChatCard.crisis(category: $category)';
}


}

/// @nodoc
abstract mixin class $CrisisCardCopyWith<$Res> implements $ChatCardCopyWith<$Res> {
  factory $CrisisCardCopyWith(CrisisCard value, $Res Function(CrisisCard) _then) = _$CrisisCardCopyWithImpl;
@useResult
$Res call({
 String category
});




}
/// @nodoc
class _$CrisisCardCopyWithImpl<$Res>
    implements $CrisisCardCopyWith<$Res> {
  _$CrisisCardCopyWithImpl(this._self, this._then);

  final CrisisCard _self;
  final $Res Function(CrisisCard) _then;

/// Create a copy of ChatCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? category = null,}) {
  return _then(CrisisCard(
null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
