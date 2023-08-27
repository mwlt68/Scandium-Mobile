import 'package:scandium/product/hubs/hub_base.dart';

typedef ReceiveMessage = void Function(String? message);

class MessageHub extends HubBase {
  MessageHub({required super.baseUrl, required this.receiveMessage})
      : super(
            hubName: "messageHub",
            hubMethodRegisterModels:
                _getHubMethodRegisterModels(receiveMessage));

  static List<HubMethodRegisterModel> _getHubMethodRegisterModels(
      ReceiveMessage? receiveMessage) {
    return List<HubMethodRegisterModel>.filled(
        1,
        HubMethodRegisterModel(
            methodName: "ReceiveMessage",
            newMethod: (List<Object?>? args) {
              if (receiveMessage != null) {
                receiveMessage(args?[0] as String?);
              }
            }),
        growable: false);
  }

  final ReceiveMessage receiveMessage;

  Future<void> sendMessageToHub(String message) async {
    await invoke("SendMessage", args: <Object>[message]);
  }
}
