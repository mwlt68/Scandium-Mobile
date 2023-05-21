import 'package:flutter/material.dart';
import 'package:scandium/features/home/view/home_page.dart';
import 'package:scandium/product/models/response/message_response_model.dart';
import 'package:scandium/product/widgets/custom_card.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {Key? key, required this.messageModels, required this.sourceMessageModel})
      : super(key: key);
  final List<MessageResponseModel> messageModels;
  final MessageResponseModel? sourceMessageModel;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => const HomePage()));
        },
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: widget.messageModels.length,
        itemBuilder: (contex, index) => CustomCard(
          messageModel: widget.messageModels[index],
          sourceMessageModel: widget.sourceMessageModel,
        ),
      ),
    );
  }
}
