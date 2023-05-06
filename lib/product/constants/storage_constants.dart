class StorageConstants {
  static StorageConstants? _instance;
  static StorageConstants get instance {
    _instance ??= StorageConstants._init();
    return _instance!;
  }

  StorageConstants._init();
  final String userKey = 'current_user';
}
