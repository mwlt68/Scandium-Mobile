part of 'contact_request_bloc.dart';

abstract class ContactRequestEvent extends Equatable {
  const ContactRequestEvent();

  @override
  List<Object> get props => [];
}

class RequestApproved extends ContactRequestEvent {
  const RequestApproved(this.userId);
  final String userId;
  List<Object> get props => [userId];
}

class GetRequests extends ContactRequestEvent {
  const GetRequests();
  List<Object> get props => [];
}
