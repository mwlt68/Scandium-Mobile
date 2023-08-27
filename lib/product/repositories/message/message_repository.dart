import 'dart:async';

import 'package:scandium/core/base/models/base_response_model.dart';
import 'package:scandium/core/init/network/network_manager.dart';
import 'package:scandium/product/models/response/conversation_reponse_model.dart';
import 'package:scandium/product/models/response/message_response_model.dart';
import 'package:scandium/product/repositories/message/message_request_model.dart';

class _MessageApiPaths {
  static const String last = "message/last";
  static const String conversation = "message/conversation";
  static const String insert = "message/insert";
}

class MessageRepository {
  final INetworkManager _networkManager;

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

  Future<SingleBaseResponseModel<ConversationResponseModel>?> getConversation(
      String otherUserId) async {
    var queryParameters = {'otherUserId': otherUserId};
    final response = await _networkManager.get<
        SingleBaseResponseModel<ConversationResponseModel>,
        ConversationResponseModel>(
      ConversationResponseModel(),
      queryParameters: queryParameters,
      _MessageApiPaths.conversation,
    );
    return response.model;
  }

  Future<SingleBaseResponseModel<MessageResponseModel>?> sendMessage(
      String otherUserId, String content) async {
    var requestModel =
        MessageRequestModel(receiverId: otherUserId, content: content);
    final response = await _networkManager.post<
        SingleBaseResponseModel<MessageResponseModel>,
        MessageResponseModel,
        MessageRequestModel>(
      MessageResponseModel(),
      _MessageApiPaths.insert,
      data: requestModel,
    );
    return response.model;
  }
}
