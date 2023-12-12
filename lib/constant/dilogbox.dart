import 'package:flutter/material.dart';

void showCustomAlertDialog(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (context) {
      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: AlertDialog(
          backgroundColor: const Color.fromRGBO(36, 36, 36, 0.934),
          title: Text(
            text,
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 15,
            ),
          ),
        ),
      );
    },
  );
}
