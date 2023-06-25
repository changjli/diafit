import 'package:diafit/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'dart:io';
import 'package:diafit/controller/custom_function.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  String? gender;
  var ageController = TextEditingController();
  var heightController = TextEditingController();
  var weightController = TextEditingController();
  var addressController = TextEditingController();
  var weightGoalController = TextEditingController();
  var nutritionGoalController = TextEditingController();
  var exerciseGoalController = TextEditingController();
  var glucoseGoalController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    addressController.dispose();
    glucoseGoalController.dispose();
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
        addressController.text = user["address"].toString() ?? '';
        ageController.text = user["age"].toString() ?? '';
        heightController.text = user["height"].toString() ?? '';
        weightController.text = user["weight"].toString() ?? '';
        addressController.text = user["address"] ?? '';
        weightGoalController.text = user["weightGoal"].toString() ?? '';
        nutritionGoalController.text = user["nutritionGoal"].toString() ?? '';
        exerciseGoalController.text = user["exerciseGoal"].toString() ?? '';

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
          "gender": gender,
          "age": int.parse(ageController.text),
          "height": double.parse(heightController.text),
          "weight": double.parse(weightController.text),
          "address": addressController.text,
          "weightGoal": double.parse(weightGoalController.text),
          "nutritionGoal": double.parse(nutritionGoalController.text),
          "exerciseGoal": double.parse(exerciseGoalController.text),
          "image": image!.path,
        }),
      );
      Map output = jsonDecode(response.body);
      print(output);

      if (response.statusCode == 200) {
        Map data = output['data'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   onPressed: () => {},
        //   icon: const Icon(LineAwesomeIcons.angle_left),
        //   color: Colors.black,
        // ),
        // title: const Center(
        //   child: Text(
        //     "Edit Profile",
        //     style: TextStyle(
        //       fontFamily: 'Montserrat',
        //       fontWeight: FontWeight.bold,
        //       fontSize: 20,
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.settings),
        //     color: Colors.black,
        //   )
        // ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
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
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(30),
                    child: Column(children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 170,
                            height: 170,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(120),
                              child: const Image(
                                  image:
                                      AssetImage("assets/images/profile.jpg")),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              pickImage();
                            },
                            child: Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color:
                                      const Color.fromARGB(255, 157, 127, 168),
                                ),
                                child: const Icon(
                                  LineAwesomeIcons.camera,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Hello",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        emailController.text,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          color: Color.fromARGB(159, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Form(
                        child: Column(children: [
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              label: const Text("Full Name"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              prefixIcon: const Icon(
                                size: 25,
                                Icons.person_outline_rounded,
                                color: Colors.black,
                              ),
                              labelStyle: const TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 170,
                                height: 130,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(
                                      () {
                                        gender = 'male';
                                      },
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: gender == 'male'
                                        ? Colors.blue
                                        : Colors.white,
                                    side: const BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Image.asset(
                                    'assets/images/men-icon.png',
                                    width: 75,
                                    height: 75,
                                    color: gender == 'male'
                                        ? Colors.white
                                        : Colors.blue,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 170,
                                height: 130,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(
                                      () {
                                        gender = 'female';
                                      },
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: gender == 'female'
                                        ? Colors.pink
                                        : Colors.white,
                                    side: const BorderSide(
                                      color: Colors.pink,
                                      width: 2.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Image.asset(
                                    'assets/images/women-icon.png',
                                    width: 75,
                                    height: 75,
                                    color: gender == 'female'
                                        ? Colors.white
                                        : Colors.pink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: addressController,
                            decoration: InputDecoration(
                              label: const Text("Address"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              prefixIcon: const Icon(
                                size: 25,
                                LineAwesomeIcons.user_clock,
                                color: Colors.black,
                              ),
                              labelStyle: const TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: ageController,
                            decoration: InputDecoration(
                              label: const Text("Age"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              prefixIcon: const Icon(
                                size: 25,
                                LineAwesomeIcons.user_clock,
                                color: Colors.black,
                              ),
                              labelStyle: const TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: heightController,
                            decoration: InputDecoration(
                              label: const Text("Height"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              prefixIcon: const Icon(
                                size: 25,
                                LineAwesomeIcons.ruler_vertical,
                                color: Colors.black,
                              ),
                              labelStyle: const TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: weightController,
                            decoration: InputDecoration(
                                label: const Text("Weight"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                prefixIcon: const Icon(
                                  size: 25,
                                  LineAwesomeIcons.weight,
                                  color: Colors.black,
                                ),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
                                ))),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: weightGoalController,
                            decoration: InputDecoration(
                                label: const Text("Weight Goal"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                prefixIcon: const Icon(
                                  size: 25,
                                  LineAwesomeIcons.weight,
                                  color: Colors.black,
                                ),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
                                ))),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: nutritionGoalController,
                            decoration: InputDecoration(
                                label: const Text("Nutrition Goal"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                prefixIcon: const Icon(
                                  size: 25,
                                  LineAwesomeIcons.weight,
                                  color: Colors.black,
                                ),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
                                ))),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: exerciseGoalController,
                            decoration: InputDecoration(
                                label: const Text("Exercise Goal"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                prefixIcon: const Icon(
                                  size: 25,
                                  LineAwesomeIcons.weight,
                                  color: Colors.black,
                                ),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
                                ))),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: glucoseGoalController,
                            decoration: InputDecoration(
                                label: const Text("Glucose Goal"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                prefixIcon: const Icon(
                                  size: 25,
                                  LineAwesomeIcons.weight,
                                  color: Colors.black,
                                ),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
                                ))),
                          ),
                        ]),
                      ),
                      CustomButton(content: 'update', function: updateUser),
                    ]),
                  );
                }
              }
            }),
      ),
    );
  }
}
