import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/core/init/extension/string_extension.dart';
import 'package:scandium/core/init/locale_keys.g.dart';
import 'package:scandium/features/contact/contact_request/bloc/contact_request_bloc.dart';
import 'package:scandium/product/models/base/selectable_model.dart';
import 'package:scandium/product/repositories/friendship_request/friendship_request_repository.dart';
import 'package:scandium/product/widgets/cards/contact_card.dart';
import 'package:scandium/product/widgets/progress_indicators/circular_progress_bloc_builder.dart';
import 'package:scandium/product/widgets/scaffold/base_scaffold_bloc.dart';

class ContactRequestPage extends StatelessWidget {
  ContactRequestPage({super.key});

  late TextEditingController searchValueController;

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldBlocListener<ContactRequestBloc, ContactRequestState,
            ContactRequestEvent>(
        create: (context) => ContactRequestBloc(
            friendshipRequestRepository:
                RepositoryProvider.of<FriendshipRequestRepository>(context))
          ..add(const GetRequestsEvent()),
        child: Scaffold(
          appBar: _scaffoldAppBar(),
          body: _scaffoldBody(),
        ));
  }

  _scaffoldBody() {
    return CircularProgressBlocBuilder<ContactRequestBloc, ContactRequestState,
        ContactRequestEvent>(
      getChild: (c, state) => _blocBuilderChild(state),
      hasMessage: (state) =>
          state.friendshipResponses == null ||
          state.friendshipResponses!.isEmpty,
      message: LocaleKeys.pages_contactRequest_noDataMessage.lcl,
      buildWhen: (previous, current) =>
          previous.friendshipResponses != current.friendshipResponses,
    );
  }

  ListView _blocBuilderChild(ContactRequestState state) {
    return ListView.builder(
        itemCount: state.friendshipResponses!.length,
        itemBuilder: (context, index) {
          return ContactCard(
            contact: SelectableModel(
                model: state.friendshipResponses![index].sender),
            contactCardListTileTrailing: ContactCardListTileTrailing(
              buttonText: state.friendshipResponses![index].isApproved!
                  ? LocaleKeys.pages_contactRequest_following.lcl
                  : LocaleKeys.pages_contactRequest_approve.lcl,
              onPressed: state.friendshipResponses![index].isApproved!
                  ? null
                  : () {
                      context.read<ContactRequestBloc>().add(
                            RequestApproveEvent(
                                state.friendshipResponses![index].id!),
                          );
                    },
            ),
          );
        });
  }

  _scaffoldAppBar() {
    return AppBar(
      title: Text(LocaleKeys.pages_contactRequest_followRequestText.lcl),
    );
  }
}
