import 'dart:io';
import 'package:signalr_netcore/signalr_client.dart';

typedef OnHubError = void Function({Exception? error});
typedef OnHubConnected = void Function({String? connectionId});

abstract class HubBase {
  HubConnection? _hubConnection;

  final String baseUrl;
  final String hubName;
  final List<HubMethodRegisterModel>? _hubMethodRegisterModels;

  final OnHubError? _onclose;
  final OnHubError? _onreconnecting;
  final OnHubConnected? _onreconnected;

  HubConnectionState? get hubConnectionState => _hubConnection?.state;

  HubBase({
    required this.baseUrl,
    required this.hubName,
    List<HubMethodRegisterModel>? hubMethodRegisterModels,
    OnHubError? onclose,
    OnHubError? onreconnecting,
    OnHubConnected? onreconnected,
  })  : _onclose = onclose,
        _onreconnecting = onreconnecting,
        _onreconnected = onreconnected,
        _hubMethodRegisterModels = hubMethodRegisterModels;

  Future<void> openChatConnection() async {
    if (_hubConnection == null) {
      final httpConnectionOptions = HttpConnectionOptions(
          httpClient: WebSupportingHttpClient(
        null,
        httpClientCreateCallback: (httpClient) {
          HttpOverrides.global = _HttpOverrideCertificateVerificationInDev();
        },
      ));
      var url = baseUrl + hubName;
      _hubConnection = HubConnectionBuilder()
          .withUrl(url, options: httpConnectionOptions)
          .build();
      _hubConnection!.onclose(_getOnClose);
      _hubConnection!.onreconnecting(_getOnreconnecting);
      _hubConnection!.onreconnected(_getOnreconnected);
      if (_hubMethodRegisterModels != null) {
        for (var hubMethodRegisterModel in _hubMethodRegisterModels!) {
          _hubConnection!.on(hubMethodRegisterModel.methodName,
              hubMethodRegisterModel.newMethod);
        }
      }
    }
    if (_hubConnection?.state == HubConnectionState.Disconnected) {
      await _hubConnection?.start();
    }
  }

  Future<void> invoke(String methodName, {List<Object>? args}) async {
    await openChatConnection();
    _hubConnection!.invoke(methodName, args: args);
  }

  OnClose get _getOnClose => _onclose ?? ({error}) => {};
  OnClose get _getOnreconnecting => _onreconnecting ?? ({error}) => {};
  OnHubConnected get _getOnreconnected => _onreconnected ?? ({connectionId}) {};
}

class _HttpOverrideCertificateVerificationInDev extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class HubMethodRegisterModel {
  String methodName;
  void Function(List<Object?>?) newMethod;
  HubMethodRegisterModel({
    required this.methodName,
    required this.newMethod,
  });
}
