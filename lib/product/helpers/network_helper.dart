import 'package:flutter/foundation.dart';
import 'package:scandium/product/constants/application_constants.dart';

class NetworkHelper {
  static get getBaseUrl => kIsWeb
      ? ApplicationConstants.instance.baseUrl
      : ApplicationConstants.instance.mobileBaseUrl;
}
