import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:scandium/core/init/bloc/bloc/base_bloc.dart';
import 'package:scandium/core/init/bloc/model/base_bloc_dialog_model.dart';
import 'package:scandium/features/login/models/password.dart';
import 'package:scandium/features/login/models/username.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  LoginBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(LoginState(status: BaseStateStatus.success)) {
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
    var status = Formz.validate([state.password, username]);
    emit(
      state.copyWith(username: username, formStatus: status),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    var status = Formz.validate([password, state.username]);

    emit(
      state.copyWith(password: password, formStatus: status),
    );
  }

  Future<void> _onSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    if (state.formStatus.isValidated) {
      emit(state.copyWith(status: BaseStateStatus.loading));

      var response = await _userRepository.authenticate(
          username: state.username.value, password: state.password.value);

      emitBaseState(emit, response);
    }
  }
}
