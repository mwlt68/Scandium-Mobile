import 'package:scandium/core/base/models/mappable.dart';

class BaseResponseModel<T extends IFromMappable> {
  T? value;
  bool? isSuccess;
  bool? isCustomException;
  bool? isValidationError;
  List<ErrorResponseContent>? errorContents;
  BaseResponseModel({
    this.value,
    this.isSuccess,
    this.isCustomException,
    this.isValidationError,
    this.errorContents,
  });

  factory BaseResponseModel.fromMap(T t, Map<String, dynamic> map) {
    return BaseResponseModel<T>(
      value: map['value'] != null
          ? t.fromMap(map['value'] as Map<String, dynamic>) as T
          : null,
      isSuccess: map['isSuccess'] != null ? map['isSuccess'] as bool : null,
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
    );
  }

  String? get errorMessage => errorContents?.map((e) => e.content).join('/n');

  bool get hasNotError =>
      value != null &&
      (isCustomException == null || isCustomException == false) &&
      (isValidationError == null || isValidationError == false) &&
      errorContents == null;
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
