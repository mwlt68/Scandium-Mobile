import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/features/contact/contact_request/view/contact_request_page.dart';
import 'package:scandium/features/contact/new_contact/view/new_contact_page.dart';
import 'package:scandium/features/home/bloc/home_bloc.dart';
import 'package:scandium/features/home/view/chat_page.dart';
import 'package:scandium/product/repositories/message/message_repository.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';

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
    return BlocProvider(
      create: (context) => HomeBloc(
          userRepository: RepositoryProvider.of<UserRepository>(context),
          messageRepository: RepositoryProvider.of<MessageRepository>(context))
        ..add(LoadHomeEvent()),
      child: Scaffold(
        appBar: _scaffoldAppBar(),
        body: _scaffoldBody(context),
      ),
    );
  }

  Widget _scaffoldBody(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoadedState) {
          return TabBarView(
            controller: _controller,
            children: [
              const Text("CAMERA"),
              ChatPage(
                messageModels: state.messages,
                sourceMessageModel: null,
              ),
              const Text("STATUS"),
              const Text("CALLS"),
            ],
          );
        } else if (state is HomeErrorState) {
          return Text(state.error ?? 'Unknown error !');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  PreferredSize _scaffoldAppBar() => PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return AppBar(
              title: const Text("Whatsapp Clone"),
              actions: _appBarActions,
              bottom: _appBarBottom(),
            );
          },
        ),
      );

  List<Widget> get _appBarActions {
    return [
      IconButton(icon: const Icon(Icons.search), onPressed: () {}),
      PopupMenuButton<String>(
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
            const PopupMenuItem(value: "Settings", child: Text("Settings")),
            PopupMenuItem(
              value: "LogOut",
              child: const Text("Log Out"),
              onTap: () async {
                contesxt.read<HomeBloc>().add(const LogOutSubmitted());
              },
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
}
