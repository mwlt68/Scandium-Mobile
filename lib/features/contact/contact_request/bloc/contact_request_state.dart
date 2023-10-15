part of 'contact_request_bloc.dart';

class ContactRequestState extends BaseState<ContactRequestState> {
  ContactRequestState(
      {this.friendshipResponses,
      super.status,
      super.errorKeys,
      super.successfulKeys,
      super.warningKeys,
      super.dialogModel});

  @override
  List<Object?> get props => super.props + [friendshipResponses];

  final List<FriendshipResponseModel>? friendshipResponses;

  ContactRequestState copyWith(
      {List<FriendshipResponseModel>? friendshipResponses,
      String? successMessage,
      BaseStateStatus? status,
      List<String>? errorKeys,
      List<String>? successfulKeys,
      List<String>? warningKeys,
      BaseBlocDialogModel? dialogModel}) {
    return ContactRequestState(
        friendshipResponses: friendshipResponses ?? this.friendshipResponses,
        dialogModel: dialogModel ?? this.dialogModel,
        errorKeys: errorKeys ?? this.errorKeys,
        successfulKeys: successfulKeys ?? this.successfulKeys,
        warningKeys: warningKeys ?? this.warningKeys,
        status: status ?? this.status);
  }

  @override
  ContactRequestState copyWithBase(
      {BaseStateStatus? status,
      List<String>? errorKeys,
      List<String>? warningKeys,
      List<String>? successfulKeys,
      BaseBlocDialogModel? dialogModel}) {
    return copyWith(
        status: status,
        dialogModel: dialogModel,
        errorKeys: errorKeys,
        warningKeys: warningKeys,
        successfulKeys: successfulKeys);
  }
}
