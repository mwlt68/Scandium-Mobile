import 'package:bloc/bloc.dart';
import 'package:scandium/core/extensions/list_extension.dart';
import 'package:scandium/core/init/bloc/bloc/base_bloc.dart';
import 'package:scandium/core/init/bloc/extension/emitter_extension.dart';
import 'package:scandium/core/init/bloc/model/base_bloc_dialog_model.dart';
import 'package:scandium/product/models/response/user_search_response_model.dart';
import 'package:scandium/product/repositories/friendship_request/friendship_request_repository.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';

part 'new_contact_event.dart';
part 'new_contact_state.dart';

class NewContactBloc extends BaseBloc<NewContactEvent, NewContactState> {
  NewContactBloc(
      {required FriendshipRequestRepository friendshipRequestRepository,
      required UserRepository userRepository})
      : _friendshipRequestRepository = friendshipRequestRepository,
        _userRepository = userRepository,
        super(NewContactState(
            searcResultUsers: [], status: BaseStateStatus.success)) {
    on<SearchValueChanged>(_onSearchValueChange);
    on<FollowSubmitted>(_onFollowSubmitted);
  }

  final FriendshipRequestRepository _friendshipRequestRepository;
  final UserRepository _userRepository;

  Future _onSearchValueChange(
    SearchValueChanged event,
    Emitter<NewContactState> emitter,
  ) async {
    await emitter.emit(
        state: state,
        requestOperation:
            _userRepository.searchUser(username: event.searchValue),
        getSuccessfulState: (response) => state.copyWith(
            searchValue: event.searchValue, searcResultUsers: response.value));
  }

  Future _onFollowSubmitted(
    FollowSubmitted event,
    Emitter<NewContactState> emitter,
  ) async {
    var otherUserFriendship = state.searcResultUsers
        .firstOrDefault((p0) => p0.receiverId == event.userId);
    if (otherUserFriendship == null) {
      await emitter.emit(
          state: state,
          requestOperation: _friendshipRequestRepository.follow(event.userId),
          getSuccessfulState: (response) {
            var searcResultUsers = List<UserSearchResponseModel>.from(
                state.searcResultUsers ?? List.empty(growable: true));
            var searcResultUser = searcResultUsers.firstOrDefault(
                (p) => p.userResponseDto?.id == response.value?.receiver?.id);
            if (searcResultUser != null) {
              searcResultUser.friendshipRequestStatus =
                  FriendshipRequestStatus.Requested;
            }
            return state.copyWith(searcResultUsers: searcResultUsers);
          });
    }
  }
}
