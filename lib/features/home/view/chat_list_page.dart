import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/features/contact/select_contact/view/select_contact_page.dart';
import 'package:scandium/features/home/bloc/home_bloc.dart';
import 'package:scandium/product/widgets/cards/custom_card.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => const SelectContactPage()),
            );
          },
          child: const Icon(
            Icons.chat,
            color: Colors.white,
          ),
        ),
        body: ListView.builder(
          itemCount: state.messages.length,
          itemBuilder: (contex, index) => CustomCard(
            messageModel: state.messages[index],
          ),
        ),
      );
    }, buildWhen: (previous, current) {
      return previous.messages != current.messages;
    });
  }
}
