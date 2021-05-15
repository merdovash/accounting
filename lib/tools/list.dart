void insertSorted<T>(List<T> list, T element, Function cmp) {
  var it = list.iterator;
  var hasNext = it.moveNext();
  int index = 0;
  while (hasNext && (cmp(it.current, element) < 0)) {
    hasNext = it.moveNext();
    index += 1;
  }
  list.insert(index, element);
}