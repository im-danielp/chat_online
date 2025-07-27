import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool mine;

  const ChatMessage({
    super.key,
    required this.data,
    required this.mine,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: mine ? const EdgeInsets.only(left: 30) : const EdgeInsets.only(right: 30),
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Visibility(
            visible: !mine,
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: CircleAvatar(
                backgroundImage: NetworkImage(data['senderPhotoUrl']),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                data['imgUrl'] != null
                    ? Image.network(data['imgUrl'], width: 250)
                    : Text(
                        data['text'],
                        style: const TextStyle(fontSize: 16),
                      ),
                Text(
                  data['senderName'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: mine,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: CircleAvatar(
                backgroundImage: NetworkImage(data['senderPhotoUrl']),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
