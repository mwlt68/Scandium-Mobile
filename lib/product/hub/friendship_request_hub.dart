import 'package:scandium/core/init/hub/hub_base.dart';
import 'package:scandium/product/helpers/network_helper.dart';
import 'package:scandium/product/hub/product_hub_base.dart';
import 'package:scandium/product/models/response/friendship_response_model.dart';

typedef GetFriendshipRequest = void Function(FriendshipResponseModel model);

class FriendshipRequestHub extends ProductHubBase {
  static const String _hubName = "hubs/friendshipRequestHub",
      _getFriendshipRequest = "GetFriendshipRequest",
      _approveFriendshipRequest = "ApproveFriendshipRequest";

  FriendshipRequestHub(
      {this.getFriendshipRequest, this.approveFriendshipRequest})
      : super(
            baseUrl: NetworkHelper.getBaseUrl,
            hubName: _hubName,
            hubMethodRegisterModels: _getHubMethodRegisterModels(
                getFriendshipRequest, approveFriendshipRequest));

  static List<HubMethodRegisterModel> _getHubMethodRegisterModels(
      GetFriendshipRequest? getFriendshipRequest,
      GetFriendshipRequest? approveFriendshipRequest) {
    var list = List<HubMethodRegisterModel>.empty(growable: true);
    if (getFriendshipRequest != null) {
      list.add(HubMethodRegisterModel(
          methodName: _getFriendshipRequest,
          newMethod: getFriendshipRequestFunc(getFriendshipRequest)));
    }
    if (approveFriendshipRequest != null) {
      list.add(HubMethodRegisterModel(
          methodName: _approveFriendshipRequest,
          newMethod: getFriendshipRequestFunc(approveFriendshipRequest)));
    }
    return list;
  }

  static Function(List<Object?>?) getFriendshipRequestFunc(
      GetFriendshipRequest? funct) {
    return (List<Object?>? args) {
      if (funct != null && args?[0] != null) {
        var model =
            FriendshipResponseModel().fromMap(args![0] as Map<String, dynamic>);
        funct(model);
      }
    };
  }

  final GetFriendshipRequest? getFriendshipRequest;
  final GetFriendshipRequest? approveFriendshipRequest;
}
