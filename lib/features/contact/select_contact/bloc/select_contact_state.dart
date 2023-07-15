part of 'select_contact_bloc.dart';

class SelectContactState extends Equatable {
  const SelectContactState(
      {this.users, this.isLoading = false, this.errorMessage});

  @override
  List<Object?> get props => [isLoading, errorMessage];

  final List<UserResponseModel>? users;
  final bool? isLoading;
  final String? errorMessage;

  SelectContactState copyWith(
      {bool? isLoading, List<UserResponseModel>? users, String? errorMessage}) {
    return SelectContactState(
        isLoading: isLoading ?? this.isLoading,
        users: users ?? this.users,
        errorMessage: errorMessage);
  }
}
