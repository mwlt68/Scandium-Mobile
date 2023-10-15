import 'package:bloc/bloc.dart';
import 'package:scandium/core/extensions/list_extension.dart';
import 'package:scandium/core/init/bloc/bloc/base_bloc.dart';
import 'package:scandium/core/init/bloc/model/base_bloc_dialog_model.dart';
import 'package:scandium/product/hub/friendship_request_hub.dart';
import 'package:scandium/product/models/response/friendship_response_model.dart';
import 'package:scandium/product/repositories/friendship_request/friendship_request_repository.dart';

part 'contact_request_event.dart';
part 'contact_request_state.dart';

class ContactRequestBloc
    extends BaseBloc<ContactRequestEvent, ContactRequestState> {
  ContactRequestBloc(
      {required FriendshipRequestRepository friendshipRequestRepository})
      : _friendshipRequestRepository = friendshipRequestRepository,
        super(ContactRequestState(friendshipResponses: [])) {
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
    emitSetLoading(emit, true);
    var result = await _friendshipRequestRepository.getAll();
    emitBaseState(emit, result, whenSuccess: () {
      emit(state.copyWith(friendshipResponses: result!.value));
    });
  }

  Future _onRequestApproveEvent(
    RequestApproveEvent event,
    Emitter<ContactRequestState> emit,
  ) async {
    emitSetLoading(emit, true);
    var result =
        await _friendshipRequestRepository.approve(event.friendshipRequestId);
    emitBaseState(emit, result, whenSuccess: () {
      if (state.friendshipResponses != null) {
        var list =
            List<FriendshipResponseModel>.from(state.friendshipResponses!);
        var request =
            list.firstOrDefault((p0) => p0.id == event.friendshipRequestId);
        if (request != null) {
          request.isApproved = true;
          emit(state.copyWith(friendshipResponses: list));
        }
      }
    });
  }
}
