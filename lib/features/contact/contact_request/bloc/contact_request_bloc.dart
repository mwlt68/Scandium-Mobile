import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scandium/product/constants/application_constants.dart';
import 'package:scandium/product/models/response/user_response_model.dart';
import 'package:scandium/product/repositories/friendship_request/friendship_request_repository.dart';

part 'contact_request_event.dart';
part 'contact_request_state.dart';

class ContactRequestBloc
    extends Bloc<ContactRequestEvent, ContactRequestState> {
  ContactRequestBloc(
      {required FriendshipRequestRepository friendshipRequestRepository})
      : _friendshipRequestRepository = friendshipRequestRepository,
        super(const ContactRequestState(requestedUsers: [])) {
    on<GetRequests>(_onGetRequests);
    on<RequestApproved>(_onRequestApproved);
  }

  final FriendshipRequestRepository _friendshipRequestRepository;

  Future _onGetRequests(
    GetRequests event,
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
      var users = result.value!.map((e) => e.sender!).toList();
      emit(state.copyWith(requestedUsers: users, isLoading: false));
    } else {
      emit(state.copyWith(errorMessage: result.errorMessage, isLoading: false));
    }
  }

  Future _onRequestApproved(
    RequestApproved event,
    Emitter<ContactRequestState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    var result = await _friendshipRequestRepository.approve(event.userId);
    if (result == null) {
      emit(state.copyWith(
          errorMessage:
              ApplicationConstants.instance.unexpectedErrorDefaultMessage,
          isLoading: false));
    } else if (result.value != null && result.hasNotError) {
      state.requestedUsers!.removeWhere((x) => x.id == event.userId);
      String? username = result.value?.sender?.username;
      String successMessage = '$username s follow request approved';
      emit(state.copyWith(
          requestedUsers: state.requestedUsers,
          isLoading: false,
          successMessage: successMessage));
    } else {
      emit(state.copyWith(errorMessage: result.errorMessage, isLoading: false));
    }
  }
}
