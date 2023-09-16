typedef FirstWhereClosure = bool Function(dynamic);

extension FirstWhere on List {
  dynamic firstOrDefault(FirstWhereClosure closure) {
    int index = indexWhere(closure);

    if (index != -1) {
      return this[index];
    }
    return null;
  }
}
