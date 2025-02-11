import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  final Function(String) sendMessage;

  const TextComposer({
    super.key,
    required this.sendMessage,
  });

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final controller = TextEditingController();
  bool isComposing = false;

  void reset() {
    controller.clear();
    setState(() {
      isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.camera_alt_rounded),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration.collapsed(
              hintText: 'Enviar mensagem',
            ),
            onChanged: (text) {
              setState(() {
                isComposing = text.isNotEmpty;
              });
            },
            onSubmitted: (text) {
              widget.sendMessage(text);
              reset();
            },
          ),
        ),
        IconButton(
          onPressed: isComposing
              ? () {
                  widget.sendMessage(controller.text);
                  reset();
                }
              : null,
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}
