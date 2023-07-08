import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/features/contact/contact_request/bloc/contact_request_bloc.dart';
import 'package:scandium/product/models/base/selectable_model.dart';
import 'package:scandium/product/repositories/friendship_request/friendship_request_repository.dart';
import 'package:scandium/product/widgets/conditional_circular_progress.dart';

import 'package:scandium/product/widgets/contact_card.dart';

class ContactRequestPage extends StatefulWidget {
  const ContactRequestPage({super.key});

  @override
  State<ContactRequestPage> createState() => _ContactRequestPageState();
}

class _ContactRequestPageState extends State<ContactRequestPage> {
  late TextEditingController searchValueController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ContactRequestBloc(
            friendshipRequestRepository:
                RepositoryProvider.of<FriendshipRequestRepository>(context))
          ..add(const GetRequests()),
        child: _blocListener());
  }

  BlocListener<ContactRequestBloc, ContactRequestState> _blocListener() {
    return BlocListener<ContactRequestBloc, ContactRequestState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
              ));
          }
        },
        child: Scaffold(
          appBar: _scaffoldAppBar(),
          body: _scaffoldBody(),
        ));
  }

  _scaffoldBody() {
    return BlocBuilder<ContactRequestBloc, ContactRequestState>(
      builder: (context, state) {
        return ConditionalCircularProgress(
          isLoading: state.isLoading,
          hasMessage:
              state.requestedUsers == null || state.requestedUsers!.isEmpty,
          message: 'You have no friend requests',
          child: _blocBuilderChild(state),
        );
      },
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
    );
  }

  ListView _blocBuilderChild(ContactRequestState state) {
    return ListView.builder(
        itemCount: state.requestedUsers!.length,
        itemBuilder: (context, index) {
          return ContactCard(
            contact: SelectableModel(model: state.requestedUsers![index]),
            contactCardListTileTrailing: ContactCardListTileTrailing(
              buttonText: "Approve",
              onPressed: () {
                context.read<ContactRequestBloc>().add(
                      RequestApproved(state.requestedUsers![index].id!),
                    );
              },
            ),
          );
        });
  }

  _scaffoldAppBar() {
    return AppBar(
      title: const Text('Follow requests'),
    );
  }
}