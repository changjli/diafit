import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final String content;
  final IconData icon;
  final TextEditingController controller;
  String? Function(String?) validator;

  CustomTextfield(
      {super.key,
      required this.content,
      required this.icon,
      required this.controller,
      required this.validator});

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  final bool _invalid = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(
        controller: widget.controller,
        style: const TextStyle(
          color: Colors.white,
        ),
        obscureText: widget.content == "password" ? true : false,
        decoration: InputDecoration(
          label: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                widget.content,
              ),
            ],
          ),
          // RichText(
          //   text: TextSpan(children: [
          //     const WidgetSpan(
          //       child: Icon(Icons.person),
          //     ),
          //     TextSpan(
          //       text: content,
          //     ),
          //   ]),
          // ),
          labelStyle: const TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.white)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
        validator: widget.validator,
        // (value) {
        //   if (value == null) {
        //     return 'this field is required';
        //   }
        //   return null;
        // },
      ),
    );
  }
}
