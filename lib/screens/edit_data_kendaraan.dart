// ignore_for_file: must_be_immutable

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sewa_mobil/widgets/theme.dart';
import 'package:image_picker/image_picker.dart';

class EditDataKendaraan extends StatefulWidget {
  String namaKendaraan;
  EditDataKendaraan({
    super.key,
    required this.namaKendaraan,
  });

  @override
  State<EditDataKendaraan> createState() => _EditDataKendaraanState();
}

class _EditDataKendaraanState extends State<EditDataKendaraan> {
  final namaKendaraanC = TextEditingController();
  final nopolC = TextEditingController();
  final transmisiC = TextEditingController();
  final hargaSewaC = TextEditingController();

  CollectionReference dataKendaraan =
      FirebaseFirestore.instance.collection('kendaraan');
  final _kendaraanStream =
      FirebaseFirestore.instance.collection('kendaraan').snapshots();

  final GlobalKey<FormState> _key = GlobalKey();

  String imageUrl = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _kendaraanStream,
              builder: (context, snapshot) {
                try {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return SizedBox(
                      height: 200,
                      child: ListView(
                        children: snapshot.data!.docs.map((e) {
                          Map<String, dynamic> data =
                              e.data() as Map<String, dynamic>;

                          return Column(
                            children: [
                              Image(
                                image: NetworkImage(
                                  data['image'].toString(),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  }
                } catch (e) {
                  print(e);
                }
                return const CircularProgressIndicator();
              },
            ),
            Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sewa Mobil. - Data Kendaraan - Edit Data",
                    style: richBlackTextStyle,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      (imageUrl.isEmpty)
                          ? Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: prussianBlue.withOpacity(0.3),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  size: 50,
                                  color: greyColor.withOpacity(0.5),
                                ),
                              ),
                            )
                          : Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    imageUrl.toString(),
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: prussianBlue.withOpacity(0.3),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  size: 50,
                                  color: greyColor.withOpacity(0.5),
                                ),
                              ),
                            ),
                      const SizedBox(
                        width: 14,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: celadonBlue,
                        ),
                        onPressed: () async {
                          // Pick Image, import the corresponding library
                          ImagePicker imagePicker = ImagePicker();
                          final file = await imagePicker.pickImage(
                              source: ImageSource.gallery);

                          print('${file?.path}');

                          if (file == null) return;

                          String uniqueFileName =
                              DateTime.now().millisecondsSinceEpoch.toString();

                          // Upload to firebase store
                          // get  a reference storage
                          Reference referenceRoot =
                              FirebaseStorage.instance.ref();
                          Reference referenceDirImage =
                              referenceRoot.child('images');

                          Reference referenceImageToUpload =
                              referenceDirImage.child(uniqueFileName);

                          try {
                            // Store the file
                            await referenceImageToUpload
                                .putFile(File(file.path));
                            //Success : get download URL
                            imageUrl =
                                await referenceImageToUpload.getDownloadURL();

                            setState(() {});
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text(
                          "Tambah Gambar",
                          style: whiteTextStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  CustomTextField(
                    hintText: "Nama Kendaraan",
                    controller: namaKendaraanC,
                  ),
                  CustomTextField(
                    hintText: "Nomor Polisi",
                    controller: nopolC,
                  ),
                  CustomTextField(
                    hintText: "Transmisi",
                    controller: transmisiC,
                  ),
                  CustomTextField(
                    hintText: "Harga Sewa",
                    controller: hargaSewaC,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomElevatedButton(
                      label: "Tambah Data",
                      onTap: () {
                        if (_key.currentState!.validate()) {
                          String namaKendaraan = namaKendaraanC.text;
                          String nopol = nopolC.text;
                          String transmisi = transmisiC.text;
                          final hargaSewa = double.tryParse(hargaSewaC.text);

                          //Add data kendaraan
                          dataKendaraan
                              .add({
                                'image': imageUrl,
                                'nama_kendaraan': namaKendaraan,
                                'nopol': nopol,
                                'transmisi': transmisi,
                                'harga_sewa': hargaSewa,
                              })
                              .then(
                                (value) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: prussianBlue,
                                    content:
                                        const Text("Data Berhasil ditambahkan"),
                                    duration: const Duration(seconds: 3),
                                  ),
                                ),
                              )
                              .catchError((error) => print(error));
                        }

                        imageUrl = '';
                        namaKendaraanC.text = '';
                        nopolC.text = '';
                        transmisiC.text = '';
                        hargaSewaC.text = '';

                        setState(() {});
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
