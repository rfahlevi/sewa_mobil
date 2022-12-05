import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sewa_mobil/main.dart';
import 'package:sewa_mobil/screens/edit_data_kendaraan.dart';
import 'package:sewa_mobil/screens/tambah_data_kendaraan.dart';
import 'package:sewa_mobil/widgets/theme.dart';
import 'package:skeletons/skeletons.dart';

class DataKendaraan extends StatefulWidget {
  const DataKendaraan({super.key});

  @override
  State<DataKendaraan> createState() => _DataKendaraanState();
}

class _DataKendaraanState extends State<DataKendaraan> {
  CollectionReference dataKendaraan =
      FirebaseFirestore.instance.collection('kendaraan');
  final _kendaraanStream =
      FirebaseFirestore.instance.collection('kendaraan').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar,
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              "Sewa Mobil. - Data Kendaraan",
              style: richBlackTextStyle,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 40),
                backgroundColor: celadonBlue,
              ),
              child: Text(
                "Tambah Data",
                style: whiteTextStyle.copyWith(
                  fontWeight: medium,
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const TambahDataKendaraan();
                  },
                ));
              },
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 70,
                  decoration: BoxDecoration(
                      color: prussianBlue,
                      border: Border.all(
                        color: greyColor.withOpacity(0.5),
                      )),
                  child: Center(
                    child: Text(
                      "No",
                      style: whiteTextStyle,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 70,
                  decoration: BoxDecoration(
                      color: prussianBlue,
                      border: Border.all(
                        color: greyColor.withOpacity(0.5),
                      )),
                  child: Center(
                    child: Text(
                      "Unit",
                      style: whiteTextStyle,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 70,
                  decoration: BoxDecoration(
                      color: prussianBlue,
                      border: Border.all(
                        color: greyColor.withOpacity(0.5),
                      )),
                  child: Center(
                    child: Text(
                      "Nomor Polisi",
                      style: whiteTextStyle,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 70,
                  decoration: BoxDecoration(
                      color: prussianBlue,
                      border: Border.all(
                        color: greyColor.withOpacity(0.5),
                      )),
                  child: Center(
                    child: Text(
                      "Transmisi",
                      style: whiteTextStyle,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 70,
                  decoration: BoxDecoration(
                      color: prussianBlue,
                      border: Border.all(
                        color: greyColor.withOpacity(0.5),
                      )),
                  child: Center(
                    child: Text(
                      "Aksi",
                      style: whiteTextStyle,
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder(
              stream: _kendaraanStream,
              builder: (context, snapshot) {
                try {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SkeletonListTile();
                  } else if (snapshot.hasError) {
                    return Text(
                      "Data sedang bermasalah",
                      style: richBlackTextStyle,
                    );
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((e) {
                        Map<String, dynamic> data =
                            e.data() as Map<String, dynamic>;

                        return Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      border: Border.all(
                                        color: greyColor.withOpacity(0.5),
                                      )),
                                  child: Center(
                                    child: Text(
                                      "1",
                                      style: richBlackTextStyle,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      border: Border.all(
                                        color: greyColor.withOpacity(0.5),
                                      )),
                                  child: Center(
                                    child: Text(
                                      data['nama_kendaraan'],
                                      style: richBlackTextStyle,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      border: Border.all(
                                        color: greyColor.withOpacity(0.5),
                                      )),
                                  child: Center(
                                    child: Text(
                                      data['nopol'],
                                      style: richBlackTextStyle,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      border: Border.all(
                                        color: greyColor.withOpacity(0.5),
                                      )),
                                  child: Center(
                                    child: Text(
                                      data['transmisi'],
                                      style: richBlackTextStyle,
                                    ),
                                  ),
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        color: whiteColor,
                                        border: Border.all(
                                          color: greyColor.withOpacity(0.5),
                                        )),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            DocumentSnapshot dataKendaraan =
                                                await FirebaseFirestore.instance
                                                    .collection('kendaraan')
                                                    .doc(e.id)
                                                    .get();
                                            try {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                const CircularProgressIndicator();
                                              } else if (snapshot.hasData) {}
                                              await Navigator.of(context)
                                                  .pushNamed(
                                                      '/edit_data_kendaraan');
                                            } catch (e) {
                                              print(e);
                                            }
                                            final imageUrl =
                                                dataKendaraan['image']
                                                    .toString();
                                            final namaKendaraan =
                                                data['nama_kendaraan']
                                                    .toString();
                                            final nopol =
                                                data['nopol'].toString();
                                            final transmisi =
                                                data['transmisi'].toString();
                                            final hargaSewa =
                                                data['harga_sewa'].toString();
                                          },
                                          child: const Icon(Icons.edit),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Text(
                                                    "Ingin menghapus data?",
                                                    style: richBlackTextStyle,
                                                  ),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        ElevatedButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .resolveWith(
                                                                        (states) =>
                                                                            prussianBlue),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            "Tidak",
                                                            style:
                                                                whiteTextStyle,
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .resolveWith(
                                                              (states) =>
                                                                  whiteColor,
                                                            ),
                                                            side:
                                                                MaterialStateProperty
                                                                    .resolveWith(
                                                              (states) =>
                                                                  BorderSide(
                                                                color:
                                                                    borderColor,
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            dataKendaraan
                                                                .doc(e.id)
                                                                .delete();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            "Ya",
                                                            style:
                                                                prussianBlueTextStyle,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: const Icon(Icons.delete),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  }
                } catch (e) {
                  print(e);
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
