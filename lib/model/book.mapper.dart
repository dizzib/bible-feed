// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'book.dart';

class BookMapper extends ClassMapperBase<Book> {
  BookMapper._();

  static BookMapper? _instance;
  static BookMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BookMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Book';

  static String _$key(Book v) => v.key;
  static const Field<Book, String> _f$key = Field('key', _$key);
  static String _$name(Book v) => v.name;
  static const Field<Book, String> _f$name = Field('name', _$name);
  static int _$chapterCount(Book v) => v.chapterCount;
  static const Field<Book, int> _f$chapterCount = Field(
    'chapterCount',
    _$chapterCount,
  );

  @override
  final MappableFields<Book> fields = const {
    #key: _f$key,
    #name: _f$name,
    #chapterCount: _f$chapterCount,
  };

  static Book _instantiate(DecodingData data) {
    return Book(data.dec(_f$key), data.dec(_f$name), data.dec(_f$chapterCount));
  }

  @override
  final Function instantiate = _instantiate;

  static Book fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Book>(map);
  }

  static Book fromJson(String json) {
    return ensureInitialized().decodeJson<Book>(json);
  }
}

mixin BookMappable {
  String toJson() {
    return BookMapper.ensureInitialized().encodeJson<Book>(this as Book);
  }

  Map<String, dynamic> toMap() {
    return BookMapper.ensureInitialized().encodeMap<Book>(this as Book);
  }

  BookCopyWith<Book, Book, Book> get copyWith =>
      _BookCopyWithImpl<Book, Book>(this as Book, $identity, $identity);
  @override
  String toString() {
    return BookMapper.ensureInitialized().stringifyValue(this as Book);
  }

  @override
  bool operator ==(Object other) {
    return BookMapper.ensureInitialized().equalsValue(this as Book, other);
  }

  @override
  int get hashCode {
    return BookMapper.ensureInitialized().hashValue(this as Book);
  }
}

extension BookValueCopy<$R, $Out> on ObjectCopyWith<$R, Book, $Out> {
  BookCopyWith<$R, Book, $Out> get $asBook =>
      $base.as((v, t, t2) => _BookCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BookCopyWith<$R, $In extends Book, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? key, String? name, int? chapterCount});
  BookCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BookCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Book, $Out>
    implements BookCopyWith<$R, Book, $Out> {
  _BookCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Book> $mapper = BookMapper.ensureInitialized();
  @override
  $R call({String? key, String? name, int? chapterCount}) => $apply(
    FieldCopyWithData({
      if (key != null) #key: key,
      if (name != null) #name: name,
      if (chapterCount != null) #chapterCount: chapterCount,
    }),
  );
  @override
  Book $make(CopyWithData data) => Book(
    data.get(#key, or: $value.key),
    data.get(#name, or: $value.name),
    data.get(#chapterCount, or: $value.chapterCount),
  );

  @override
  BookCopyWith<$R2, Book, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _BookCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

