import 'dart:async';

import 'package:scandium/core/base/models/base_response_model.dart';
import 'package:scandium/core/init/network/network_manager.dart';
import 'package:scandium/product/models/response/message_response_model.dart';

class _MessageApiPaths {
  static const String last = "message/last";
}

class MessageRepository {
  late final INetworkManager _networkManager;
  MessageRepository(INetworkManager networkManager)
      : _networkManager = networkManager;

  Future<ListBaseResponseModel<MessageResponseModel>?> getLastMessages() async {
    final response = await _networkManager
        .get<ListBaseResponseModel<MessageResponseModel>, MessageResponseModel>(
      MessageResponseModel(),
      _MessageApiPaths.last,
    );
    return response.model;
  }
}
