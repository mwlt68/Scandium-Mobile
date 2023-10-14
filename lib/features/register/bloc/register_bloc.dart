import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:scandium/core/init/bloc/bloc/base_bloc.dart';
import 'package:scandium/core/init/bloc/model/base_bloc_dialog_model.dart';
import 'package:scandium/features/register/models/password.dart';
import 'package:scandium/features/register/models/password_confirmation.dart';
import 'package:scandium/features/register/models/username.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends BaseBloc<RegisterEvent, RegisterState> {
  RegisterBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(RegisterState()) {
    on<RegisterUsernameChanged>(_onUsernameChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterPasswordConfirmChanged>(_onPasswordConfirmationChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  final UserRepository _userRepository;

  void _onUsernameChanged(
    RegisterUsernameChanged event,
    Emitter<RegisterState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        formStatus:
            Formz.validate([username, state.password, state.passwordConfirm]),
      ),
    );
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final password = Password.dirty(event.password);
    PasswordConfirmation? passwordConfirmation;
    if (state.passwordConfirm.value.isNotEmpty) {
      passwordConfirmation = PasswordConfirmation.dirty(
          value: state.passwordConfirm.value, password: event.password);
    }
    emit(
      state.copyWith(
        password: password,
        passwordConfirm: passwordConfirmation,
        formStatus:
            Formz.validate([password, state.username, state.passwordConfirm]),
      ),
    );
  }

  void _onPasswordConfirmationChanged(
    RegisterPasswordConfirmChanged event,
    Emitter<RegisterState> emit,
  ) {
    final passwordConfirmation = PasswordConfirmation.dirty(
        value: event.passwordConfirm, password: state.password.value);
    emit(
      state.copyWith(
        passwordConfirm: passwordConfirmation,
        formStatus: Formz.validate(
            [passwordConfirmation, state.username, state.password]),
      ),
    );
  }

  Future<void> _onSubmitted(
      RegisterSubmitted event, Emitter<RegisterState> emit) async {
    if (state.formStatus.isValidated) {
      emit(state.copyWith(formStatus: FormzStatus.submissionInProgress));

      var response = await _userRepository.register(state.username.value,
          state.password.value, state.passwordConfirm.value);
      bool isSuccessful = emitBaseState(emit, response);
      if (isSuccessful) {
        emit(state.copyWith(registered: true));
      }
    }
  }
}
