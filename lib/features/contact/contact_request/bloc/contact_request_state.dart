part of 'contact_request_bloc.dart';

class ContactRequestState extends Equatable {
  const ContactRequestState(
      {this.requestedUsers,
      this.isLoading = false,
      this.errorMessage,
      this.successMessage});

  @override
  List<Object?> get props => [requestedUsers, isLoading, errorMessage];

  final List<UserResponseModel>? requestedUsers;
  final bool? isLoading;
  final String? errorMessage;
  final String? successMessage;

  ContactRequestState copyWith(
      {String? searchValue,
      bool? isLoading,
      List<UserResponseModel>? requestedUsers,
      String? errorMessage,
      String? successMessage}) {
    return ContactRequestState(
        isLoading: isLoading ?? this.isLoading,
        requestedUsers: requestedUsers ?? this.requestedUsers,
        successMessage: successMessage,
        errorMessage: errorMessage);
  }
}
