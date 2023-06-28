import 'package:diafit/pages/dialog.dart';
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
  var genderController = TextEditingController();
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
  final ValueNotifier<String> profileImage =
      ValueNotifier<String>('assets/images/profile.jpg');
  File? image;

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
        genderController.text = user['gender'] ?? '';
        ageController.text = user["age"] != null ? user["age"].toString() : '';
        heightController.text =
            user["height"] != null ? user["height"].toString() : '';
        weightController.text =
            user["weight"] != null ? user["weight"].toString() : '';
        addressController.text = user["address"] ?? '';
        weightGoalController.text =
            user["weightGoal"] != null ? user["weightGoal"].toString() : '';
        nutritionGoalController.text = user["nutritionGoal"] != null
            ? user["nutritionGoal"].toString()
            : '';
        exerciseGoalController.text =
            user["exerciseGoal"] != null ? user["exerciseGoal"].toString() : '';
        glucoseGoalController.text = user["glucoseGoal"];
        profileImage.value = user["image"];
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
  Future<bool> updateUser() async {
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
          "weightGoal": double.parse(weightGoalController.text),
          "nutritionGoal": double.parse(nutritionGoalController.text),
          "exerciseGoal": double.parse(exerciseGoalController.text),
          "glucoseGoal": double.parse(glucoseGoalController.text),
          "image": profileImage.value,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
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
      profileImage.value = image!.path;
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
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 30),
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
                    return Column(
                      children: [
                        Stack(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: profileImage,
                              builder: (BuildContext context, String value,
                                  Widget? child) {
                                // This builder will only get called when the _counter
                                // is updated.
                                return CircleAvatar(
                                  radius: 80,
                                  backgroundImage:
                                      value == 'assets/images/profile.jpg'
                                          ? AssetImage(value) as ImageProvider
                                          : FileImage(File(value)),
                                );
                              },
                            ),
                            // SizedBox(
                            //   width: 170,
                            //   height: 170,
                            //   child: ClipRRect(
                            //     borderRadius: BorderRadius.circular(120),
                            //     child: const Image(
                            //         image: AssetImage(
                            //             "assets/images/profile.jpg")),
                            //   ),
                            // ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    pickImage();
                                  },
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
                        const SizedBox(height: 20),
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
                                labelStyle:
                                    const TextStyle(color: Colors.black),
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
                              controller: genderController,
                              decoration: InputDecoration(
                                label: const Text("Gender"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                prefixIcon: const Icon(
                                  size: 25,
                                  LineAwesomeIcons.user_clock,
                                  color: Colors.black,
                                ),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
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
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 2,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: addressController,
                              decoration: InputDecoration(
                                label: const Text("Address"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                prefixIcon: const Icon(
                                  size: 25,
                                  Icons.location_city,
                                  color: Colors.black,
                                ),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 2,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
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
                                      labelStyle:
                                          const TextStyle(color: Colors.black),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 2,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: weightController,
                                    decoration: InputDecoration(
                                        label: const Text("Weight"),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        prefixIcon: const Icon(
                                          size: 25,
                                          Icons.scale,
                                          color: Colors.black,
                                        ),
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 2,
                                        ))),
                                  ),
                                ),
                              ],
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
                                    LineAwesomeIcons.balance_scale,
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
                                    LineAwesomeIcons.hamburger,
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
                                    LineAwesomeIcons.running,
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
                                    LineAwesomeIcons.exclamation_triangle,
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
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            bool status = await updateUser();

                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => MyDialog(
                                status: status,
                              ),
                            );

                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              'update',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  }
                }
              }),
        ),
      ),
    );
  }
}
