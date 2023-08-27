import 'package:scandium/core/init/network/network_manager.dart';
import 'package:scandium/core/init/storage/storage_manager.dart';
import 'package:scandium/product/constants/storage_constants.dart';
import 'package:scandium/product/helpers/network_helper.dart';
import 'package:scandium/product/models/base/user.dart';

class ProductNetworkManager extends NetworkManager {
  ProductNetworkManager() : super(baseUrl: NetworkHelper.getBaseUrl);

  @override
  Future<String> getToken() async {
    var user = await StorageManager.getObject(
        User(), StorageConstants.instance.userKey);
    var token = user?.token ?? '';
    return 'Bearer $token';
  }
}
