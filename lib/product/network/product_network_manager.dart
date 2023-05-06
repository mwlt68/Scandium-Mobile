import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:scandium/core/init/network/network_manager.dart';
import 'package:scandium/product/constants/application_constants.dart';

class ProductNetworkManager extends NetworkManager {
  ProductNetworkManager()
      : super(
            baseOptions: BaseOptions(
                baseUrl: kIsWeb
                    ? ApplicationConstants.instance.baseUrl
                    : ApplicationConstants.instance.mobileBaseUrl));
}
