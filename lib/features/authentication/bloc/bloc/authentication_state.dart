part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({this.user});

  final User? user;

  @override
  List<Object?> get props => [user];
}
