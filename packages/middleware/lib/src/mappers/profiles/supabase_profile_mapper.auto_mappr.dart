// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// AutoMapprGenerator
// **************************************************************************

// ignore_for_file: type=lint, unnecessary_cast, unused_local_variable

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_mappr_annotation/auto_mappr_annotation.dart' as _i1;
import 'package:client_models/src/dto/users/basic_profile_dto.dart' as _i5;
import 'package:client_models/src/dto/users/extended_profile_dto.dart' as _i3;
import 'package:client_supabase/src/models/profile_extension_row.dart' as _i2;
import 'package:client_supabase/src/models/profile_full.dart' as _i4;
import 'package:middleware/src/mappers/profiles/supabase_profile_mapper.dart'
    as _i6;

/// {@template package:middleware/src/mappers/profiles/supabase_profile_mapper.dart}
/// Available mappings:
/// - `ProfileExtensionRow` → `ExtendedProfileDTO`.
/// - `ProfileFull` → `BasicProfileDTO`.
/// {@endtemplate}
class $SupabaseProfileMapper implements _i1.AutoMapprInterface {
  const $SupabaseProfileMapper();

  Type _typeOf<T>() => T;

  List<_i1.AutoMapprInterface> get _delegates => const [];

  /// {@macro AutoMapprInterface:canConvert}
  /// {@macro package:middleware/src/mappers/profiles/supabase_profile_mapper.dart}
  @override
  bool canConvert<SOURCE, TARGET>({bool recursive = true}) {
    final sourceTypeOf = _typeOf<SOURCE>();
    final targetTypeOf = _typeOf<TARGET>();
    if ((sourceTypeOf == _typeOf<_i2.ProfileExtensionRow>() ||
            sourceTypeOf == _typeOf<_i2.ProfileExtensionRow?>()) &&
        (targetTypeOf == _typeOf<_i3.ExtendedProfileDTO>() ||
            targetTypeOf == _typeOf<_i3.ExtendedProfileDTO?>())) {
      return true;
    }
    if ((sourceTypeOf == _typeOf<_i4.ProfileFull>() ||
            sourceTypeOf == _typeOf<_i4.ProfileFull?>()) &&
        (targetTypeOf == _typeOf<_i5.BasicProfileDTO>() ||
            targetTypeOf == _typeOf<_i5.BasicProfileDTO?>())) {
      return true;
    }
    if (recursive) {
      for (final mappr in _delegates) {
        if (mappr.canConvert<SOURCE, TARGET>()) {
          return true;
        }
      }
    }
    return false;
  }

  /// {@macro AutoMapprInterface:convert}
  /// {@macro package:middleware/src/mappers/profiles/supabase_profile_mapper.dart}
  @override
  TARGET convert<SOURCE, TARGET>(SOURCE? model) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return _convert(model)!;
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.convert(model)!;
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// {@macro AutoMapprInterface:tryConvert}
  /// {@macro package:middleware/src/mappers/profiles/supabase_profile_mapper.dart}
  @override
  TARGET? tryConvert<SOURCE, TARGET>(
    SOURCE? model, {
    void Function(Object error, StackTrace stackTrace, SOURCE? source)?
    onMappingError,
  }) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return _safeConvert(model, onMappingError: onMappingError);
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.tryConvert(model, onMappingError: onMappingError);
      }
    }

    return null;
  }

  /// {@macro AutoMapprInterface:convertIterable}
  /// {@macro package:middleware/src/mappers/profiles/supabase_profile_mapper.dart}
  @override
  Iterable<TARGET> convertIterable<SOURCE, TARGET>(Iterable<SOURCE?> model) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return model.map<TARGET>((item) => _convert(item)!);
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.convertIterable(model);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// For iterable items, converts from SOURCE to TARGET if such mapping is configured, into Iterable.
  ///
  /// When an item in the source iterable is null, uses `whenSourceIsNull` if defined or null
  ///
  /// {@macro package:middleware/src/mappers/profiles/supabase_profile_mapper.dart}
  @override
  Iterable<TARGET?> tryConvertIterable<SOURCE, TARGET>(
    Iterable<SOURCE?> model, {
    void Function(Object error, StackTrace stackTrace, SOURCE? source)?
    onMappingError,
  }) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return model.map<TARGET?>(
        (item) => _safeConvert(item, onMappingError: onMappingError),
      );
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.tryConvertIterable(model, onMappingError: onMappingError);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// {@macro AutoMapprInterface:convertList}
  /// {@macro package:middleware/src/mappers/profiles/supabase_profile_mapper.dart}
  @override
  List<TARGET> convertList<SOURCE, TARGET>(Iterable<SOURCE?> model) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return convertIterable<SOURCE, TARGET>(model).toList();
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.convertList(model);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// For iterable items, converts from SOURCE to TARGET if such mapping is configured, into List.
  ///
  /// When an item in the source iterable is null, uses `whenSourceIsNull` if defined or null
  ///
  /// {@macro package:middleware/src/mappers/profiles/supabase_profile_mapper.dart}
  @override
  List<TARGET?> tryConvertList<SOURCE, TARGET>(
    Iterable<SOURCE?> model, {
    void Function(Object error, StackTrace stackTrace, SOURCE? source)?
    onMappingError,
  }) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return tryConvertIterable<SOURCE, TARGET>(
        model,
        onMappingError: onMappingError,
      ).toList();
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.tryConvertList(model, onMappingError: onMappingError);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// {@macro AutoMapprInterface:convertSet}
  /// {@macro package:middleware/src/mappers/profiles/supabase_profile_mapper.dart}
  @override
  Set<TARGET> convertSet<SOURCE, TARGET>(Iterable<SOURCE?> model) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return convertIterable<SOURCE, TARGET>(model).toSet();
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.convertSet(model);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// For iterable items, converts from SOURCE to TARGET if such mapping is configured, into Set.
  ///
  /// When an item in the source iterable is null, uses `whenSourceIsNull` if defined or null
  ///
  /// {@macro package:middleware/src/mappers/profiles/supabase_profile_mapper.dart}
  @override
  Set<TARGET?> tryConvertSet<SOURCE, TARGET>(
    Iterable<SOURCE?> model, {
    void Function(Object error, StackTrace stackTrace, SOURCE? source)?
    onMappingError,
  }) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return tryConvertIterable<SOURCE, TARGET>(
        model,
        onMappingError: onMappingError,
      ).toSet();
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.tryConvertSet(model, onMappingError: onMappingError);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  TARGET? _convert<SOURCE, TARGET>(
    SOURCE? model, {
    bool canReturnNull = false,
  }) {
    final sourceTypeOf = _typeOf<SOURCE>();
    final targetTypeOf = _typeOf<TARGET>();
    if ((sourceTypeOf == _typeOf<_i2.ProfileExtensionRow>() ||
            sourceTypeOf == _typeOf<_i2.ProfileExtensionRow?>()) &&
        (targetTypeOf == _typeOf<_i3.ExtendedProfileDTO>() ||
            targetTypeOf == _typeOf<_i3.ExtendedProfileDTO?>())) {
      if (canReturnNull && model == null) {
        return null;
      }
      return (_map__i2$ProfileExtensionRow_To__i3$ExtendedProfileDTO(
            (model as _i2.ProfileExtensionRow?),
          )
          as TARGET);
    }
    if ((sourceTypeOf == _typeOf<_i4.ProfileFull>() ||
            sourceTypeOf == _typeOf<_i4.ProfileFull?>()) &&
        (targetTypeOf == _typeOf<_i5.BasicProfileDTO>() ||
            targetTypeOf == _typeOf<_i5.BasicProfileDTO?>())) {
      if (canReturnNull && model == null) {
        return null;
      }
      return (_map__i4$ProfileFull_To__i5$BasicProfileDTO(
            (model as _i4.ProfileFull?),
          )
          as TARGET);
    }
    throw Exception('No ${model.runtimeType} -> $targetTypeOf mapping.');
  }

  TARGET? _safeConvert<SOURCE, TARGET>(
    SOURCE? model, {
    void Function(Object error, StackTrace stackTrace, SOURCE? source)?
    onMappingError,
  }) {
    if (!useSafeMapping<SOURCE, TARGET>()) {
      return _convert(model, canReturnNull: true);
    }
    try {
      return _convert(model, canReturnNull: true);
    } catch (e, s) {
      onMappingError?.call(e, s, model);
      return null;
    }
  }

  /// {@macro AutoMapprInterface:useSafeMapping}
  /// {@macro package:middleware/src/mappers/profiles/supabase_profile_mapper.dart}
  @override
  bool useSafeMapping<SOURCE, TARGET>() {
    return false;
  }

  _i3.ExtendedProfileDTO _map__i2$ProfileExtensionRow_To__i3$ExtendedProfileDTO(
    _i2.ProfileExtensionRow? input,
  ) {
    final model = input;
    if (model == null) {
      throw Exception(
        r'Mapping ProfileExtensionRow → ExtendedProfileDTO failed because ProfileExtensionRow was null, and no default value was provided. '
        r'Consider setting the whenSourceIsNull parameter on the MapType<ProfileExtensionRow, ExtendedProfileDTO> to handle null values during mapping.',
      );
    }
    return _i3.ExtendedProfileDTO(
      objectId: model.id,
      vobGuid: model.vobGuid,
      isCoach: model.isCoach,
      canShowEmail: model.canShowEmail,
      canShowContactNumber: model.canShowContact,
      canShowDateOfBirth: model.canShowBirthday,
      SSANumber: model.ssaNumber,
      membershipType: _i6.SupabaseProfileMapper.mapMembershipType(model),
      emergencyContactNumber: model.emergencyContactNumber,
    );
  }

  _i5.BasicProfileDTO _map__i4$ProfileFull_To__i5$BasicProfileDTO(
    _i4.ProfileFull? input,
  ) {
    final model = input;
    if (model == null) {
      throw Exception(
        r'Mapping ProfileFull → BasicProfileDTO failed because ProfileFull was null, and no default value was provided. '
        r'Consider setting the whenSourceIsNull parameter on the MapType<ProfileFull, BasicProfileDTO> to handle null values during mapping.',
      );
    }
    return _i5.BasicProfileDTO(
      objectId: _i6.SupabaseProfileMapper.mapProfileObjectId(model),
      vobGuid: _i6.SupabaseProfileMapper.mapProfileVobGuid(model),
      firstName: _i6.SupabaseProfileMapper.mapFirstName(model),
      lastName: _i6.SupabaseProfileMapper.mapLastName(model),
      email: _i6.SupabaseProfileMapper.mapEmail(model),
      contactNumber: _i6.SupabaseProfileMapper.mapContactNumber(model),
      dateOfBirth: _i6.SupabaseProfileMapper.mapDateOfBirth(model),
      emergencyContactNumber:
          _i6.SupabaseProfileMapper.mapEmergencyContactNumber(model),
      isActive: _i6.SupabaseProfileMapper.mapIsActive(model),
      extendedProfile: _i6.SupabaseProfileMapper.mapExtendedProfile(model),
    );
  }
}
