class BaseList<T> extends Iterable<T> {
  const BaseList(this._items);

  final List<T> _items;

  @override
  Iterator<T> get iterator => _items.iterator;

  T operator [](int i) => _items[i];
}
