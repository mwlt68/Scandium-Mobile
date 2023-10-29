import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandium/core/init/extension/string_extension.dart';
import 'package:scandium/core/init/locale_keys.g.dart';
import 'package:scandium/features/home/bloc/home_bloc.dart';
import 'package:scandium/features/home/view/chat_list_page.dart';
import 'package:scandium/product/constants/application_constants.dart';
import 'package:scandium/product/repositories/message/message_repository.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';
import 'package:scandium/product/widgets/progress_indicators/circular_progress_bloc_builder.dart';
import 'package:scandium/product/widgets/scaffold/base_scaffold_bloc.dart';
import 'package:scandium/product/widgets/text/localized_text.dart';
part 'home_values.dart';

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
  _HomeValues values = _HomeValues();
  @override
  void initState() {
    super.initState();
    _controller =
        TabController(length: tabs.length, vsync: this, initialIndex: 1);
  }

  late TabController _controller;
  @override
  Widget build(BuildContext context) {
    return BaseScaffoldBlocListener<HomeBloc, HomeState, HomeEvent>(
        create: (context) => HomeBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
            messageRepository:
                RepositoryProvider.of<MessageRepository>(context))
          ..add(LoadHomeEvent()),
        child: Scaffold(
          appBar: _scaffoldAppBar(),
          body: _scaffoldBody(context),
        ));
  }

  Widget _scaffoldBody(BuildContext context) {
    return CircularProgressBlocBuilder<HomeBloc, HomeState, HomeEvent>(
        getChild: (c, s) => TabBarView(
              controller: _controller,
              children: [
                LocText(LocaleKeys.pages_home_cameraTab.lcl),
                ChatListPage(),
                LocText(LocaleKeys.pages_home_statusTab.lcl),
                LocText(LocaleKeys.pages_home_callsTab.lcl),
              ],
            ));
  }

  PreferredSize _scaffoldAppBar() => PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return AppBar(
              title: Text(ApplicationConstants.instance.appName),
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
            PopupMenuItem(
              value: values.logOutKey,
              child: LocText(LocaleKeys.pages_home_logOut.lcl),
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
    return [
      const Tab(
        icon: Icon(Icons.camera_alt),
      ),
      Tab(
        text: LocaleKeys.pages_home_chatsTab.lcl,
      ),
      Tab(
        text: LocaleKeys.pages_home_statusTab.lcl,
      ),
      Tab(
        text: LocaleKeys.pages_home_callsTab.lcl,
      )
    ];
  }
}
