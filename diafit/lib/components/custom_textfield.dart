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
          color: Color(0xFF3641B7),
        ),
        obscureText: widget.content == "password" ? true : false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.secondary,
          label: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                widget.content,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
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
            fontSize: 16.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onSecondary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onSecondary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
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
