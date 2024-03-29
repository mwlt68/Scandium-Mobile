import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/core/init/extension/string_extension.dart';
import 'package:scandium/core/init/locale_keys.g.dart';
import 'package:scandium/features/chat/view/chat_page.dart';
import 'package:scandium/features/contact/new_contact/view/new_contact_page.dart';
import 'package:scandium/features/contact/select_contact/bloc/select_contact_bloc.dart';
import 'package:scandium/product/models/base/selectable_model.dart';
import 'package:scandium/product/repositories/friendship_request/friendship_request_repository.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';
import 'package:scandium/product/widgets/cards/button_card.dart';
import 'package:scandium/product/widgets/cards/contact_card.dart';
import 'package:scandium/product/widgets/progress_indicators/circular_progress_bloc_builder.dart';
import 'package:scandium/product/widgets/scaffold/base_scaffold_bloc.dart';
import '../../contact_request/view/contact_request_page.dart';

class SelectContactPage extends StatelessWidget {
  const SelectContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldBlocListener<SelectContactBloc, SelectContactState,
            SelectContactEvent>(
        create: (context) => SelectContactBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
            friendshipRequestRepository:
                RepositoryProvider.of<FriendshipRequestRepository>(context))
          ..add(GetContactsEvent()),
        child: Scaffold(appBar: _appBar(context), body: _body()));
  }

  Widget _body() {
    return CircularProgressBlocBuilder<SelectContactBloc, SelectContactState,
        SelectContactEvent>(
      getChild: (c, s) => ListView.builder(
          itemCount: s.users!.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _newGroupCard();
            } else if (index == 1) {
              return _newContactCard(context);
            }
            return _listViewContactCard(s, index, context);
          }),
      buildWhen: (p, c) => p.users != c.users,
    );
  }

  ContactCard _listViewContactCard(
      SelectContactState state, int index, BuildContext context) {
    return ContactCard(
        contact: SelectableModel(model: state.users![index - 2]),
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) =>
                      ChatPage(otherUserId: state.users![index - 2].id!)));
        });
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: _appBarTitle(),
      actions: _appBarActions(context),
    );
  }

  Column _appBarTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.pages_selectContact_pageTitle.lcl,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        BlocBuilder<SelectContactBloc, SelectContactState>(
          builder: (context, state) {
            return Text(
              LocaleKeys.pages_selectContact_contactCountText
                  .tr(args: [(state.users?.length ?? 0).toString()]),
              style: const TextStyle(
                fontSize: 13,
              ),
            );
          },
        )
      ],
    );
  }

  List<Widget> _appBarActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(
            Icons.search,
            size: 26,
          ),
          onPressed: () {}),
      BlocBuilder<SelectContactBloc, SelectContactState>(
        builder: (context, state) {
          return IconButton(
              icon: const Icon(
                Icons.follow_the_signs,
                size: 26,
              ),
              onPressed: () => _followRequestsButtonOnPressed(context));
        },
      ),
    ];
  }

  _followRequestsButtonOnPressed(BuildContext context) async {
    Navigator.push(context,
            MaterialPageRoute(builder: (builder) => ContactRequestPage()))
        .then((value) {
      context.read<SelectContactBloc>().add(GetContactsEvent());
    });
  }

  InkWell _newContactCard(BuildContext context) {
    return InkWell(
      child: ButtonCard(
        iconData: Icons.person_add,
        name: LocaleKeys.pages_selectContact_newContact.lcl,
      ),
      onTap: () {
        Navigator.push(context,
                MaterialPageRoute(builder: (builder) => const NewContactPage()))
            .then((value) {
          context.read<SelectContactBloc>().add(GetContactsEvent());
        });
      },
    );
  }

  ButtonCard _newGroupCard() {
    return ButtonCard(
      iconData: Icons.group,
      name: LocaleKeys.pages_selectContact_newGroup.lcl,
    );
  }
}
