typedef FirstWhereClosure<T> = bool Function(T);

extension FirstWhere<T> on List<T>? {
  T? firstOrDefault(FirstWhereClosure<T> closure) {
    if (this == null) return null;
    int index = this!.indexWhere(closure);

    if (index != -1) {
      return this![index];
    }
    return null;
  }
}
