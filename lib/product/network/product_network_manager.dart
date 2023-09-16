import 'package:scandium/core/init/network/network_manager.dart';
import 'package:scandium/product/helpers/network_helper.dart';
import 'package:scandium/product/storage/user_storage_manager.dart';

class ProductNetworkManager extends NetworkManager {
  ProductNetworkManager() : super(baseUrl: NetworkHelper.getBaseUrl);

  @override
  Future<String> getToken() async {
    var token = await UserStorageManager.getUserToken();
    return 'Bearer $token';
  }
}
