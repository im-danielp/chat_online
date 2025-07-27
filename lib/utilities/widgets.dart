import 'package:flutter/material.dart';

void snackbarErro(BuildContext context, {required String msg}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(msg)),
        ],
      ),
      backgroundColor: Colors.redAccent,
    ),
  );
}
