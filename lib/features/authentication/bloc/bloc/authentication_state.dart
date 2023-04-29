part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._(
      {this.status = AuthenticationStatus.unAuthenticated,
      this.user = User.empty});

  final AuthenticationStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];

  const AuthenticationState.authenticated(User user)
      : this._(status: AuthenticationStatus.authenticated, user: user);
  const AuthenticationState.unAuthenticated()
      : this._(status: AuthenticationStatus.unAuthenticated);
}
