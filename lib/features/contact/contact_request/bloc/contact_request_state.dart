part of 'contact_request_bloc.dart';

class ContactRequestState extends Equatable {
  const ContactRequestState(
      {this.friendshipResponses,
      this.isLoading = false,
      this.errorMessage,
      this.successMessage});

  @override
  List<Object?> get props => [friendshipResponses, isLoading, errorMessage];

  final List<FriendshipResponseModel>? friendshipResponses;
  final bool? isLoading;
  final String? errorMessage;
  final String? successMessage;

  ContactRequestState copyWith(
      {bool? isLoading,
      List<FriendshipResponseModel>? friendshipResponses,
      String? errorMessage,
      String? successMessage}) {
    return ContactRequestState(
        isLoading: isLoading ?? this.isLoading,
        friendshipResponses: friendshipResponses ?? this.friendshipResponses,
        successMessage: successMessage,
        errorMessage: errorMessage);
  }
}
