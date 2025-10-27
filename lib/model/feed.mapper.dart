// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'feed.dart';

class FeedStateMapper extends ClassMapperBase<FeedState> {
  FeedStateMapper._();

  static FeedStateMapper? _instance;
  static FeedStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FeedStateMapper._());
      BookMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FeedState';

  static Book _$_book(FeedState v) => v._book;
  static const Field<FeedState, Book> _f$_book = Field(
    '_book',
    _$_book,
    key: r'book',
  );
  static int _$_chapter(FeedState v) => v._chapter;
  static const Field<FeedState, int> _f$_chapter = Field(
    '_chapter',
    _$_chapter,
    key: r'chapter',
    opt: true,
    def: 1,
  );
  static int _$_verse(FeedState v) => v._verse;
  static const Field<FeedState, int> _f$_verse = Field(
    '_verse',
    _$_verse,
    key: r'verse',
    opt: true,
    def: 1,
  );
  static bool _$_isRead(FeedState v) => v._isRead;
  static const Field<FeedState, bool> _f$_isRead = Field(
    '_isRead',
    _$_isRead,
    key: r'isRead',
    opt: true,
    def: false,
  );
  static DateTime? _$_dateModified(FeedState v) => v._dateModified;
  static const Field<FeedState, DateTime> _f$_dateModified = Field(
    '_dateModified',
    _$_dateModified,
    key: r'dateModified',
    opt: true,
  );
  static Book _$book(FeedState v) => v.book;
  static const Field<FeedState, Book> _f$book = Field(
    'book',
    _$book,
    mode: FieldMode.member,
  );
  static int _$chapter(FeedState v) => v.chapter;
  static const Field<FeedState, int> _f$chapter = Field(
    'chapter',
    _$chapter,
    mode: FieldMode.member,
  );
  static DateTime? _$dateModified(FeedState v) => v.dateModified;
  static const Field<FeedState, DateTime> _f$dateModified = Field(
    'dateModified',
    _$dateModified,
    mode: FieldMode.member,
  );
  static bool _$isRead(FeedState v) => v.isRead;
  static const Field<FeedState, bool> _f$isRead = Field(
    'isRead',
    _$isRead,
    mode: FieldMode.member,
  );
  static int _$verse(FeedState v) => v.verse;
  static const Field<FeedState, int> _f$verse = Field(
    'verse',
    _$verse,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<FeedState> fields = const {
    #_book: _f$_book,
    #_chapter: _f$_chapter,
    #_verse: _f$_verse,
    #_isRead: _f$_isRead,
    #_dateModified: _f$_dateModified,
    #book: _f$book,
    #chapter: _f$chapter,
    #dateModified: _f$dateModified,
    #isRead: _f$isRead,
    #verse: _f$verse,
  };

  static FeedState _instantiate(DecodingData data) {
    return FeedState(
      book: data.dec(_f$_book),
      chapter: data.dec(_f$_chapter),
      verse: data.dec(_f$_verse),
      isRead: data.dec(_f$_isRead),
      dateModified: data.dec(_f$_dateModified),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FeedState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FeedState>(map);
  }

  static FeedState fromJson(String json) {
    return ensureInitialized().decodeJson<FeedState>(json);
  }
}

mixin FeedStateMappable {
  String toJson() {
    return FeedStateMapper.ensureInitialized().encodeJson<FeedState>(
      this as FeedState,
    );
  }

  Map<String, dynamic> toMap() {
    return FeedStateMapper.ensureInitialized().encodeMap<FeedState>(
      this as FeedState,
    );
  }

  FeedStateCopyWith<FeedState, FeedState, FeedState> get copyWith =>
      _FeedStateCopyWithImpl<FeedState, FeedState>(
        this as FeedState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FeedStateMapper.ensureInitialized().stringifyValue(
      this as FeedState,
    );
  }

  @override
  bool operator ==(Object other) {
    return FeedStateMapper.ensureInitialized().equalsValue(
      this as FeedState,
      other,
    );
  }

  @override
  int get hashCode {
    return FeedStateMapper.ensureInitialized().hashValue(this as FeedState);
  }
}

extension FeedStateValueCopy<$R, $Out> on ObjectCopyWith<$R, FeedState, $Out> {
  FeedStateCopyWith<$R, FeedState, $Out> get $asFeedState =>
      $base.as((v, t, t2) => _FeedStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FeedStateCopyWith<$R, $In extends FeedState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  BookCopyWith<$R, Book, Book> get _book;
  $R call({
    Book? book,
    int? chapter,
    int? verse,
    bool? isRead,
    DateTime? dateModified,
  });
  FeedStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FeedStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FeedState, $Out>
    implements FeedStateCopyWith<$R, FeedState, $Out> {
  _FeedStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FeedState> $mapper =
      FeedStateMapper.ensureInitialized();
  @override
  BookCopyWith<$R, Book, Book> get _book =>
      $value._book.copyWith.$chain((v) => call(book: v));
  @override
  $R call({
    Book? book,
    int? chapter,
    int? verse,
    bool? isRead,
    Object? dateModified = $none,
  }) => $apply(
    FieldCopyWithData({
      if (book != null) #book: book,
      if (chapter != null) #chapter: chapter,
      if (verse != null) #verse: verse,
      if (isRead != null) #isRead: isRead,
      if (dateModified != $none) #dateModified: dateModified,
    }),
  );
  @override
  FeedState $make(CopyWithData data) => FeedState(
    book: data.get(#book, or: $value._book),
    chapter: data.get(#chapter, or: $value._chapter),
    verse: data.get(#verse, or: $value._verse),
    isRead: data.get(#isRead, or: $value._isRead),
    dateModified: data.get(#dateModified, or: $value._dateModified),
  );

  @override
  FeedStateCopyWith<$R2, FeedState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FeedStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

