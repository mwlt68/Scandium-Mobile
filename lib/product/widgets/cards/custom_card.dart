import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scandium/core/extensions/date_extension.dart';
import 'package:scandium/features/authentication/bloc/authentication_bloc.dart';
import 'package:scandium/features/chat/view/chat_page.dart';
import 'package:scandium/features/home/bloc/home_bloc.dart';
import 'package:scandium/product/models/response/message_response_model.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, required this.messageModel}) : super(key: key);
  final MessageResponseModel messageModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthenticationBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context)),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            var otherUserId = messageModel.getOtherUserId(state.user?.id);
            if (otherUserId != null) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => ChatPage(
                                otherUserId: otherUserId,
                              ))).then(
                      (value) => context.read<HomeBloc>().add(LoadHomeEvent()));
                },
                child: Column(
                  children: [
                    ListTile(
                      leading: SizedBox(
                        height: 42,
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey,
                          child: SvgPicture.asset(
                            "assets/person.svg",
                            height: 32,
                            width: 32,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ),
                        ),
                      ),
                      title: Text(
                        messageModel.getOtherUserName(state.user?.id) ??
                            "Sender",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(
                            Icons.done_all,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Flexible(
                            child: Text(
                              messageModel.content ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing:
                          Text(messageModel.createDate?.getFormatted() ?? ''),
                    )
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
