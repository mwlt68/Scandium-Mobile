import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scandium/core/extensions/list_extension.dart';
import 'package:scandium/product/constants/application_constants.dart';
import 'package:scandium/product/models/response/user_search_response_model.dart';
import 'package:scandium/product/repositories/friendship_request/friendship_request_repository.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';

part 'new_contact_event.dart';
part 'new_contact_state.dart';

class NewContactBloc extends Bloc<NewContactEvent, NewContactState> {
  NewContactBloc(
      {required FriendshipRequestRepository friendshipRequestRepository,
      required UserRepository userRepository})
      : _friendshipRequestRepository = friendshipRequestRepository,
        _userRepository = userRepository,
        super(const NewContactState(searcResultUsers: [])) {
    on<SearchValueChanged>(_onSearchValueChange);
    on<FollowSubmitted>(_onFollowSubmitted);
  }

  final FriendshipRequestRepository _friendshipRequestRepository;
  final UserRepository _userRepository;

  Future _onSearchValueChange(
    SearchValueChanged event,
    Emitter<NewContactState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    var result = await _userRepository.searchUser(username: event.searchValue);
    if (result == null) {
      emit(state.copyWith(
          errorMessage:
              ApplicationConstants.instance.unexpectedErrorDefaultMessage,
          isLoading: false));
    } else if (result.value != null && result.hasNotError) {
      emit(state.copyWith(
          searchValue: event.searchValue,
          searcResultUsers: result.value,
          isLoading: false));
    } else {
      emit(state.copyWith(errorMessage: result.errorMessage, isLoading: false));
    }
  }

  Future _onFollowSubmitted(
    FollowSubmitted event,
    Emitter<NewContactState> emit,
  ) async {
    var otherUserFriendship = state.searcResultUsers
        .firstOrDefault((p0) => p0.receiverId == event.userId);
    if (otherUserFriendship == null) {
      emit(state.copyWith(isLoading: true));
      var result = await _friendshipRequestRepository.follow(event.userId);
      if (result == null) {
        emit(state.copyWith(
            errorMessage:
                ApplicationConstants.instance.unexpectedErrorDefaultMessage,
            isLoading: false));
      } else if (result.value != null && result.hasNotError) {
        var searcResultUsers = List<UserSearchResponseModel>.from(
            state.searcResultUsers ?? List.empty(growable: true));
        var searcResultUser = searcResultUsers.firstOrDefault(
            (p) => p.userResponseDto?.id == result.value?.receiver?.id);
        if (searcResultUser != null) {
          searcResultUser.friendshipRequestStatus =
              FriendshipRequestStatus.Requested;
        }
        emit(state.copyWith(
            searcResultUsers: searcResultUsers, isLoading: false));
      } else {
        emit(state.copyWith(
            errorMessage: result.errorMessage, isLoading: false));
      }
    }
  }
}
