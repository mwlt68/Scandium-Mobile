import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scandium/product/models/chat_model.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, required this.chatModel, required this.sourchat})
      : super(key: key);
  final ChatModel chatModel;
  final ChatModel sourchat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        /*
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (contex) => IndividualPage(
                      chatModel: chatModel,
                      sourchat: sourchat,
                    )));

                    */
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
                  chatModel.isGroup ? "assets/groups.svg" : "assets/person.svg",
                  height: 32,
                  width: 32,
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
            title: Text(
              chatModel.name!,
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
                  color: Colors.blue,
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  chatModel.currentMessage!,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: Text(chatModel.time!),
          )
        ],
      ),
    );
  }
}
