import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/features/contact/new_contact/bloc/new_contact_bloc.dart';
import 'package:scandium/product/models/base/selectable_model.dart';
import 'package:scandium/product/models/response/user_search_response_model.dart';
import 'package:scandium/product/repositories/friendship_request/friendship_request_repository.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';
import 'package:scandium/product/widgets/conditional_circular_progress.dart';
import 'package:scandium/product/widgets/contact_card.dart';

class NewContactPage extends StatefulWidget {
  const NewContactPage({super.key});

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  late TextEditingController searchValueController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => NewContactBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
            friendshipRequestRepository:
                RepositoryProvider.of<FriendshipRequestRepository>(context)),
        child: _blocListener());
  }

  BlocListener<NewContactBloc, NewContactState> _blocListener() {
    return BlocListener<NewContactBloc, NewContactState>(
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
    return BlocBuilder<NewContactBloc, NewContactState>(
      builder: (context, state) {
        return ConditionalCircularProgress(
          isLoading: state.isLoading,
          child: ListView.builder(
              itemCount: state.searcResultUsers!.length,
              itemBuilder: (context, index) {
                return ContactCard(
                  contact: SelectableModel(
                      model: state.searcResultUsers![index].userResponseDto),
                  contactCardListTileTrailing: ContactCardListTileTrailing(
                    buttonText: state
                        .searcResultUsers![index].friendshipRequestStatus!.name,
                    onPressed: state.searcResultUsers![index]
                                .friendshipRequestStatus ==
                            FriendshipRequestStatus.Follow
                        ? () {
                            context.read<NewContactBloc>().add(
                                  FollowSubmitted(state.searcResultUsers![index]
                                      .userResponseDto!.id!),
                                );
                          }
                        : null,
                  ),
                );
              }),
        );
      },
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
    );
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
                key: const Key('newContactFrom_searchInput_textField'),
                decoration: const InputDecoration(
                  labelText: 'Search by username',
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
