// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scandium/product/models/base/selectable_model.dart';
import 'package:scandium/product/models/response/user_response_model.dart';

class ContactCard extends StatelessWidget {
  const ContactCard(
      {Key? key,
      required this.contact,
      this.contactCardListTileTrailing,
      this.onTap})
      : super(key: key);
  final SelectableModel<UserResponseModel> contact;
  final ContactCardListTileTrailing? contactCardListTileTrailing;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
        leading: SizedBox(
          width: 50,
          height: 53,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: Colors.blueGrey[200],
                child: SvgPicture.asset(
                  "assets/person.svg",
                  color: Colors.white,
                  height: 30,
                  width: 30,
                ),
              ),
              contact.isSelected
                  ? const Positioned(
                      bottom: 4,
                      right: 5,
                      child: CircleAvatar(
                        backgroundColor: Colors.teal,
                        radius: 11,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        title: Text(
          contact.model?.username ?? '',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text(
          'Status',
          style: TextStyle(
            fontSize: 13,
          ),
        ),
        trailing: contactCardListTileTrailing != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: TextButton(
                      onPressed: contactCardListTileTrailing!.onPressed,
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                      child: Text(contactCardListTileTrailing!.buttonText),
                    ),
                  ),
                ],
              )
            : null);
  }
}

class ContactCardListTileTrailing {
  String buttonText;
  void Function()? onPressed;
  ContactCardListTileTrailing({
    required this.buttonText,
    this.onPressed,
  });
}
