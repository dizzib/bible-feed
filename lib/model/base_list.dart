class BaseList<T> extends Iterable<T> {
  const BaseList(this._items);

  final List<T> _items;

  @override
  Iterator<T> get iterator => _items.iterator;

  T operator [](int i) => _items[i];

  int indexOf(T item) => _items.indexOf(item);

  List<T> sublistTo(int end) => _items.sublist(0, end);
}
