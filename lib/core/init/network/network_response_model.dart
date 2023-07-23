import 'package:scandium/core/base/models/base_response_model.dart';
import 'package:scandium/core/base/models/mappable.dart';

class NetworkResponseModel<BaseResponse extends BaseResponseModel<T>,
    T extends IFromMappable> {
  int? statusCode;

  String? description;

  BaseResponse? model;

  NetworkResponseModel({this.statusCode, this.description, this.model});
}
