import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scandium/core/init/bloc/model/base_bloc_dialog_model.dart';

part 'base_event.dart';
part 'base_state.dart';

class BaseBloc<TEvent extends BaseEvent, TState extends BaseState<TState>>
    extends Bloc<TEvent, TState> {
  BaseBloc(super.initialState);
}
