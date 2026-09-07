// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'share_dto.dart';

class ShareDtoMapper extends ClassMapperBase<ShareDto> {
  ShareDtoMapper._();

  static ShareDtoMapper? _instance;
  static ShareDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ShareDtoMapper._());
      FeedMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ShareDto';

  static String _$version(ShareDto v) => v.version;
  static const Field<ShareDto, String> _f$version = Field('version', _$version);
  static List<Feed> _$feedList(ShareDto v) => v.feedList;
  static const Field<ShareDto, List<Feed>> _f$feedList = Field(
    'feedList',
    _$feedList,
  );
  static DateTime _$virtualAllDoneDate(ShareDto v) => v.virtualAllDoneDate;
  static const Field<ShareDto, DateTime> _f$virtualAllDoneDate = Field(
    'virtualAllDoneDate',
    _$virtualAllDoneDate,
  );

  @override
  final MappableFields<ShareDto> fields = const {
    #version: _f$version,
    #feedList: _f$feedList,
    #virtualAllDoneDate: _f$virtualAllDoneDate,
  };

  static ShareDto _instantiate(DecodingData data) {
    return ShareDto(
      version: data.dec(_f$version),
      feedList: data.dec(_f$feedList),
      virtualAllDoneDate: data.dec(_f$virtualAllDoneDate),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ShareDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ShareDto>(map);
  }

  static ShareDto fromJson(String json) {
    return ensureInitialized().decodeJson<ShareDto>(json);
  }
}

mixin ShareDtoMappable {
  String toJson() {
    return ShareDtoMapper.ensureInitialized().encodeJson<ShareDto>(
      this as ShareDto,
    );
  }

  Map<String, dynamic> toMap() {
    return ShareDtoMapper.ensureInitialized().encodeMap<ShareDto>(
      this as ShareDto,
    );
  }

  ShareDtoCopyWith<ShareDto, ShareDto, ShareDto> get copyWith =>
      _ShareDtoCopyWithImpl<ShareDto, ShareDto>(
        this as ShareDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ShareDtoMapper.ensureInitialized().stringifyValue(this as ShareDto);
  }

  @override
  bool operator ==(Object other) {
    return ShareDtoMapper.ensureInitialized().equalsValue(
      this as ShareDto,
      other,
    );
  }

  @override
  int get hashCode {
    return ShareDtoMapper.ensureInitialized().hashValue(this as ShareDto);
  }
}

extension ShareDtoValueCopy<$R, $Out> on ObjectCopyWith<$R, ShareDto, $Out> {
  ShareDtoCopyWith<$R, ShareDto, $Out> get $asShareDto =>
      $base.as((v, t, t2) => _ShareDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ShareDtoCopyWith<$R, $In extends ShareDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Feed, FeedCopyWith<$R, Feed, Feed>> get feedList;
  $R call({
    String? version,
    List<Feed>? feedList,
    DateTime? virtualAllDoneDate,
  });
  ShareDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ShareDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ShareDto, $Out>
    implements ShareDtoCopyWith<$R, ShareDto, $Out> {
  _ShareDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ShareDto> $mapper =
      ShareDtoMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Feed, FeedCopyWith<$R, Feed, Feed>> get feedList =>
      ListCopyWith(
        $value.feedList,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(feedList: v),
      );
  @override
  $R call({
    String? version,
    List<Feed>? feedList,
    DateTime? virtualAllDoneDate,
  }) => $apply(
    FieldCopyWithData({
      if (version != null) #version: version,
      if (feedList != null) #feedList: feedList,
      if (virtualAllDoneDate != null) #virtualAllDoneDate: virtualAllDoneDate,
    }),
  );
  @override
  ShareDto $make(CopyWithData data) => ShareDto(
    version: data.get(#version, or: $value.version),
    feedList: data.get(#feedList, or: $value.feedList),
    virtualAllDoneDate: data.get(
      #virtualAllDoneDate,
      or: $value.virtualAllDoneDate,
    ),
  );

  @override
  ShareDtoCopyWith<$R2, ShareDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ShareDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

