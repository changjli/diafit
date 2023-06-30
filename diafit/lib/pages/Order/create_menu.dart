import 'package:diafit/pages/Order/create_menu_form.dart';
import 'package:flutter/material.dart';

class CreateMenu extends StatefulWidget {
  const CreateMenu({super.key});

  @override
  State<CreateMenu> createState() => _CreateMenuState();
}

class _CreateMenuState extends State<CreateMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Menu (Admin Only)',
        ),
      ),
      body: const CreateMenuForm(),
    );
  }
}
