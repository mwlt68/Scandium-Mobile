import 'package:scandium/core/init/storage/storage_manager.dart';
import 'package:scandium/product/constants/application_constants.dart';
import 'package:scandium/product/constants/storage_constants.dart';
import 'package:scandium/product/models/base/user.dart';

class UserStorageManager {
  static Future<String> getUserToken() async {
    var user = await StorageManager.getObject(
        User(), StorageConstants.instance.userKey);
    var token = user?.token ?? ApplicationConstants.instance.empty;
    return token;
  }
}
