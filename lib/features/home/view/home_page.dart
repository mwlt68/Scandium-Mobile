import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/features/home/bloc/home_bloc.dart';
import 'package:scandium/product/models/chat_model.dart';
import 'package:scandium/product/widgets/custom_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller =
        TabController(length: tabs.length, vsync: this, initialIndex: 1);
  }

  late TabController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _scaffoldAppBar(),
      body: BlocProvider(
        create: (context) {
          return HomeBloc();
        },
        child: _scaffoldBody(context),
      ),
    );
  }

  AppBar _scaffoldAppBar() => AppBar(
        title: const Text("Whatsapp Clone"),
        actions: _appBarActions,
        bottom: _appBarBottom(),
      );

  List<Widget> get _appBarActions {
    return [
      IconButton(icon: const Icon(Icons.search), onPressed: () {}),
      PopupMenuButton<String>(
        onSelected: (value) {
          print(value);
        },
        itemBuilder: (BuildContext contesxt) {
          return [
            const PopupMenuItem(
              value: "New group",
              child: Text("New group"),
            ),
            const PopupMenuItem(
              value: "New broadcast",
              child: Text("New broadcast"),
            ),
            const PopupMenuItem(
              value: "Whatsapp Web",
              child: Text("Whatsapp Web"),
            ),
            const PopupMenuItem(
              value: "Starred messages",
              child: Text("Starred messages"),
            ),
            const PopupMenuItem(
              value: "Settings",
              child: Text("Settings"),
            ),
          ];
        },
      )
    ];
  }

  TabBar _appBarBottom() {
    return TabBar(
      controller: _controller,
      indicatorColor: Colors.white,
      tabs: tabs,
    );
  }

  List<Widget> get tabs {
    return const [
      Tab(
        icon: Icon(Icons.camera_alt),
      ),
      Tab(
        text: "CHATS",
      ),
      Tab(
        text: "STATUS",
      ),
      Tab(
        text: "CALLS",
      )
    ];
  }

  TabBarView _scaffoldBody(BuildContext context) {
    return TabBarView(
      controller: _controller,
      children: [
        const CameraPage(),
        ChatPage(
          chatmodels: [
            ChatModel(
              currentMessage: "asdasd",
              id: 123,
              isGroup: false,
              name: "Ahmet A",
              time: "08-06-2023",
            ),
            ChatModel(
              currentMessage: "verevrerv",
              id: 123,
              isGroup: false,
              name: "Mehmet A",
              time: "07-06-2023",
            ),
            ChatModel(
              currentMessage: "rnbtyntynty",
              id: 123,
              isGroup: false,
              name: "Cemal A",
              time: "06-06-2023",
            ),
            ChatModel(
              currentMessage: "asdadververvee",
              id: 123,
              isGroup: false,
              name: "Mahmut A",
              time: "05-06-2023",
            ),
          ],
          sourchat: ChatModel(),
        ),
        const Text("STATUS"),
        const Text("Calls"),
      ],
    );
  }
}

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.chatmodels, required this.sourchat})
      : super(key: key);
  late final List<ChatModel> chatmodels;
  late final ChatModel sourchat;

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
        itemCount: widget.chatmodels.length,
        itemBuilder: (contex, index) => CustomCard(
          chatModel: widget.chatmodels[index],
          sourchat: widget.sourchat,
        ),
      ),
    );
  }
}
