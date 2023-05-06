class ApplicationConstants {
  static ApplicationConstants? _instance;
  static ApplicationConstants get instance {
    _instance ??= ApplicationConstants._init();
    return _instance!;
  }

  ApplicationConstants._init();
  final String baseUrl = 'https://localhost:7236/';
  final String mobileBaseUrl = 'https://10.0.2.2:7236/';
}
