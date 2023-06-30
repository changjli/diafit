import 'package:diafit/pages/show_library.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Library'),
        ),
        body: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 800),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Book(
                      title: "Diabetes\nMelitus",
                      content:
                          "Diabetes Melitus, dikenal juga dengan nama kencing manis atau penyakit gula, merupakan penyakit yang terjadi karena tubuh mengalami insufisiensi fungsi insulin sehingga kadar gula dalam darah menjadi tinggi dan tidak dapat dimetabolisme. \n\n Kriteria Diabetes Mellitus \n Seseorang bisa dikatakan menderita diabetes mellitus apabila : \n 1. Kadar Gula Darah Sewaktu > 200gr/dl. \n 2. Kadar Gula Darah Puasa > 126 gr/dl. \n 3. Tes Toleransi Glukosa Oral lebih dari 200gr/dl. \n\n * GDS (Gula Darah Sewaktu) yaitu tes gula darah yang dilakukan pada saat kapanpun walaupun sesudah makan. \n * GDP (Gula Darah Puasa) dilakukan dengan sengaja dan untuk mengetahui kadar gula dalam darah setelah 8 sampai 10 jam tidak makan. \n * TTGO (Tes Toleransi Glukosa Oral) mengharuskan untuk puasa terlebih dahulu dan 2 jam setelah minum.",
                      image: "assets/images/Picture1.jpg",
                    ),
                    Book(
                      title: "Diabetes\nInsipidus",
                      content:
                          "Diabetes insipidus adalah kondisi dimana seseorang terus merasa haus dan menyebabkan produksi urine yang berlebih dari tubuh. Ini disebabkan oleh ketidakseimbangan cairan dari dalam tubuh. Penyakit ini dapat menjadi penyakit bawaan maupun didapat. Diabetes insipidus dibagi menjadi 4 jenis : \n - Diabetes insipidus kranial/sentral terjadi akibat kerusakan pada hipotalamus atau kelenjar pituitari. Hipotalamus adalah bagian otak yang memproduksi ADH, sedangkan kelenjar pituitari merupakan organ tempat penyimpanan ADH. \n - Diabetes insipidus nefrogenik terjadi akibat kelainan pada struktur ginjal sehingga ginjal tidak dapat merespons ADH dengan baik. Kelainan ini dapat disebabkan oleh kelainan genetik yang dialami sejak lahir. \n - Diabetes insipidus dipsogenik disebabkan oleh gangguan pada pengiriman sinyal rasa haus dari otak.  Gangguan ini yang menyebabkan penderita selalu merasa sangat haus, sehingga ia akan minum dalam jumlah yang melebihi kebutuhannya. \n - Diabetes insipidus gestasional adalah jenis diabetes insipidus yang hanya dialami oleh ibu hamil. Kondisi ini bisa terjadi ketika plasenta menghasilkan enzim yang merusak ADH. ",
                      image: "assets/images/Picture2.jpg",
                    ),
                  ],
                ),
                Divider(
                  height: 20,
                  thickness: 10,
                  indent: 35,
                  endIndent: 35,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Book(
                      title: "Symptoms",
                      content:
                          "Keluhan yang umumnya dialami oleh penderita diabetes insipidus antara lain : \n - Selalu merasa sangat haus meski sudah minum banyak air. \n - Sering buang air kecil dalam jumlah banyak, baik di siang maupun malam hari. \n - Urine berwarna pucat atau tidak berwarna. \n- Sering terbangun di malam hari untuk buang air kecil atau malah mengompol saat sedang tidur. \n- Lelah, mudah marah, dan sulit berkonsentrasi dalam menjalani aktivitas sehari-hari. \n\nSementara itu, diabetes insipidus pada bayi dan anak-anak dapat sulit dikenali, apalagi jika mereka belum bisa berkomunikasi dengan baik. Namun, anak-anak dengan kondisi ini umumnya menunjukkan keluhan berikut : \n- Suhu tubuh tinggi atau hipertermia. \n- Sembelit. \n- Sulit tidur. \n- Mengompol saat sedang tidur. \n- Rewel atau mudah marah. \n- Kehilangan selera makan. \n- Muntah. \n- Berat badan menurun tanpa sebab yang jelas. \n- Selalu merasa lelah dan letih. \n- Pertumbuhan lebih lambat dari anak seusianya. \n\nGejala-gejala yang sering dirasakan pada penderita Diabetes Mellitus : \n- Sering buang air kecil. \n- Sering haus. \n- Banyak makan/ mudah lapar. \n\nPada Diabetes Melitus Tipe I gejala klasik yang umum dikeluhkan adalah poliuria, polidipsia, polifagia, penurunan berat badan, cepat merasa lelah (fatigue), iritabilitas, dan pruritus (gatal-gatal pada kulit). \nPada Diabetes Melitus Tipe 2 gejala yang dikeluhkan umumnya hampir tidak ada. DM Tipe 2 seringkali muncul tanpa diketahui, dan penanganan baru dimulai beberapa tahun kemudian ketika penyakit sudah berkembang dan komplikasi sudah terjadi. Penderita DM Tipe 2 umumnya lebih mudah terkena infeksi, sukar sembuh dari luka, daya penglihatan makin buruk, dan umumnya menderita hipertensi, hiperlipidemia, obesitas, dan juga komplikasi pada pembuluh darah dan syaraf.",
                      image: "assets/images/Picture3.jpg",
                    ),
                    Book(
                      title: "Preventions\nManagement",
                      content:
                          "Untuk penderita Diabetes mellitus : \n- Cek gula secara teratur. \n- Konsumsi makanan yang sehat dan jaga pola makan yang baik. \n- Menjaga berat badan ideal. \n- Olahraga secara teratur. \n- Rajin Minum Air Putih. \n- Mempertahankan Kadar Vitamin D secara Optimal. \n\nUntuk penderita Diabetes Insipidus Kranial : \n- Mengonsumsi air putih minimal 2,5 setiap hari untuk mencegah dehidrasi. \n- Pemberian obat desmopressin untuk pengidap insipidus kranial berat untuk mengontrol produksi urine, mencegah dehidrasi, dan menjaga kadar cairan tubuh. (Tidak mengonsumsi obat tanpa resep dokter). \nUntuk penderita Diabetes Insipidus Nefrogenik :  \n- Mengonsumsi makanan rendah garam. \n- Mengonsumsi air putih lebih banyak untuk mencegah dehidrasi. \n- Meminta resep dokter untuk menurunkan produksi urin. \n\nUntuk penderita Diabetes Insipidus Dipsogenik : \n- Mengonsumsi permen untuk membantu meningkatkan produksi air liur, sehingga keinginan untuk minum bisa dikurangi. \n- Meminta resep obat desmopressin dengan dosis rendah pada dokter bagi penderita yang sering terbangun pada malam hari. \n\nUntuk penderita Diabetes Insipidus Gestasional : \n- Ditangani dengan obat desmopressin selama kehamilan. \n- Setelah melahirkan, biasanya kondisi akan membaik dengan sendirinya. \n",
                      image: "assets/images/Picture4.jpg",
                    ),
                  ],
                ),
                Divider(
                  height: 20,
                  thickness: 10,
                  indent: 35,
                  endIndent: 35,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Book(
                      title: "Null",
                      content: "null",
                      image: "",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class Book extends StatelessWidget {
  final String title;
  final String content;
  final String image;
  const Book(
      {super.key,
      required this.title,
      required this.content,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => PersistentNavBarNavigator.pushNewScreen(context,
          screen: ShowLibrary(
            title: title,
            content: content,
            image: image,
          )),
      child: Container(
        width: 150,
        height: 250,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Book.png"),
          ),
        ),
        child: Text(title),
      ),
    );
  }
}
