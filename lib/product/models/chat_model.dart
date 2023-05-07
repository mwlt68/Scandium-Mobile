class ChatModel {
  String? name;
  String? icon;
  bool isGroup;
  String? time;
  String? currentMessage;
  String? status;
  bool select;
  int? id;
  ChatModel({
    this.name,
    this.icon,
    this.isGroup = false,
    this.time,
    this.currentMessage,
    this.status,
    this.select = false,
    this.id,
  });
}
