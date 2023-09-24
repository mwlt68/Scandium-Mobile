import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scandium/core/extensions/list_extension.dart';
import 'package:scandium/product/constants/application_constants.dart';
import 'package:scandium/product/hub/friendship_request_hub.dart';
import 'package:scandium/product/models/response/friendship_response_model.dart';
import 'package:scandium/product/repositories/friendship_request/friendship_request_repository.dart';

part 'contact_request_event.dart';
part 'contact_request_state.dart';

class ContactRequestBloc
    extends Bloc<ContactRequestEvent, ContactRequestState> {
  ContactRequestBloc(
      {required FriendshipRequestRepository friendshipRequestRepository})
      : _friendshipRequestRepository = friendshipRequestRepository,
        super(const ContactRequestState(friendshipResponses: [])) {
    on<GetRequestsEvent>(_onGetRequestsEvent);
    on<RequestApproveEvent>(_onRequestApproveEvent);
    on<NewFriendshipRequestEvent>(_onNewFriendshipRequestEvent);
    _friendshipRequestHub = FriendshipRequestHub(
      getFriendshipRequest: (friendshipRequestModel) {
        add(NewFriendshipRequestEvent(friendshipRequestModel));
      },
    );
    _friendshipRequestHub.openChatConnection();
  }

  final FriendshipRequestRepository _friendshipRequestRepository;
  late FriendshipRequestHub _friendshipRequestHub;

  Future _onNewFriendshipRequestEvent(NewFriendshipRequestEvent event,
      Emitter<ContactRequestState> emit) async {
    if (event.model.sender != null) {
      var friendshipResponses = List<FriendshipResponseModel>.from(
          state.friendshipResponses ?? List.empty());
      friendshipResponses.add(event.model);
      emit(state.copyWith(friendshipResponses: friendshipResponses));
    }
  }

  Future _onGetRequestsEvent(
    GetRequestsEvent event,
    Emitter<ContactRequestState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    var result = await _friendshipRequestRepository.getAll();
    if (result == null) {
      emit(state.copyWith(
          errorMessage:
              ApplicationConstants.instance.unexpectedErrorDefaultMessage,
          isLoading: false));
    } else if (result.value != null && result.hasNotError) {
      emit(state.copyWith(friendshipResponses: result.value, isLoading: false));
    } else {
      emit(state.copyWith(errorMessage: result.errorMessage, isLoading: false));
    }
  }

  Future _onRequestApproveEvent(
    RequestApproveEvent event,
    Emitter<ContactRequestState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    var result =
        await _friendshipRequestRepository.approve(event.friendshipRequestId);
    if (result == null) {
      emit(state.copyWith(
          errorMessage:
              ApplicationConstants.instance.unexpectedErrorDefaultMessage,
          isLoading: false));
    } else if (result.value != null &&
        result.hasNotError &&
        state.friendshipResponses != null) {
      var list = List<FriendshipResponseModel>.from(state.friendshipResponses!);
      var request =
          list.firstOrDefault((p0) => p0.id == event.friendshipRequestId);
      if (request != null) {
        request.isApproved = true;
        emit(state.copyWith(friendshipResponses: list, isLoading: false));
      }
    } else {
      emit(state.copyWith(errorMessage: result.errorMessage, isLoading: false));
    }
  }
}
