import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:scandium/core/base/models/mappable.dart';
import 'package:scandium/core/base/models/base_response_model.dart';
import 'package:scandium/core/init/network/network_response_model.dart';
import 'package:scandium/core/init/network/tokenable.dart';

abstract class INetworkManager {
  abstract String baseUrl;

  Future<NetworkResponseModel<BR, Res>> post<BR extends BaseResponseModel<Res>,
      Res extends IFromMappable, Req extends IToMappable>(
    Res res,
    String path, {
    Req? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  });

  Future<NetworkResponseModel<BR, Res>>
      get<BR extends BaseResponseModel<Res>, Res extends IFromMappable>(
    Res res,
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  });
}

abstract class NetworkManager implements INetworkManager, ITokenable {
  NetworkManager({required this.baseUrl}) {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };
  }

  late Dio _dio;

  @override
  String baseUrl;

  Future<NetworkResponseModel<BR, Res>> request<
      BR extends BaseResponseModel<Res>,
      Res extends IFromMappable,
      Req extends IToMappable>(
    Res res,
    String path, {
    Req? req,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    var networkResponse = NetworkResponseModel<BR, Res>();
    try {
      options = await setHeaderToken(options);
      var response = await _dio.request(path,
          data: req?.toMap(),
          onSendProgress: onSendProgress,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          options: options,
          queryParameters: queryParameters);
      networkResponse.statusCode = response.statusCode;
      networkResponse.model = getBaseResponse(res, response.data);
    } on DioError catch (error) {
      networkResponse.description = error.message;
      if (error.response != null) {
        networkResponse.statusCode = error.response?.statusCode;
        networkResponse.model = getBaseResponse(res, error.response?.data);
      }
    }
    return networkResponse;
  }

  Future<Options> setHeaderToken(Options? options) async {
    options ??= Options();
    var token = await getToken();
    var tokenMap = {'Authorization': token};
    options.headers ??= {};
    options.headers!.addAll(tokenMap);
    return options;
  }

  BR? getBaseResponse<BR extends BaseResponseModel<Res>,
      Res extends IFromMappable>(Res res, dynamic data) {
    try {
      if (data != null) {
        if (data['value'] is List) {
          return ListBaseResponseModel<Res>()
              .fromJson(data, (data) => res.fromMap(data)) as BR;
        } else {
          return SingleBaseResponseModel<Res>()
              .fromJson(data, (data) => res.fromMap(data)) as BR;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<NetworkResponseModel<BR, Res>> post<BR extends BaseResponseModel<Res>,
      Res extends IFromMappable, Req extends IToMappable>(
    Res res,
    String path, {
    Req? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    options ??= Options();
    options.method = 'POST';
    return await request(res, path,
        req: data,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        options: options,
        queryParameters: queryParameters);
  }

  @override
  Future<NetworkResponseModel<BR, Res>>
      get<BR extends BaseResponseModel<Res>, Res extends IFromMappable>(
    Res res,
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    options ??= Options();
    options.method = 'GET';
    return await request(res, path,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        options: options,
        queryParameters: queryParameters);
  }
}
