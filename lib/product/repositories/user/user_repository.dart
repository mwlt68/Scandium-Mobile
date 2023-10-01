import 'dart:async';
import 'package:scandium/core/base/models/base_response_model.dart';
import 'package:scandium/core/init/network/network_manager.dart';
import 'package:scandium/core/init/storage/storage_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:scandium/product/models/response/user_search_response_model.dart';
import 'package:scandium/product/repositories/user/authentication_request_model.dart';
import 'package:scandium/product/repositories/user/register_request_model.dart';

import '../../constants/storage_constants.dart';
import '../../models/base/user.dart';

class _AuthenticationPaths {
  static const authenticate = "user/authentication";
  static const searching = "user/searching";
  static const register = "user/insert";
}

class UserRepository {
  final _controller = StreamController<User?>.broadcast();
  late final INetworkManager _networkManager;

  UserRepository(INetworkManager networkManager)
      : _networkManager = networkManager;

  Stream<User?> get currentUser async* {
    var user = await StorageManager.getObject(
        User(), StorageConstants.instance.userKey);
    if (user?.token != null) {
      bool hasExpired = JwtDecoder.isExpired(user!.token!);
      if (!hasExpired) {
        yield user;
      } else {
        yield null;
      }
    } else {
      yield null;
    }
    yield* _controller.stream;
  }

  Future<SingleBaseResponseModel<User>?> authenticate(
      {required String username, required String password}) async {
    final response = await _networkManager
        .post<SingleBaseResponseModel<User>, User, AuthenticationRequestModel>(
      User(),
      _AuthenticationPaths.authenticate,
      data: AuthenticationRequestModel(username: username, password: password),
    );
    if (response.model?.value != null && response.model!.hasNotError) {
      await StorageManager.saveObject(
          response.model!.value!, StorageConstants.instance.userKey);
      _controller.add(response.model!.value!);
    } else {
      _controller.add(null);
    }
    return response.model;
  }

  Future<SingleBaseResponseModel<User>?> register(
      String username, String password, String passwordConfirm) async {
    final response = await _networkManager
        .post<SingleBaseResponseModel<User>, User, RegisterRequestModel>(
      User(),
      _AuthenticationPaths.register,
      data: RegisterRequestModel(username, password, passwordConfirm),
    );
    return response.model;
  }

  Future<ListBaseResponseModel<UserSearchResponseModel>?> searchUser(
      {required String username}) async {
    var queryParameters = {'username': username};
    final response = await _networkManager.get<
            ListBaseResponseModel<UserSearchResponseModel>,
            UserSearchResponseModel>(
        UserSearchResponseModel(), _AuthenticationPaths.searching,
        queryParameters: queryParameters);
    return response.model;
  }

  Future<void> logOut() async {
    await StorageManager.remove(StorageConstants.instance.userKey);
    _controller.add(null);
  }

  void dispose() => _controller.close();
}
