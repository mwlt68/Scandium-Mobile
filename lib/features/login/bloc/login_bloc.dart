import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:scandium/features/login/models/password.dart';
import 'package:scandium/features/login/models/username.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final UserRepository _userRepository;

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        status: Formz.validate([state.password, username]),
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([password, state.username]),
      ),
    );
  }

  Future<void> _onSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        var response = await _userRepository.authenticate(
            username: state.username.value, password: state.password.value);
        if (response.model?.value != null && response.model!.hasNotError) {
          emit(state.copyWith(
              status: FormzStatus.submissionSuccess, errorMessage: null));
        } else {
          emit(state.copyWith(
              status: FormzStatus.submissionFailure,
              errorMessage: response.model?.errorMessage));
        }
      } catch (e) {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure, errorMessage: null));
      }
    }
  }
}
