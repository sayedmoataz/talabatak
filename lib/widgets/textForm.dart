import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class textForm extends StatelessWidget {
  String? text, hint;
  TextEditingController? contoller;
  var validator;
  bool? obsecure;
  bool isPhone;

  textForm(
      {Key? key,
      required this.text,
      required this.hint,
      required this.contoller,
      required this.validator,
      this.obsecure = false, this.isPhone = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${text}", style: TextStyle(color: Colors.blueAccent)),
        TextFormField(
          autofocus: true,
          keyboardType:(isPhone)? TextInputType.number:TextInputType.text,
          obscureText: obsecure ?? false,
          controller: contoller,
          validator: validator,
          decoration: InputDecoration(
            fillColor: Colors.blueAccent.shade100, filled: true,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(),
            ),
            hintText: "${hint}",
          ),
        ),
      ],
    );
  }
}
