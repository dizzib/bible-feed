// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'sync_dto.dart';

class SyncDtoMapper extends ClassMapperBase<SyncDto> {
  SyncDtoMapper._();

  static SyncDtoMapper? _instance;
  static SyncDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SyncDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SyncDto';

  static String _$version(SyncDto v) => v.version;
  static const Field<SyncDto, String> _f$version = Field('version', _$version);

  @override
  final MappableFields<SyncDto> fields = const {#version: _f$version};

  static SyncDto _instantiate(DecodingData data) {
    return SyncDto(data.dec(_f$version));
  }

  @override
  final Function instantiate = _instantiate;

  static SyncDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SyncDto>(map);
  }

  static SyncDto fromJson(String json) {
    return ensureInitialized().decodeJson<SyncDto>(json);
  }
}

mixin SyncDtoMappable {
  String toJson() {
    return SyncDtoMapper.ensureInitialized().encodeJson<SyncDto>(
      this as SyncDto,
    );
  }

  Map<String, dynamic> toMap() {
    return SyncDtoMapper.ensureInitialized().encodeMap<SyncDto>(
      this as SyncDto,
    );
  }

  SyncDtoCopyWith<SyncDto, SyncDto, SyncDto> get copyWith =>
      _SyncDtoCopyWithImpl<SyncDto, SyncDto>(
        this as SyncDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SyncDtoMapper.ensureInitialized().stringifyValue(this as SyncDto);
  }

  @override
  bool operator ==(Object other) {
    return SyncDtoMapper.ensureInitialized().equalsValue(
      this as SyncDto,
      other,
    );
  }

  @override
  int get hashCode {
    return SyncDtoMapper.ensureInitialized().hashValue(this as SyncDto);
  }
}

extension SyncDtoValueCopy<$R, $Out> on ObjectCopyWith<$R, SyncDto, $Out> {
  SyncDtoCopyWith<$R, SyncDto, $Out> get $asSyncDto =>
      $base.as((v, t, t2) => _SyncDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SyncDtoCopyWith<$R, $In extends SyncDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? version});
  SyncDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SyncDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SyncDto, $Out>
    implements SyncDtoCopyWith<$R, SyncDto, $Out> {
  _SyncDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SyncDto> $mapper =
      SyncDtoMapper.ensureInitialized();
  @override
  $R call({String? version}) =>
      $apply(FieldCopyWithData({if (version != null) #version: version}));
  @override
  SyncDto $make(CopyWithData data) =>
      SyncDto(data.get(#version, or: $value.version));

  @override
  SyncDtoCopyWith<$R2, SyncDto, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SyncDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

