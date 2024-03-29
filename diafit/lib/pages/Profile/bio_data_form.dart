import 'dart:io';

import 'package:diafit/components/custom_button.dart';
import 'package:diafit/components/custom_textfield.dart';
import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/controller/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

// Define a custom Form widget.
class BioDataForm extends StatefulWidget {
  const BioDataForm({super.key});

  @override
  BioDataFormState createState() {
    return BioDataFormState();
  }
}

class BioDataFormState extends State<BioDataForm> {
  final _formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var genderController = TextEditingController();
  var ageController = TextEditingController();
  var heightController = TextEditingController();
  var weightController = TextEditingController();
  var addressController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    genderController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    addressController.dispose();
    super.dispose();
  }

  String id = "";
  String apiToken = "";
  Map user = {};
  File? image;
  File? newImage;

  Future<void> getAuth() async {
    Map temp = await CustomFunction.getAuth();
    id = temp['id'];
    apiToken = temp['apiToken'];
  }

  // show user
  Future<void> getUser() async {
    await getAuth();
    try {
      http.Response response = await http.get(
          Uri.parse("http://10.0.2.2:8000/api/profile/$id"),
          headers: {"Authorization": "Bearer $apiToken"});

      if (response.statusCode == 200) {
        user = jsonDecode(response.body);

        // initial value
        emailController.text = user["email"] ?? '';
        nameController.text = user["name"] ?? '';
        genderController.text = user["gender"] ?? '';
        ageController.text = user["age"].toString() ?? '';
        heightController.text = user["height"].toString() ?? '';
        weightController.text = user["weight"].toString() ?? '';
        addressController.text = user["address"] ?? '';

        if (user["image"] != null) {
          image = File(user["image"]);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void validateInput() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    updateUser();
  }

  // update user
  void updateUser() async {
    try {
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/profile/$id"),
        headers: {
          "Authorization": "Bearer $apiToken",
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          "_method": 'put',
          "name": nameController.text,
          "gender": genderController.text,
          "age": int.parse(ageController.text),
          "height": double.parse(heightController.text),
          "weight": double.parse(weightController.text),
          "address": addressController.text,
          "image": image!.path,
        }),
      );
      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Map data = output['data'];
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  Future pickImage() async {
    try {
      // input
      final XFile? file =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null) return;

      // final imageTemp = File(image.path);

      // directory
      final Directory duplicateFileDirectory =
          await getApplicationDocumentsDirectory();
      // final Directory? duplicateFileDirectory =
      //     await getExternalStorageDirectory();
      final String duplicateFilePath = duplicateFileDirectory.path;
      final String fileName = basename(file.path);
      final String imagePath = "$duplicateFilePath/$fileName";

      // save
      await file.saveTo('$duplicateFilePath/$fileName');
      final File localImage = File(imagePath);

      image = localImage;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  // kalo pencet tombol balik delete image

  @override
  Widget build(BuildContext context) {
    // initial
    return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occured'),
            );
          } else {
            return Form(
              key: _formKey,
              child: Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: image == null
                          ? const AssetImage(
                                  'assets/images/profile_picture.png')
                              as ImageProvider
                          : FileImage(File(image!.path)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      emailController.text,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextfield(
                        content: 'name',
                        controller: nameController,
                        validator: Validator.emailValidator),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextfield(
                        content: 'gender',
                        controller: genderController,
                        validator: Validator.emailValidator),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextfield(
                        content: 'age',
                        controller: ageController,
                        validator: Validator.emailValidator),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextfield(
                        content: 'height',
                        controller: heightController,
                        validator: Validator.emailValidator),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextfield(
                        content: 'weight',
                        controller: weightController,
                        validator: Validator.emailValidator),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextfield(
                        content: 'address',
                        controller: addressController,
                        validator: Validator.emailValidator),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    // Image(image: FileImage(File(image!.path))),
                    ElevatedButton(
                      onPressed: pickImage,
                      child: const Text('Pick image from gallery'),
                    ),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: CustomButton(
                        content: 'Update',
                        function: validateInput,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }
}
