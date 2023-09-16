import 'package:scandium/core/init/hub/hub_base.dart';
import 'package:scandium/product/helpers/network_helper.dart';
import 'package:scandium/product/hub/product_hub_base.dart';
import 'package:scandium/product/models/response/conversation_reponse_model.dart';

typedef ReceiveMessage = void Function(ConversationMessageModel message);

class MessageHub extends ProductHubBase {
  static const String _hubName = "hubs/messageHub",
      _receiveMessageName = "ReceiveMessage";

  MessageHub({required this.receiveMessage})
      : super(
            baseUrl: NetworkHelper.getBaseUrl,
            hubName: _hubName,
            hubMethodRegisterModels:
                _getHubMethodRegisterModels(receiveMessage));

  static List<HubMethodRegisterModel> _getHubMethodRegisterModels(
      ReceiveMessage? receiveMessage) {
    return List<HubMethodRegisterModel>.filled(
        1,
        HubMethodRegisterModel(
            methodName: _receiveMessageName,
            newMethod: (List<Object?>? args) {
              if (receiveMessage != null && args?[0] != null) {
                var model = ConversationMessageModel()
                    .fromMap(args![0] as Map<String, dynamic>);
                receiveMessage(model);
              }
            }),
        growable: false);
  }

  final ReceiveMessage receiveMessage;

  /*
  
  Note 

  Future<void> sendMessageToHub(String message) async {
    await invoke("SendMessage", args: <Object>[message]);
  }
  */
}
