import 'package:flutter/material.dart';
import 'package:paml_20190140086_ewallet/utilities/constant.dart';

class InputText extends StatefulWidget {
  const InputText({super.key, required this.validatorMessage, required this.prefixIcon, required this.labelText, required this.style, required this.controller});

  final String validatorMessage;
  final Icon prefixIcon;
  final String labelText;
  final int style;
  final TextEditingController controller;

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    if(widget.style == 1){ // style form login/register

      return TextFormField(
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
        ),
        validator: (value) => value.toString().isEmpty ? widget.validatorMessage : null,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide.none
          ),
          fillColor: const Color(0xFF6CA8F1),
          filled: true,
          contentPadding: const EdgeInsets.only(top: 14.0),
          prefixIcon: widget.prefixIcon,
          hintText: widget.labelText,
          hintStyle: hintTextStyle,
          errorStyle: const TextStyle(color: Colors.white70)
        ),
        keyboardType: TextInputType.emailAddress,
        controller: widget.controller,
      );

    }else{

      return TextFormField(
        keyboardType: TextInputType.text,
        validator: (value) => value.toString().isEmpty ? widget.validatorMessage : null,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide.none
          ),
          prefixIcon: widget.prefixIcon,
          hintText: widget.labelText,
          fillColor: Colors.grey.shade200,
          filled: true
        ),
        controller: widget.controller,
      );

    }
  }
}