import 'package:bloc/bloc.dart';
import 'package:scandium/core/extensions/list_extension.dart';
import 'package:scandium/core/init/bloc/bloc/base_bloc.dart';
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
    Emitter<NewContactState> emit,
  ) async {
    emitSetLoading(emit, true);
    var result = await _userRepository.searchUser(username: event.searchValue);
    emitBaseState(
      emit,
      result,
      whenSuccess: () {
        emit(state.copyWith(
            searchValue: event.searchValue, searcResultUsers: result!.value));
      },
    );
  }

  Future _onFollowSubmitted(
    FollowSubmitted event,
    Emitter<NewContactState> emit,
  ) async {
    var otherUserFriendship = state.searcResultUsers
        .firstOrDefault((p0) => p0.receiverId == event.userId);
    if (otherUserFriendship == null) {
      emitSetLoading(emit, true);
      var result = await _friendshipRequestRepository.follow(event.userId);
      emitBaseState(
        emit,
        result,
        whenSuccess: () {
          var searcResultUsers = List<UserSearchResponseModel>.from(
              state.searcResultUsers ?? List.empty(growable: true));
          var searcResultUser = searcResultUsers.firstOrDefault(
              (p) => p.userResponseDto?.id == result!.value?.receiver?.id);
          if (searcResultUser != null) {
            searcResultUser.friendshipRequestStatus =
                FriendshipRequestStatus.Requested;
          }
          emit(state.copyWith(searcResultUsers: searcResultUsers));
        },
      );
    }
  }
}
