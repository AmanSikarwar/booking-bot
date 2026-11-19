// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Localized {

 String get en; String get hi;
/// Create a copy of Localized
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalizedCopyWith<Localized> get copyWith => _$LocalizedCopyWithImpl<Localized>(this as Localized, _$identity);

  /// Serializes this Localized to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Localized;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Localized&&(identical(other.en, _this.en) || other.en == _this.en)&&(identical(other.hi, _this.hi) || other.hi == _this.hi));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Localized;
  return Object.hash(runtimeType,_this.en,_this.hi);
}

@override
String toString() {
  final _this = this as Localized;
  return 'Localized(en: ${_this.en}, hi: ${_this.hi})';
}


}

/// @nodoc
abstract mixin class $LocalizedCopyWith<$Res>  {
  factory $LocalizedCopyWith(Localized value, $Res Function(Localized) _then) = _$LocalizedCopyWithImpl;
@useResult
$Res call({
 String en, String hi
});




}
/// @nodoc
class _$LocalizedCopyWithImpl<$Res>
    implements $LocalizedCopyWith<$Res> {
  _$LocalizedCopyWithImpl(this._self, this._then);

  final Localized _self;
  final $Res Function(Localized) _then;

/// Create a copy of Localized
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? en = null,Object? hi = null,}) {
  return _then(Localized(
en: null == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as String,hi: null == hi ? _self.hi : hi // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Localized].
extension LocalizedPatterns on Localized {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Localized value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Localized() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Localized value)  $default,){
final _that = this;
switch (_that) {
case _Localized():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Localized value)?  $default,){
final _that = this;
switch (_that) {
case _Localized() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String en,  String hi)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Localized() when $default != null:
return $default(_that.en,_that.hi);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String en,  String hi)  $default,) {final _that = this;
switch (_that) {
case _Localized():
return $default(_that.en,_that.hi);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String en,  String hi)?  $default,) {final _that = this;
switch (_that) {
case _Localized() when $default != null:
return $default(_that.en,_that.hi);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Localized extends Localized {
  const _Localized({required this.en, required this.hi}): super._();
  factory _Localized.fromJson(Map<String, dynamic> json) => _$LocalizedFromJson(json);

@override final  String en;
@override final  String hi;

/// Create a copy of Localized
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalizedCopyWith<_Localized> get copyWith => __$LocalizedCopyWithImpl<_Localized>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocalizedToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Localized&&(identical(other.en, en) || other.en == en)&&(identical(other.hi, hi) || other.hi == hi));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,en,hi);
}

@override
String toString() {
    return 'Localized(en: $en, hi: $hi)';
}


}

/// @nodoc
abstract mixin class _$LocalizedCopyWith<$Res> implements $LocalizedCopyWith<$Res> {
  factory _$LocalizedCopyWith(_Localized value, $Res Function(_Localized) _then) = __$LocalizedCopyWithImpl;
@override @useResult
$Res call({
 String en, String hi
});




}
/// @nodoc
class __$LocalizedCopyWithImpl<$Res>
    implements _$LocalizedCopyWith<$Res> {
  __$LocalizedCopyWithImpl(this._self, this._then);

  final _Localized _self;
  final $Res Function(_Localized) _then;

/// Create a copy of Localized
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? en = null,Object? hi = null,}) {
  return _then(_Localized(
en: null == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as String,hi: null == hi ? _self.hi : hi // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$LabPackage {

 String get id; Localized get name; String get category; List<String> get tests; int get testCount; int get priceInr; int get mrpInr; int get fastingHours; String get sampleType; int get reportTatHours; Localized get description;
/// Create a copy of LabPackage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LabPackageCopyWith<LabPackage> get copyWith => _$LabPackageCopyWithImpl<LabPackage>(this as LabPackage, _$identity);

  /// Serializes this LabPackage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LabPackage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LabPackage&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.category, _this.category) || other.category == _this.category)&&const DeepCollectionEquality().equals(other.tests, _this.tests)&&(identical(other.testCount, _this.testCount) || other.testCount == _this.testCount)&&(identical(other.priceInr, _this.priceInr) || other.priceInr == _this.priceInr)&&(identical(other.mrpInr, _this.mrpInr) || other.mrpInr == _this.mrpInr)&&(identical(other.fastingHours, _this.fastingHours) || other.fastingHours == _this.fastingHours)&&(identical(other.sampleType, _this.sampleType) || other.sampleType == _this.sampleType)&&(identical(other.reportTatHours, _this.reportTatHours) || other.reportTatHours == _this.reportTatHours)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LabPackage;
  return Object.hash(runtimeType,_this.id,_this.name,_this.category,const DeepCollectionEquality().hash(_this.tests),_this.testCount,_this.priceInr,_this.mrpInr,_this.fastingHours,_this.sampleType,_this.reportTatHours,_this.description);
}

@override
String toString() {
  final _this = this as LabPackage;
  return 'LabPackage(id: ${_this.id}, name: ${_this.name}, category: ${_this.category}, tests: ${_this.tests}, testCount: ${_this.testCount}, priceInr: ${_this.priceInr}, mrpInr: ${_this.mrpInr}, fastingHours: ${_this.fastingHours}, sampleType: ${_this.sampleType}, reportTatHours: ${_this.reportTatHours}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $LabPackageCopyWith<$Res>  {
  factory $LabPackageCopyWith(LabPackage value, $Res Function(LabPackage) _then) = _$LabPackageCopyWithImpl;
@useResult
$Res call({
 String id, Localized name, String category, List<String> tests, int testCount, int priceInr, int mrpInr, int fastingHours, String sampleType, int reportTatHours, Localized description
});


$LocalizedCopyWith<$Res> get name;$LocalizedCopyWith<$Res> get description;

}
/// @nodoc
class _$LabPackageCopyWithImpl<$Res>
    implements $LabPackageCopyWith<$Res> {
  _$LabPackageCopyWithImpl(this._self, this._then);

  final LabPackage _self;
  final $Res Function(LabPackage) _then;

/// Create a copy of LabPackage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? tests = null,Object? testCount = null,Object? priceInr = null,Object? mrpInr = null,Object? fastingHours = null,Object? sampleType = null,Object? reportTatHours = null,Object? description = null,}) {
  return _then(LabPackage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as Localized,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,tests: null == tests ? _self.tests : tests // ignore: cast_nullable_to_non_nullable
as List<String>,testCount: null == testCount ? _self.testCount : testCount // ignore: cast_nullable_to_non_nullable
as int,priceInr: null == priceInr ? _self.priceInr : priceInr // ignore: cast_nullable_to_non_nullable
as int,mrpInr: null == mrpInr ? _self.mrpInr : mrpInr // ignore: cast_nullable_to_non_nullable
as int,fastingHours: null == fastingHours ? _self.fastingHours : fastingHours // ignore: cast_nullable_to_non_nullable
as int,sampleType: null == sampleType ? _self.sampleType : sampleType // ignore: cast_nullable_to_non_nullable
as String,reportTatHours: null == reportTatHours ? _self.reportTatHours : reportTatHours // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as Localized,
  ));
}
/// Create a copy of LabPackage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedCopyWith<$Res> get name {
  
  return $LocalizedCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of LabPackage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedCopyWith<$Res> get description {
  
  return $LocalizedCopyWith<$Res>(_self.description, (value) {
    return _then(_self.copyWith(description: value));
  });
}
}


/// Adds pattern-matching-related methods to [LabPackage].
extension LabPackagePatterns on LabPackage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LabPackage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LabPackage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LabPackage value)  $default,){
final _that = this;
switch (_that) {
case _LabPackage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LabPackage value)?  $default,){
final _that = this;
switch (_that) {
case _LabPackage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Localized name,  String category,  List<String> tests,  int testCount,  int priceInr,  int mrpInr,  int fastingHours,  String sampleType,  int reportTatHours,  Localized description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LabPackage() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.tests,_that.testCount,_that.priceInr,_that.mrpInr,_that.fastingHours,_that.sampleType,_that.reportTatHours,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Localized name,  String category,  List<String> tests,  int testCount,  int priceInr,  int mrpInr,  int fastingHours,  String sampleType,  int reportTatHours,  Localized description)  $default,) {final _that = this;
switch (_that) {
case _LabPackage():
return $default(_that.id,_that.name,_that.category,_that.tests,_that.testCount,_that.priceInr,_that.mrpInr,_that.fastingHours,_that.sampleType,_that.reportTatHours,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Localized name,  String category,  List<String> tests,  int testCount,  int priceInr,  int mrpInr,  int fastingHours,  String sampleType,  int reportTatHours,  Localized description)?  $default,) {final _that = this;
switch (_that) {
case _LabPackage() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.tests,_that.testCount,_that.priceInr,_that.mrpInr,_that.fastingHours,_that.sampleType,_that.reportTatHours,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LabPackage implements LabPackage {
  const _LabPackage({required this.id, required this.name, required this.category, required  List<String> tests, required this.testCount, required this.priceInr, required this.mrpInr, required this.fastingHours, required this.sampleType, required this.reportTatHours, required this.description}): _tests = tests;
  factory _LabPackage.fromJson(Map<String, dynamic> json) => _$LabPackageFromJson(json);

@override final  String id;
@override final  Localized name;
@override final  String category;
 final  List<String> _tests;
@override List<String> get tests {
  if (_tests is EqualUnmodifiableListView) return _tests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tests);
}

@override final  int testCount;
@override final  int priceInr;
@override final  int mrpInr;
@override final  int fastingHours;
@override final  String sampleType;
@override final  int reportTatHours;
@override final  Localized description;

/// Create a copy of LabPackage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LabPackageCopyWith<_LabPackage> get copyWith => __$LabPackageCopyWithImpl<_LabPackage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LabPackageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LabPackage&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.tests, _tests)&&(identical(other.testCount, testCount) || other.testCount == testCount)&&(identical(other.priceInr, priceInr) || other.priceInr == priceInr)&&(identical(other.mrpInr, mrpInr) || other.mrpInr == mrpInr)&&(identical(other.fastingHours, fastingHours) || other.fastingHours == fastingHours)&&(identical(other.sampleType, sampleType) || other.sampleType == sampleType)&&(identical(other.reportTatHours, reportTatHours) || other.reportTatHours == reportTatHours)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,category,const DeepCollectionEquality().hash(_tests),testCount,priceInr,mrpInr,fastingHours,sampleType,reportTatHours,description);
}

@override
String toString() {
    return 'LabPackage(id: $id, name: $name, category: $category, tests: $tests, testCount: $testCount, priceInr: $priceInr, mrpInr: $mrpInr, fastingHours: $fastingHours, sampleType: $sampleType, reportTatHours: $reportTatHours, description: $description)';
}


}

/// @nodoc
abstract mixin class _$LabPackageCopyWith<$Res> implements $LabPackageCopyWith<$Res> {
  factory _$LabPackageCopyWith(_LabPackage value, $Res Function(_LabPackage) _then) = __$LabPackageCopyWithImpl;
@override @useResult
$Res call({
 String id, Localized name, String category, List<String> tests, int testCount, int priceInr, int mrpInr, int fastingHours, String sampleType, int reportTatHours, Localized description
});


@override $LocalizedCopyWith<$Res> get name;@override $LocalizedCopyWith<$Res> get description;

}
/// @nodoc
class __$LabPackageCopyWithImpl<$Res>
    implements _$LabPackageCopyWith<$Res> {
  __$LabPackageCopyWithImpl(this._self, this._then);

  final _LabPackage _self;
  final $Res Function(_LabPackage) _then;

/// Create a copy of LabPackage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? tests = null,Object? testCount = null,Object? priceInr = null,Object? mrpInr = null,Object? fastingHours = null,Object? sampleType = null,Object? reportTatHours = null,Object? description = null,}) {
  return _then(_LabPackage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as Localized,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,tests: null == tests ? _self._tests : tests // ignore: cast_nullable_to_non_nullable
as List<String>,testCount: null == testCount ? _self.testCount : testCount // ignore: cast_nullable_to_non_nullable
as int,priceInr: null == priceInr ? _self.priceInr : priceInr // ignore: cast_nullable_to_non_nullable
as int,mrpInr: null == mrpInr ? _self.mrpInr : mrpInr // ignore: cast_nullable_to_non_nullable
as int,fastingHours: null == fastingHours ? _self.fastingHours : fastingHours // ignore: cast_nullable_to_non_nullable
as int,sampleType: null == sampleType ? _self.sampleType : sampleType // ignore: cast_nullable_to_non_nullable
as String,reportTatHours: null == reportTatHours ? _self.reportTatHours : reportTatHours // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as Localized,
  ));
}

/// Create a copy of LabPackage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedCopyWith<$Res> get name {
  
  return $LocalizedCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of LabPackage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedCopyWith<$Res> get description {
  
  return $LocalizedCopyWith<$Res>(_self.description, (value) {
    return _then(_self.copyWith(description: value));
  });
}
}


/// @nodoc
mixin _$Catalog {

 int get version; List<LabPackage> get packages;
/// Create a copy of Catalog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogCopyWith<Catalog> get copyWith => _$CatalogCopyWithImpl<Catalog>(this as Catalog, _$identity);

  /// Serializes this Catalog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Catalog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Catalog&&(identical(other.version, _this.version) || other.version == _this.version)&&const DeepCollectionEquality().equals(other.packages, _this.packages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Catalog;
  return Object.hash(runtimeType,_this.version,const DeepCollectionEquality().hash(_this.packages));
}

@override
String toString() {
  final _this = this as Catalog;
  return 'Catalog(version: ${_this.version}, packages: ${_this.packages})';
}


}

/// @nodoc
abstract mixin class $CatalogCopyWith<$Res>  {
  factory $CatalogCopyWith(Catalog value, $Res Function(Catalog) _then) = _$CatalogCopyWithImpl;
@useResult
$Res call({
 int version, List<LabPackage> packages
});




}
/// @nodoc
class _$CatalogCopyWithImpl<$Res>
    implements $CatalogCopyWith<$Res> {
  _$CatalogCopyWithImpl(this._self, this._then);

  final Catalog _self;
  final $Res Function(Catalog) _then;

/// Create a copy of Catalog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? packages = null,}) {
  return _then(Catalog(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,packages: null == packages ? _self.packages : packages // ignore: cast_nullable_to_non_nullable
as List<LabPackage>,
  ));
}

}


/// Adds pattern-matching-related methods to [Catalog].
extension CatalogPatterns on Catalog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Catalog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Catalog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Catalog value)  $default,){
final _that = this;
switch (_that) {
case _Catalog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Catalog value)?  $default,){
final _that = this;
switch (_that) {
case _Catalog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  List<LabPackage> packages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Catalog() when $default != null:
return $default(_that.version,_that.packages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  List<LabPackage> packages)  $default,) {final _that = this;
switch (_that) {
case _Catalog():
return $default(_that.version,_that.packages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  List<LabPackage> packages)?  $default,) {final _that = this;
switch (_that) {
case _Catalog() when $default != null:
return $default(_that.version,_that.packages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Catalog implements Catalog {
  const _Catalog({required this.version, required  List<LabPackage> packages}): _packages = packages;
  factory _Catalog.fromJson(Map<String, dynamic> json) => _$CatalogFromJson(json);

@override final  int version;
 final  List<LabPackage> _packages;
@override List<LabPackage> get packages {
  if (_packages is EqualUnmodifiableListView) return _packages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_packages);
}


/// Create a copy of Catalog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogCopyWith<_Catalog> get copyWith => __$CatalogCopyWithImpl<_Catalog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Catalog&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.packages, _packages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_packages));
}

@override
String toString() {
    return 'Catalog(version: $version, packages: $packages)';
}


}

/// @nodoc
abstract mixin class _$CatalogCopyWith<$Res> implements $CatalogCopyWith<$Res> {
  factory _$CatalogCopyWith(_Catalog value, $Res Function(_Catalog) _then) = __$CatalogCopyWithImpl;
@override @useResult
$Res call({
 int version, List<LabPackage> packages
});




}
/// @nodoc
class __$CatalogCopyWithImpl<$Res>
    implements _$CatalogCopyWith<$Res> {
  __$CatalogCopyWithImpl(this._self, this._then);

  final _Catalog _self;
  final $Res Function(_Catalog) _then;

/// Create a copy of Catalog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? packages = null,}) {
  return _then(_Catalog(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,packages: null == packages ? _self._packages : packages // ignore: cast_nullable_to_non_nullable
as List<LabPackage>,
  ));
}


}

// dart format on
