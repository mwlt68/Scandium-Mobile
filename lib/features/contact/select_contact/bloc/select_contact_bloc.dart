import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scandium/product/constants/application_constants.dart';
import 'package:scandium/product/models/base/user.dart';
import 'package:scandium/product/models/response/user_response_model.dart';
import 'package:scandium/product/repositories/friendship_request/friendship_request_repository.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';

part 'select_contact_event.dart';
part 'select_contact_state.dart';

class SelectContactBloc extends Bloc<SelectContactEvent, SelectContactState> {
  SelectContactBloc(
      {required FriendshipRequestRepository friendshipRequestRepository,
      required UserRepository userRepository})
      : _friendshipRequestRepository = friendshipRequestRepository,
        _userRepository = userRepository,
        super(const SelectContactState(users: [])) {
    on<GetContactsEvent>(_onGetContacts);
    _authenticationStatusSubscription = _userRepository.currentUser.listen(
      (user) => _currentUser = user,
    );
  }
  late StreamSubscription<User?> _authenticationStatusSubscription;
  late User? _currentUser;

  final FriendshipRequestRepository _friendshipRequestRepository;
  final UserRepository _userRepository;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  Future _onGetContacts(
    GetContactsEvent event,
    Emitter<SelectContactState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    var result =
        await _friendshipRequestRepository.getAll(isOnlyAccepted: true);
    if (result == null) {
      emit(state.copyWith(
          errorMessage:
              ApplicationConstants.instance.unexpectedErrorDefaultMessage,
          isLoading: false));
    } else if (result.value != null && result.hasNotError) {
      if (_currentUser != null) {
        var users = result.value!
            .where(
                (element) => element.sender != null && element.receiver != null)
            .map((e) =>
                e.sender?.id == _currentUser!.id ? e.receiver! : e.sender!)
            .toList();
        emit(state.copyWith(users: users, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } else {
      emit(state.copyWith(errorMessage: result.errorMessage, isLoading: false));
    }
  }
}
