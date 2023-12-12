import 'package:flutter/material.dart';
import 'package:weather_app_tutorial/constant/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  void _handleTapInputOutside(PointerDownEvent e) {
    debugPrint("tap outside do nothing?");
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 20, right: 10),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10)),
      child: TextField(
        style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        cursorColor: const Color.fromARGB(255, 0, 0, 0),
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: const BorderSide(
                  color: GlobalVariables.selectedColor, width: 2.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: const BorderSide(
                  color: GlobalVariables.selectedColor, width: 2.0),
            ),
            hintText: widget.hintText,
            hintStyle: const TextStyle(
                color: Color.fromARGB(234, 104, 102, 102), fontSize: 15)),
        controller: widget.controller,
        onTapOutside: _handleTapInputOutside,
      ),
    );
  }
}
