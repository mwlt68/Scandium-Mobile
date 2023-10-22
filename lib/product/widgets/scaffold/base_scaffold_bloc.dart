import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/core/init/bloc/bloc/base_bloc.dart';
import 'package:scandium/product/widgets/dialogs/show_alert_dialog.dart';
import 'package:scandium/product/widgets/snackbars/scaffold_snackbar.dart';

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
          listener: _listener,
          builder: _builder,
          buildWhen: _buildWhen,
          listenWhen: _listenWhen),
    );
  }

  void _listener(BuildContext context, TState state) {
    if (!ignoreDefaultListener) {
      if (state.dialogModel != null) {
        context.showAlertDialog(
            buttonText: state.dialogModel?.buttonText,
            titleText: state.dialogModel?.titleText,
            contentText: state.dialogModel?.contentText,
            isSuccess: state.dialogModel?.isSuccess);
      } else {
        if (state.errorKeys.isNotEmpty) {
          context.showScaffoldSnackbar(
              text: state.errorKeys.join(','), color: Colors.redAccent);
        } else if (state.warningKeys.isNotEmpty) {
          context.showScaffoldSnackbar(
              text: state.warningKeys.join(','), color: Colors.orangeAccent);
        } else if (state.successfulKeys.isNotEmpty) {
          context.showScaffoldSnackbar(
              text: state.successfulKeys.join(','), color: Colors.greenAccent);
        }
      }
      state.clear();
    }
    if (listener != null) listener!(context, state);
  }

  Stack _builder(context, state) {
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

  void myListener(context, state) {
    if (!ignoreDefaultListener) {
      if (state.dialogModel != null) {
        context.showAlertDialog(
            buttonText: state.dialogModel?.buttonText,
            titleText: state.dialogModel?.titleText,
            contentText: state.dialogModel?.contentText,
            isSuccess: state.dialogModel?.isSuccess);
      } else {
        if (state.errorKeys.isNotEmpty) {
          context.showScaffoldSnackbar(
              text: state.errorKeys.join(','), color: Colors.redAccent);
        } else if (state.warningKeys.isNotEmpty) {
          context.showScaffoldSnackbar(
              text: state.warningKeys.join(','), color: Colors.orangeAccent);
        } else if (state.successfulKeys.isNotEmpty) {
          context.showScaffoldSnackbar(
              text: state.successfulKeys.join(','), color: Colors.greenAccent);
        }
      }
      state.clear();
    }
    if (listener != null) listener!(context, state);
  }

  bool _listenWhen(TState previous, TState current) {
    var result = previous.baseStateCompare(current);
    if (listenWhen != null) {
      result = result || listenWhen!(previous, current);
    }
    return result;
  }

  bool _buildWhen(TState previous, TState current) {
    var result = previous.baseStateCompare(current);
    if (buildWhen != null) {
      result = result || buildWhen!(previous, current);
    }
    return result;
  }
}
