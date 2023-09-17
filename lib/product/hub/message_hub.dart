import 'package:scandium/core/init/hub/hub_base.dart';
import 'package:scandium/product/helpers/network_helper.dart';
import 'package:scandium/product/hub/product_hub_base.dart';
import 'package:scandium/product/models/response/message_response_model.dart';

typedef MessageReceive = void Function(MessageResponseModel message);

class MessageHub extends ProductHubBase {
  static const String _hubName = "hubs/messageHub",
      _messageReceiveName = "ReceiveMessage";

  MessageHub({required this.messageReceive})
      : super(
            baseUrl: NetworkHelper.getBaseUrl,
            hubName: _hubName,
            hubMethodRegisterModels:
                _getHubMethodRegisterModels(messageReceive));

  static List<HubMethodRegisterModel> _getHubMethodRegisterModels(
      MessageReceive? messageReceive) {
    return List<HubMethodRegisterModel>.filled(
        1,
        HubMethodRegisterModel(
            methodName: _messageReceiveName,
            newMethod: (List<Object?>? args) {
              if (messageReceive != null && args?[0] != null) {
                var model = MessageResponseModel()
                    .fromMap(args![0] as Map<String, dynamic>);
                messageReceive(model);
              }
            }),
        growable: false);
  }

  final MessageReceive messageReceive;

  /*
  
  Note 

  Future<void> sendMessageToHub(String message) async {
    await invoke("SendMessage", args: <Object>[message]);
  }
  */
}
