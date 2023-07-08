class ApplicationConstants {
  static ApplicationConstants? _instance;
  static ApplicationConstants get instance {
    _instance ??= ApplicationConstants._init();
    return _instance!;
  }

  ApplicationConstants._init();
  final String baseUrl = 'http://localhost:5227/';
  final String mobileBaseUrl = 'http://10.0.2.2:5227/';

  final int darkBlueColor = 0xFF364F6B;
  final int blueColor = 0xFF3FC1C9;
  final int whiteColor = 0xFFF5F5F5;
  final int pinkColor = 0xFFFC5185;

  final String unexpectedErrorDefaultMessage = 'Unexpected error occured !';
}
