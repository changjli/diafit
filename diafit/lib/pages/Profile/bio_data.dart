import 'package:diafit/pages/Profile/bio_data_form.dart';
import 'package:flutter/material.dart';

class BioData extends StatefulWidget {
  const BioData({super.key});

  @override
  State<BioData> createState() => _BioDataState();
}

class _BioDataState extends State<BioData> {
  // String id = "";
  // String apiToken = "";
  // User? user;

  // Future<void> getAuth() async {
  //   Map temp = await CustomFunction.getAuth();
  //   id = temp['id'];
  //   apiToken = temp['apiToken'];
  // }

  // Future<void> getUser() async {
  //   await getAuth();
  //   try {
  //     http.Response response = await http.get(
  //         Uri.parse("http://10.0.2.2:8000/api/profile/$id"),
  //         headers: {"Authorization": "Bearer $apiToken"});

  //     if (response.statusCode == 200) {
  //       Map data = jsonDecode(response.body);
  //       user = User.fromJson(data);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bio Data'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: const [
              BioDataForm(),
            ],
          ),
        ),
        // FutureBuilder(
        //   future: getUser(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     } else {
        //       if (snapshot.hasError) {
        //         return const Center(
        //           child: Text('An error occured'),
        //         );
        //       } else {
        //         return Center(
        //           child: Text(user!.id!),
        //         );
        //       }
        //     }
        //   },
        // ),
      ),
    );
  }
}
