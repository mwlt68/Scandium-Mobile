import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/core/init/bloc/bloc/base_bloc.dart';

class BaseScaffoldBlocListener<
    TBloc extends BaseBloc<TEvent, TState>,
    TState extends BaseState<TState>,
    TEvent extends BaseEvent> extends StatelessWidget {
  const BaseScaffoldBlocListener(
      {super.key,
      required this.create,
      required this.child,
      this.listener,
      this.buildWhen,
      this.listenWhen,
      this.isLoadingActive = false,
      this.ignoreDefaultListener = false,
      this.lazy = true});

  final Scaffold child;
  final bool lazy;
  final bool ignoreDefaultListener;
  final bool isLoadingActive;
  final TBloc Function(BuildContext context) create;
  final void Function(BuildContext, TState)? listener;
  final bool Function(TState, TState)? buildWhen;
  final bool Function(TState, TState)? listenWhen;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TBloc>(
        create: create,
        lazy: lazy,
        child: BlocConsumer<TBloc, TState>(
          listener: (context, state) {
            if (!ignoreDefaultListener) {
              if (state.errorKeys.isNotEmpty) {
                _showScaffoldMessage(
                    context, state.errorKeys.join(','), Colors.redAccent);
              } else if (state.warningKeys.isNotEmpty) {
                _showScaffoldMessage(
                    context, state.warningKeys.join(','), Colors.orangeAccent);
              } else if (state.successfulKeys.isNotEmpty) {
                _showScaffoldMessage(context, state.successfulKeys.join(','),
                    Colors.greenAccent);
              }
              state.clear();
            }
            if (listener != null) listener!(context, state);
          },
          builder: ((context, state) => _child(state)),
          buildWhen: (previous, current) {
            var res = previous.status != current.status;
            if (buildWhen != null) {
              res = res || buildWhen!(previous, current);
            }
            return res;
          },
          listenWhen: (previous, current) {
            var res = previous.errorKeys != current.errorKeys ||
                current.status != previous.status ||
                previous.successfulKeys != current.successfulKeys ||
                current.warningKeys != previous.warningKeys;
            if (listenWhen != null) {
              res = res || listenWhen!(previous, current);
            }
            return res;
          },
        ));
  }

  Widget _child(state) {
    return Stack(
      children: [
        child,
        if (isLoadingActive ? state.status == BaseStateStatus.loading : false)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (isLoadingActive ? state.status == BaseStateStatus.loading : false)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  void _showScaffoldMessage(BuildContext context, String text, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(text),
        backgroundColor: color,
      ));
  }
}
