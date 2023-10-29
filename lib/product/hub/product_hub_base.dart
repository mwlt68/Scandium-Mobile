import 'package:scandium/core/init/hub/hub_base.dart';
import 'package:scandium/product/storage/user_storage_manager.dart';

class ProductHubBase extends HubBase {
  ProductHubBase(
      {required super.baseUrl,
      required super.hubName,
      required super.hubMethodRegisterModels});

  @override
  Future<String> getToken() async {
    return await UserStorageManager.getUserToken();
  }
}
