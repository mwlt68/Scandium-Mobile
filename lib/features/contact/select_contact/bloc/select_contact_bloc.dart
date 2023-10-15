import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:scandium/core/init/bloc/bloc/base_bloc.dart';
import 'package:scandium/core/init/bloc/model/base_bloc_dialog_model.dart';
import 'package:scandium/product/hub/friendship_request_hub.dart';
import 'package:scandium/product/models/base/user.dart';
import 'package:scandium/product/models/response/friendship_response_model.dart';
import 'package:scandium/product/models/response/user_response_model.dart';
import 'package:scandium/product/repositories/friendship_request/friendship_request_repository.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';

part 'select_contact_event.dart';
part 'select_contact_state.dart';

class SelectContactBloc
    extends BaseBloc<SelectContactEvent, SelectContactState> {
  SelectContactBloc(
      {required FriendshipRequestRepository friendshipRequestRepository,
      required UserRepository userRepository})
      : _friendshipRequestRepository = friendshipRequestRepository,
        _userRepository = userRepository,
        super(SelectContactState(users: [])) {
    on<GetContactsEvent>(_onGetContacts);
    on<RequestApproveEvent>(_onRequestApproveEvent);
    _friendshipRequestHub = FriendshipRequestHub(
      approveFriendshipRequest: (friendshipRequestModel) {
        add(RequestApproveEvent(friendshipRequestModel));
      },
    );
    _friendshipRequestHub.openChatConnection();
    _authenticationStatusSubscription = _userRepository.currentUser.listen(
      (user) => _currentUser = user,
    );
  }
  late StreamSubscription<User?> _authenticationStatusSubscription;
  late User? _currentUser;

  final FriendshipRequestRepository _friendshipRequestRepository;
  final UserRepository _userRepository;

  late FriendshipRequestHub _friendshipRequestHub;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _friendshipRequestHub.stop();
    return super.close();
  }

  Future _onRequestApproveEvent(
      RequestApproveEvent event, Emitter<SelectContactState> emit) async {
    if (event.model.receiver != null) {
      var users = List<UserResponseModel>.from(state.users ?? List.empty());
      users.add(event.model.receiver!);
      emit(state.copyWith(users: users));
    }
  }

  Future _onGetContacts(
    GetContactsEvent event,
    Emitter<SelectContactState> emit,
  ) async {
    emitSetLoading(emit, true);
    var result =
        await _friendshipRequestRepository.getAll(isOnlyAccepted: true);
    emitBaseState(
      emit,
      result,
      whenSuccess: () {
        if (_currentUser != null) {
          var users = result!.value!
              .where((element) =>
                  element.sender != null && element.receiver != null)
              .map((e) =>
                  e.sender?.id == _currentUser!.id ? e.receiver! : e.sender!)
              .toList();
          emit(state.copyWith(users: users));
        }
      },
    );
  }
}
