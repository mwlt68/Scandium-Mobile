import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/core/base/models/base_response_model.dart';
import 'package:scandium/core/base/models/mappable.dart';
import 'package:scandium/core/init/bloc/bloc/base_bloc.dart';
import 'package:scandium/core/init/extension/string_extension.dart';
import 'package:scandium/core/init/locale_keys.g.dart';

extension EmitterHelper<TState extends BaseState<TState>> on Emitter<TState> {
  Future<R?> emit<T extends IFromMappable, R extends BaseResponseModel<T>>(
      {required TState state,
      required Future<R?> requestOperation,
      TState? Function(R)? getSuccessfulState,
      bool isLoadingActive = true}) async {
    if (isLoadingActive) {
      this.emitSetLoading(state, true);
    }
    var response = await requestOperation;
    if (response == null) {
      this(state.copyWithBase(
          status: BaseStateStatus.success,
          errorKeys: const ["ConnectionError"]));
    } else if (!response.isValueNull() && response.hasNotError) {
      if (getSuccessfulState != null) {
        var successState = getSuccessfulState(response);
        successState ??= state;
        this(successState.copyWithBase(
            status: BaseStateStatus.success, errorKeys: const []));
      }
    } else {
      this(state.copyWithBase(
          status: BaseStateStatus.success,
          errorKeys: response.errorContents?.map((e) => e.title!).toList() ??
              [LocaleKeys.generals_unexpectedErrorDefaultMessage.lcl]));
    }
    return response;
  }

  void emitErrorKeys(TState state, List<ErrorResponseContent>? errorContents) {
    this(state.copyWithBase(
        status: BaseStateStatus.success,
        errorKeys: errorContents?.map((e) => e.title!).toList() ??
            [LocaleKeys.generals_unexpectedErrorDefaultMessage.lcl]));
  }

  void emitSetLoading(TState state, bool isLoading) {
    this(state.copyWithBase(
      status: isLoading ? BaseStateStatus.loading : BaseStateStatus.success,
    ));
  }
}
