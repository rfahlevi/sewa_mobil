import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sewa_mobil/widgets/theme.dart';
import 'package:image_picker/image_picker.dart';

class TambahDataKendaraan extends StatefulWidget {
  const TambahDataKendaraan({super.key});

  @override
  State<TambahDataKendaraan> createState() => _TambahDataKendaraanState();
}

class _TambahDataKendaraanState extends State<TambahDataKendaraan> {
  final namaKendaraanC = TextEditingController();
  final nopolC = TextEditingController();
  final transmisiC = TextEditingController();
  final hargaSewaC = TextEditingController();

  CollectionReference dataKendaraan =
      FirebaseFirestore.instance.collection('kendaraan');

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
            Form(
              key: _key,
              child: Column(
                children: [
                  Text(
                    "Sewa Mobil. - Data Kendaraan - Tambah Data",
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
