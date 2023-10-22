import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scandium/core/init/extension/string_extension.dart';
import 'package:scandium/core/init/locale_keys.g.dart';
import 'package:scandium/features/chat/bloc/chat_bloc.dart';
import 'package:scandium/features/chat/view/own_message_card.dart';
import 'package:scandium/product/models/response/conversation_reponse_model.dart';
import 'package:scandium/product/models/response/user_response_model.dart';
import 'package:scandium/product/repositories/message/message_repository.dart';
import 'package:scandium/product/widgets/progress_indicators/circular_progress_bloc_builder.dart';
import 'package:scandium/product/widgets/scaffold/base_scaffold_bloc.dart';
import 'package:scandium/product/widgets/text/localized_text.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class ChatPage extends StatelessWidget {
  ChatPage({required this.otherUserId, super.key});
  final String otherUserId;
  final GroupedItemScrollController _scrollController =
      GroupedItemScrollController();

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldBlocListener<ChatBloc, ChatState, ChatEvent>(
        create: (context) => ChatBloc(
            messageRepository:
                RepositoryProvider.of<MessageRepository>(context))
          ..add(GetConversationEvent(otherUserId)),
        child: Scaffold(
          appBar: _appBar(context),
          body: _body(),
        ));
  }

  _appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        leadingWidth: 70,
        titleSpacing: 0,
        leading: _appBarLeading(context),
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
              PopupMenuItem(
                child: LocText(LocaleKeys.pages_chat_viewContact.lcl),
              )
            ];
          },
        ),
      ];

  Widget get _appBarTitle => InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(6),
        child: CircularProgressBlocBuilder<ChatBloc, ChatState, ChatEvent>(
            getChild: (c, state) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.otherUser?.username ??
                          LocaleKeys.generals_emptyFieldText.lcl,
                      style: const TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      LocaleKeys.pages_chat_lastSeenMessage.lcl,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    )
                  ],
                )),
      ));

  Widget _appBarLeading(BuildContext context) => InkWell(
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
      hintText: LocaleKeys.pages_chat_messageInputHintText.lcl,
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
                  builder: (builder) => bottomSheet(context));
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

  Widget bottomSheet(BuildContext context) {
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
                  iconCreation(Icons.insert_drive_file, Colors.indigo,
                      LocaleKeys.pages_chat_document.lcl),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink,
                      LocaleKeys.pages_chat_camera.lcl),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple,
                      LocaleKeys.pages_chat_gallary.lcl),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange,
                      LocaleKeys.pages_chat_audio.lcl),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal,
                      LocaleKeys.pages_chat_location.lcl),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue,
                      LocaleKeys.pages_chat_contact.lcl),
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
