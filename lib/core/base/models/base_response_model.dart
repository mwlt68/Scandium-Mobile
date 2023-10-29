import 'package:scandium/core/base/models/mappable.dart';

abstract class BaseResponseModel<T> {
  bool? isCustomException;
  bool? isValidationError;
  List<ErrorResponseContent>? errorContents;
  BaseResponseModel({
    this.isCustomException,
    this.isValidationError,
    this.errorContents,
  });

  BaseResponseModel.fromMap(Map<String, dynamic> map);

  String? get errorMessage => errorContents?.map((e) => e.content).join('/n');

  bool get hasNotError =>
      (isCustomException == null || isCustomException == false) &&
      (isValidationError == null || isValidationError == false) &&
      errorContents == null;

  bool isValueNull();
}

class ErrorResponseContent {
  String? title;
  String? content;
  ErrorResponseContent({
    this.title,
    this.content,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'content': content,
    };
  }

  factory ErrorResponseContent.fromMap(Map<String, dynamic> map) {
    return ErrorResponseContent(
      title: map['title'] != null ? map['title'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
    );
  }
}

class ListBaseResponseModel<T extends IFromMappable>
    extends BaseResponseModel<T> {
  List<T>? value;

  ListBaseResponseModel({
    bool? isCustomException,
    bool? isValidationError,
    List<ErrorResponseContent>? errorContents,
    this.value,
  }) : super(
            isCustomException: isCustomException,
            isValidationError: isValidationError,
            errorContents: errorContents);

  ListBaseResponseModel<T> fromJson(
      Map<String, dynamic> map, Function(Map<String, dynamic>) create) {
    return ListBaseResponseModel<T>(
        isCustomException: map['isCustomException'] != null
            ? map['isCustomException'] as bool
            : null,
        isValidationError: map['isValidationError'] != null
            ? map['isValidationError'] as bool
            : null,
        errorContents: map['errorContents'] != null
            ? (map['errorContents'] as List)
                .map((e) =>
                    ErrorResponseContent.fromMap(e as Map<String, dynamic>))
                .toList()
            : null,
        value: map['value'] != null
            ? (map['value'] as List).map((e) => create(e) as T).toList()
            : null);
  }

  @override
  bool get hasNotError => value != null && super.hasNotError;

  @override
  bool isValueNull() => value == null;
}

class SingleBaseResponseModel<T extends IFromMappable>
    extends BaseResponseModel<T> {
  T? value;

  SingleBaseResponseModel({
    bool? isCustomException,
    bool? isValidationError,
    List<ErrorResponseContent>? errorContents,
    this.value,
  }) : super(
            isCustomException: isCustomException,
            isValidationError: isValidationError,
            errorContents: errorContents);

  SingleBaseResponseModel<T> fromJson(
      Map<String, dynamic> map, Function(Map<String, dynamic>) create) {
    return SingleBaseResponseModel<T>(
        isCustomException: map['isCustomException'] != null
            ? map['isCustomException'] as bool
            : null,
        isValidationError: map['isValidationError'] != null
            ? map['isValidationError'] as bool
            : null,
        errorContents: map['errorContents'] != null
            ? (map['errorContents'] as List)
                .map((e) =>
                    ErrorResponseContent.fromMap(e as Map<String, dynamic>))
                .toList()
            : null,
        value: map['value'] != null ? create(map['value']) as T : null);
  }

  @override
  bool get hasNotError => value != null && super.hasNotError;

  @override
  bool isValueNull() => value == null;
}
