// ignore_for_file: public_member_api_docs, sort_constructors_first
enum BaseBlocDialogModelType { success, error }

class BaseBlocDialogModel {
  String? buttonText;
  String? titleText;
  String? contentText;
  BaseBlocDialogModelType? type;

  BaseBlocDialogModel(
      {this.buttonText, this.titleText, this.contentText, this.type});

  bool get isSuccess => type == BaseBlocDialogModelType.success;
}
