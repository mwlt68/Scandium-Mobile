import 'package:scandium/core/init/network/network_manager.dart';
import 'package:scandium/product/models/response/friendship_response_model.dart';
import 'package:scandium/product/repositories/friendship_request/approve_request_model.dart';
import 'package:scandium/product/repositories/friendship_request/follow_request_model.dart';

import '../../../core/base/models/base_response_model.dart';

class _FriendshipRequestApiPaths {
  static const String getRequests = "friendship/request";
  static const String follow = "friendship/insert";
  static const String approve = "friendship/approve";
}

class FriendshipRequestRepository {
  late final INetworkManager _networkManager;
  FriendshipRequestRepository(INetworkManager networkManager)
      : _networkManager = networkManager;

  Future<ListBaseResponseModel<FriendshipResponseModel>?> getRequests() async {
    final response = await _networkManager.get<
        ListBaseResponseModel<FriendshipResponseModel>,
        FriendshipResponseModel>(
      FriendshipResponseModel(),
      _FriendshipRequestApiPaths.getRequests,
    );
    return response.model;
  }

  Future<SingleBaseResponseModel<FriendshipResponseModel>?> follow(
      String receiverId) async {
    final response = await _networkManager.post<
            SingleBaseResponseModel<FriendshipResponseModel>,
            FriendshipResponseModel,
            FollowRequestModel>(
        FriendshipResponseModel(), _FriendshipRequestApiPaths.follow,
        data: FollowRequestModel(receiverId: receiverId));
    return response.model;
  }

  Future<SingleBaseResponseModel<FriendshipResponseModel>?> approve(
      String senderId) async {
    final response = await _networkManager.post<
            SingleBaseResponseModel<FriendshipResponseModel>,
            FriendshipResponseModel,
            ApproveRequestModel>(
        FriendshipResponseModel(), _FriendshipRequestApiPaths.approve,
        data: ApproveRequestModel(senderId: senderId));
    return response.model;
  }
}
