import 'package:flutter/material.dart';
import 'package:scandium/features/contact/new_contact/view/new_contact_page.dart';
import 'package:scandium/product/models/base/selectable_model.dart';
import 'package:scandium/product/models/response/user_response_model.dart';
import 'package:scandium/product/widgets/button_card.dart';
import 'package:scandium/product/widgets/contact_card.dart';

import '../contact_request/view/contact_request_page.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({Key? key}) : super(key: key);

  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  @override
  Widget build(BuildContext context) {
    List<UserResponseModel> contacts = [
      UserResponseModel(id: 'asdad1', username: 'Ahmet Alan'),
      UserResponseModel(id: 'asdad2', username: 'Mehmet Melan'),
      UserResponseModel(id: 'asdad3', username: 'Cemal Çalan'),
      UserResponseModel(id: 'asdad4', username: 'Filan Falan'),
    ];

    return Scaffold(appBar: _appBar(context), body: _body(contacts));
  }

  ListView _body(List<UserResponseModel> contacts) {
    return ListView.builder(
        itemCount: contacts.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _newGroupCard();
          } else if (index == 1) {
            return _newContactCard(context);
          }
          return ContactCard(
            contact: SelectableModel(model: contacts[index - 2]),
          );
        });
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: _appBarTitle(),
      actions: _appBarActions(context),
    );
  }

  Column _appBarTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Select Contact",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "256 contacts",
          style: TextStyle(
            fontSize: 13,
          ),
        )
      ],
    );
  }

  List<Widget> _appBarActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(
            Icons.search,
            size: 26,
          ),
          onPressed: () {}),
      IconButton(
          icon: const Icon(
            Icons.follow_the_signs,
            size: 26,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => const ContactRequestPage()));
          }),
    ];
  }

  InkWell _newContactCard(BuildContext context) {
    return InkWell(
      child: const ButtonCard(
        iconData: Icons.person_add,
        name: "New contact",
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (builder) => const NewContactPage()));
      },
    );
  }

  ButtonCard _newGroupCard() {
    return const ButtonCard(
      iconData: Icons.group,
      name: "New group",
    );
  }
}
