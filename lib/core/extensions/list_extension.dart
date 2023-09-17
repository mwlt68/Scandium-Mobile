typedef FirstWhereClosure<T> = bool Function(T);

extension FirstWhere<T> on List<T> {
  T? firstOrDefault(FirstWhereClosure<T> closure) {
    int index = indexWhere(closure);

    if (index != -1) {
      return this[index];
    }
    return null;
  }
}
