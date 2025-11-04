// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'share_dto.dart';

class ShareDtoMapper extends ClassMapperBase<ShareDto> {
  ShareDtoMapper._();

  static ShareDtoMapper? _instance;
  static ShareDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ShareDtoMapper._());
      FeedStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ShareDto';

  static String _$buildNumber(ShareDto v) => v.buildNumber;
  static const Field<ShareDto, String> _f$buildNumber = Field(
    'buildNumber',
    _$buildNumber,
  );
  static List<FeedState> _$feedStateList(ShareDto v) => v.feedStateList;
  static const Field<ShareDto, List<FeedState>> _f$feedStateList = Field(
    'feedStateList',
    _$feedStateList,
  );

  @override
  final MappableFields<ShareDto> fields = const {
    #buildNumber: _f$buildNumber,
    #feedStateList: _f$feedStateList,
  };

  static ShareDto _instantiate(DecodingData data) {
    return ShareDto(
      buildNumber: data.dec(_f$buildNumber),
      feedStateList: data.dec(_f$feedStateList),
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
  ListCopyWith<$R, FeedState, FeedStateCopyWith<$R, FeedState, FeedState>>
  get feedStateList;
  $R call({String? buildNumber, List<FeedState>? feedStateList});
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
  ListCopyWith<$R, FeedState, FeedStateCopyWith<$R, FeedState, FeedState>>
  get feedStateList => ListCopyWith(
    $value.feedStateList,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(feedStateList: v),
  );
  @override
  $R call({String? buildNumber, List<FeedState>? feedStateList}) => $apply(
    FieldCopyWithData({
      if (buildNumber != null) #buildNumber: buildNumber,
      if (feedStateList != null) #feedStateList: feedStateList,
    }),
  );
  @override
  ShareDto $make(CopyWithData data) => ShareDto(
    buildNumber: data.get(#buildNumber, or: $value.buildNumber),
    feedStateList: data.get(#feedStateList, or: $value.feedStateList),
  );

  @override
  ShareDtoCopyWith<$R2, ShareDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ShareDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

