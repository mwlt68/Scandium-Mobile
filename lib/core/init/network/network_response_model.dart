import 'package:scandium/core/base/models/mappable.dart';
import 'package:scandium/core/base/models/base_response_model.dart';

class NetworkResponseModel<Res extends IFromMappable> {
  int? statusCode;

  String? description;

  BaseResponseModel<Res>? model;

  NetworkResponseModel({this.statusCode, this.description, this.model});
}
