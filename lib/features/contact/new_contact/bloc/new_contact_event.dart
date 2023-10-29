part of 'new_contact_bloc.dart';

abstract class NewContactEvent extends BaseEvent {
  const NewContactEvent();

  @override
  List<Object> get props => [];
}

class SearchValueChanged extends NewContactEvent {
  const SearchValueChanged(this.searchValue);
  final String searchValue;

  @override
  List<Object> get props => [searchValue];
}

class FollowSubmitted extends NewContactEvent {
  const FollowSubmitted(this.userId);
  final String userId;
  List<Object> get props => [userId];
}
