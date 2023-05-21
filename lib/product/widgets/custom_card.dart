import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scandium/product/models/response/message_response_model.dart';
import 'package:intl/intl.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {Key? key, required this.messageModel, required this.sourceMessageModel})
      : super(key: key);
  final MessageResponseModel messageModel;
  final MessageResponseModel? sourceMessageModel;

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
                  false ? "assets/groups.svg" : "assets/person.svg",
                  height: 32,
                  width: 32,
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
            title: Text(
              messageModel.sender?.username ?? "Sender",
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
                  messageModel.content ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: Text(messageModel.createDate != null
                ? DateFormat('yyyy-MM-dd – kk:mm')
                    .format(messageModel.createDate!)
                : ''),
          )
        ],
      ),
    );
  }
}
