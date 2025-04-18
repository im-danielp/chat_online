import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  final Function({String? text, File? imgFile}) sendMessage;

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
    setState(() => isComposing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            final XFile? pickImage = await ImagePicker().pickImage(source: ImageSource.gallery);
            if (pickImage == null) return;

            // Converte de XFile para File, aceito pelo Firebase.
            final File imgFile = File(pickImage.path);
            widget.sendMessage(imgFile: imgFile);
          },
          icon: const Icon(Icons.camera_alt_rounded),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration.collapsed(
              hintText: 'Enviar mensagem',
            ),
            onChanged: (text) {
              setState(() => isComposing = text.isNotEmpty);
            },
            onSubmitted: (text) {
              widget.sendMessage(text: text);
              reset();
            },
          ),
        ),
        IconButton(
          onPressed: isComposing
              ? () {
                  widget.sendMessage(text: controller.text);
                  reset();
                }
              : null,
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}
