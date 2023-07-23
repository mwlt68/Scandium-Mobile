import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:scandium/features/register/models/password.dart';
import 'package:scandium/features/register/models/password_confirmation.dart';
import 'package:scandium/features/register/models/username.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const RegisterState()) {
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
        status:
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
        status:
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
        status: Formz.validate(
            [passwordConfirmation, state.username, state.password]),
      ),
    );
  }

  Future<void> _onSubmitted(
      RegisterSubmitted event, Emitter<RegisterState> emit) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        var response = await _userRepository.register(state.username.value,
            state.password.value, state.passwordConfirm.value);
        if (response?.value != null && response!.hasNotError) {
          emit(state.copyWith(
              status: FormzStatus.submissionSuccess,
              errorMessage: null,
              registered: true));
        } else {
          emit(state.copyWith(
              status: FormzStatus.submissionFailure,
              errorMessage: response?.errorMessage));
        }
      } catch (e) {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure, errorMessage: null));
      }
    }
  }
}
