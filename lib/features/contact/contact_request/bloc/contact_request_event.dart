part of 'contact_request_bloc.dart';

abstract class ContactRequestEvent extends Equatable {
  const ContactRequestEvent();

  @override
  List<Object> get props => [];
}

class RequestApproveEvent extends ContactRequestEvent {
  const RequestApproveEvent(this.friendshipRequestId);
  final String friendshipRequestId;
  List<Object> get props => [friendshipRequestId];
}

class GetRequestsEvent extends ContactRequestEvent {
  const GetRequestsEvent();
  List<Object> get props => [];
}

class NewFriendshipRequestEvent extends ContactRequestEvent {
  final FriendshipResponseModel model;
  const NewFriendshipRequestEvent(this.model);

  @override
  List<Object> get props => [model];
}
