import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scandium/core/base/models/base_response_model.dart';
import 'package:scandium/core/base/models/mappable.dart';
import 'package:scandium/core/init/bloc/model/base_bloc_dialog_model.dart';
import 'package:scandium/product/constants/application_constants.dart';

part 'base_event.dart';
part 'base_state.dart';

class BaseBloc<TEvent extends BaseEvent, TState extends BaseState<TState>>
    extends Bloc<TEvent, TState> {
  BaseBloc(super.initialState);

  bool emitBaseState<T extends IFromMappable>(
      Emitter<TState> emit, SingleBaseResponseModel<T>? response) {
    if (response == null) {
      emit(state.copyWithBase(
          status: BaseStateStatus.success,
          errorKeys: const ["ConnectionError"]));
    } else if (response.value != null && response.hasNotError) {
      emit(state
          .copyWithBase(status: BaseStateStatus.success, errorKeys: const []));
      return true;
    } else {
      emit(state.copyWithBase(
          status: BaseStateStatus.success,
          errorKeys: response.errorContents?.map((e) => e.title!).toList() ??
              [ApplicationConstants.instance.unexpectedErrorDefaultMessage]));
    }
    return false;
  }

  void emitErrorKeys(
      Emitter<TState> emit, List<ErrorResponseContent>? errorContents) {
    emit(state.copyWithBase(
        status: BaseStateStatus.success,
        errorKeys: errorContents?.map((e) => e.title!).toList() ??
            [ApplicationConstants.instance.unexpectedErrorDefaultMessage]));
  }
}
