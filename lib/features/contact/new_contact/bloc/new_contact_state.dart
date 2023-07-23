part of 'new_contact_bloc.dart';

class NewContactState extends Equatable {
  const NewContactState(
      {this.searcResultUsers,
      this.searchValue = '',
      this.isLoading = false,
      this.errorMessage,
      this.successMessage});

  @override
  List<Object?> get props =>
      [searcResultUsers, searchValue, isLoading, errorMessage];

  final String? searchValue;
  final List<UserResponseModel>? searcResultUsers;
  final bool? isLoading;
  final String? errorMessage;
  final String? successMessage;

  NewContactState copyWith(
      {String? searchValue,
      bool? isLoading,
      List<UserResponseModel>? searcResultUsers,
      String? errorMessage,
      String? successMessage}) {
    return NewContactState(
        searchValue: searchValue ?? this.searchValue,
        isLoading: isLoading ?? this.isLoading,
        searcResultUsers: searcResultUsers ?? this.searcResultUsers,
        successMessage: successMessage,
        errorMessage: errorMessage);
  }
}
