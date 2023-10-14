import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scandium/core/init/bloc/bloc/base_bloc.dart';
import 'package:scandium/features/chat/bloc/chat_bloc.dart';
import 'package:scandium/features/chat/view/own_message_card.dart';
import 'package:scandium/product/constants/application_constants.dart';
import 'package:scandium/product/models/response/conversation_reponse_model.dart';
import 'package:scandium/product/models/response/user_response_model.dart';
import 'package:scandium/product/repositories/message/message_repository.dart';
import 'package:scandium/product/widgets/progress_indicators/conditional_circular_progress.dart';
import 'package:scandium/product/widgets/scaffold/base_scaffold_bloc.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({required this.otherUserId, super.key});
  final String otherUserId;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GroupedItemScrollController _scrollController =
      GroupedItemScrollController();

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldBlocListener<ChatBloc, ChatState, ChatEvent>(
        create: (context) => ChatBloc(
            messageRepository:
                RepositoryProvider.of<MessageRepository>(context))
          ..add(GetConversationEvent(widget.otherUserId)),
        child: Scaffold(
          appBar: _appBar(),
          body: _body(),
        ));
  }

  _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        leadingWidth: 70,
        titleSpacing: 0,
        leading: _appBarLeading,
        title: _appBarTitle,
        actions: _appBarActions,
      ),
    );
  }

  _body() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: ((context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              _bodyMessages(state),
              _bodyBottomAlign(context, state),
            ],
          ),
        );
      }),
      buildWhen: (previous, current) {
        return current.content != previous.content ||
            previous.messages != current.messages;
      },
    );
  }

  List<Widget> get _appBarActions => [
        IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
        IconButton(icon: const Icon(Icons.call), onPressed: () {}),
        PopupMenuButton<String>(
          padding: const EdgeInsets.all(0),
          onSelected: (value) {},
          itemBuilder: (BuildContext contesxt) {
            return [
              const PopupMenuItem(
                value: "View Contact",
                child: Text("View Contact"),
              ),
              const PopupMenuItem(
                value: "Media, links, and docs",
                child: Text("Media, links, and docs"),
              ),
              const PopupMenuItem(
                value: "Whatsapp Web",
                child: Text("Whatsapp Web"),
              ),
              const PopupMenuItem(
                value: "Search",
                child: Text("Search"),
              ),
              const PopupMenuItem(
                value: "Mute Notification",
                child: Text("Mute Notification"),
              ),
              const PopupMenuItem(
                value: "Wallpaper",
                child: Text("Wallpaper"),
              ),
            ];
          },
        ),
      ];

  Widget get _appBarTitle => InkWell(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.all(6),
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return ConditionalCircularProgress(
                  isLoading: state.isLoading,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.otherUser?.username ??
                            ApplicationConstants.instance.emptyFieldText,
                        style: const TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "today at 12:05",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      )
                    ],
                  ));
            },
          ),
        ),
      );

  Widget get _appBarLeading => InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.arrow_back,
              size: 24,
            ),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blueGrey,
              child: SvgPicture.asset(
                "assets/person.svg",
                color: Colors.white,
                height: 36,
                width: 36,
              ),
            ),
          ],
        ),
      );

  Align _bodyBottomAlign(BuildContext context, ChatState state) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                _bottomAlignMessageCard(context, state),
                _bottomAlignSendButton(state, context),
              ],
            ),
            Container(),
          ],
        ),
      ),
    );
  }

  Padding _bottomAlignSendButton(ChatState state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
        right: 2,
        left: 2,
      ),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: const Color(0xFF128C7E),
        child: IconButton(
          icon: Icon(
            state.content.isNotEmpty ? Icons.send : Icons.mic,
            color: Colors.white,
          ),
          onPressed: () {
            if (state.content.isNotEmpty) {
              context.read<ChatBloc>().add(SendMessageEvent(state.content));
            }
          },
        ),
      ),
    );
  }

  SizedBox _bottomAlignMessageCard(BuildContext context, ChatState state) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      child: Card(
        margin: const EdgeInsets.only(left: 2, right: 2, bottom: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextFormField(
          controller: TextEditingController(text: state.content)
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: state.content.length),
            ),
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          minLines: 1,
          onChanged: (value) {
            context.read<ChatBloc>().add(ContentChangedEvent(value));
          },
          decoration: _messageCardInputDecoration(context),
        ),
      ),
    );
  }

  InputDecoration _messageCardInputDecoration(BuildContext context) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: "Type a message",
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIcon: IconButton(
        icon: const Icon(Icons.keyboard),
        onPressed: () {},
      ),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (builder) => bottomSheet());
            },
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              _scrollController.jumpTo(index: 15);
            },
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(5),
    );
  }

  Expanded _bodyMessages(ChatState state) {
    var messageCount = state.messages.length;
    var model = Expanded(
      child: StickyGroupedListView<ConversationMessageModel, DateTime>(
        elements: state.messages,
        order: StickyGroupedListOrder.ASC,
        groupBy: (ConversationMessageModel element) => DateTime(
          element.createdAt!.year,
          element.createdAt!.month,
          element.createdAt!.day,
        ),
        groupComparator: (DateTime value1, DateTime value2) =>
            value1.compareTo(value2),
        itemComparator: (ConversationMessageModel element1,
                ConversationMessageModel element2) =>
            element1.createdAt!.compareTo(element2.createdAt!),
        floatingHeader: false,
        groupSeparatorBuilder: _bodyMessagesGroupSeparator,
        indexedItemBuilder: (context, element, index) => _bodyMessagesItem(
            element, index, state.messages.length, state.currentUser!),
        itemScrollController: _scrollController,
      ),
    );
    jumpToEnd(messageCount, state.content);
    return model;
  }

  // This func for  initialScrollIndex error of StickyGroupedListView
  void jumpToEnd(int messageCount, String content) {
    if (messageCount > 0 && content.isEmpty) {
      Future.delayed(const Duration(milliseconds: 150), () {
        _scrollController.jumpTo(index: messageCount);
      });
    }
  }

  Widget _bodyMessagesGroupSeparator(ConversationMessageModel element) {
    return SizedBox(
      height: 40,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            color: Colors.blue[300],
            border: Border.all(
              color: Colors.blue[300]!,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${element.createdAt!.day}/${element.createdAt!.month}/${element.createdAt!.year}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bodyMessagesItem(ConversationMessageModel element, int index,
      int messagesLength, UserResponseModel currentUser) {
    return OwnMessageCard(
        message: element,
        isOwnCard: element.senderIsCurrentUser(currentUser.id!));
  }

  Widget bottomSheet() {
    return SizedBox(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              size: 29,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
