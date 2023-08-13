import 'package:flutter/material.dart';
import 'package:scandium/core/extensions/date_extension.dart';
import 'package:scandium/product/constants/application_constants.dart';
import 'package:scandium/product/models/response/conversation_reponse_model.dart';

class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard({super.key, this.message, this.isOwnCard = true});
  final ConversationMessageModel? message;
  final bool isOwnCard;
  final double textSize = 10;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOwnCard ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: isOwnCard ? const Color(0xffdcf8c6) : Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 20,
                ),
                child: Text(
                  message?.content ?? ApplicationConstants.instance.nullField,
                  style: TextStyle(
                    fontSize: textSize + 6,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      message?.createdAt?.getFormatted() ??
                          ApplicationConstants.instance.nullField,
                      style: TextStyle(
                        fontSize: textSize,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    isOwnCard
                        ? Icon(
                            (message?.didTransmit == true
                                ? Icons.done_all
                                : Icons.done),
                            size: textSize + 4,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
