import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/core/init/bloc/bloc/base_bloc.dart';
import 'package:scandium/product/constants/application_constants.dart';

class CircularProgressBlocBuilder<
    TBloc extends BaseBloc<TEvent, TState>,
    TState extends BaseState<TState>,
    TEvent extends BaseEvent> extends StatelessWidget {
  CircularProgressBlocBuilder(
      {required this.getChild,
      this.hasMessage,
      this.message,
      this.defaultMessage,
      this.buildWhen,
      super.key});
  String? message;
  String? defaultMessage;
  Widget Function(BuildContext, TState) getChild;
  bool Function(TState)? hasMessage;

  bool Function(TState, TState)? buildWhen;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TBloc, TState>(builder: (context, state) {
      if (state.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (hasMessage != null && hasMessage!(state) == true) {
        return Center(
          child: Text(
              message ?? defaultMessage ?? ApplicationConstants.instance.empty),
        );
      } else {
        return getChild(context, state);
      }
    }, buildWhen: (previous, current) {
      var result = previous.isLoading != current.isLoading;
      if (!result && buildWhen != null) {
        result = buildWhen!(previous, current);
      }
      return result;
    });
  }
}
