part of 'select_contact_bloc.dart';

class SelectContactEvent extends BaseEvent {
  const SelectContactEvent();

  @override
  List<Object> get props => [];
}

class GetContactsEvent extends SelectContactEvent {}

class RequestApproveEvent extends SelectContactEvent {
  final FriendshipResponseModel model;
  const RequestApproveEvent(this.model);

  @override
  List<Object> get props => [model];
}
