import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/core/init/extension/string_extension.dart';
import 'package:scandium/core/init/locale_keys.g.dart';
import 'package:scandium/features/contact/new_contact/bloc/new_contact_bloc.dart';
import 'package:scandium/product/models/base/selectable_model.dart';
import 'package:scandium/product/models/response/user_search_response_model.dart';
import 'package:scandium/product/repositories/friendship_request/friendship_request_repository.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';
import 'package:scandium/product/widgets/cards/contact_card.dart';
import 'package:scandium/product/widgets/progress_indicators/circular_progress_bloc_builder.dart';
import 'package:scandium/product/widgets/scaffold/base_scaffold_bloc.dart';
part 'new_contact_values.dart';

class NewContactPage extends StatefulWidget {
  const NewContactPage({super.key});

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  late TextEditingController searchValueController;
  final _values = _NewContactValues();
  @override
  Widget build(BuildContext context) {
    return BaseScaffoldBlocListener<NewContactBloc, NewContactState,
            NewContactEvent>(
        create: (context) => NewContactBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
            friendshipRequestRepository:
                RepositoryProvider.of<FriendshipRequestRepository>(context)),
        child: Scaffold(
          appBar: _scaffoldAppBar(),
          body: _scaffoldBody(),
        ));
  }

  _scaffoldBody() {
    return CircularProgressBlocBuilder<NewContactBloc, NewContactState,
            NewContactEvent>(
        getChild: (c, state) => ListView.builder(
            itemCount: state.searcResultUsers!.length,
            itemBuilder: (context, index) {
              return ContactCard(
                contact: SelectableModel(
                    model: state.searcResultUsers![index].userResponseDto),
                contactCardListTileTrailing: ContactCardListTileTrailing(
                  buttonText: state
                      .searcResultUsers![index].friendshipRequestStatus!.name,
                  onPressed:
                      state.searcResultUsers![index].friendshipRequestStatus ==
                              FriendshipRequestStatus.Follow
                          ? () {
                              context.read<NewContactBloc>().add(
                                    FollowSubmitted(state
                                        .searcResultUsers![index]
                                        .userResponseDto!
                                        .id!),
                                  );
                            }
                          : null,
                ),
              );
            }),
        buildWhen: (previous, current) =>
            previous.searcResultUsers != current.searcResultUsers);
  }

  _scaffoldAppBar() {
    return AppBar(
      title: BlocBuilder<NewContactBloc, NewContactState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                key: Key(_values.searchInputKey),
                decoration: InputDecoration(
                  labelText: LocaleKeys.pages_newContact_searchLabelText.lcl,
                ),
                onChanged: (value) => context.read<NewContactBloc>().add(
                      SearchValueChanged(value),
                    ),
              )
            ],
          );
        },
        buildWhen: (previous, current) =>
            previous.searchValue != current.searchValue,
      ),
    );
  }
}
