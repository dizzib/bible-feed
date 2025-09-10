class BaseIterable<T> extends Iterable<T> {
  const BaseIterable(this._items);

  final List<T> _items;

  @override
  Iterator<T> get iterator => _items.iterator;

  T operator [](int i) => _items[i];
}
