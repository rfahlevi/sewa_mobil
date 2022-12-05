// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sewa_mobil/screens/booking.dart';
import 'package:sewa_mobil/widgets/theme.dart';
import 'package:skeletons/skeletons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  CollectionReference kendaraan =
      FirebaseFirestore.instance.collection('kendaraan');
  final _kendaraanStream = FirebaseFirestore.instance
      .collection('kendaraan')
      .orderBy('harga_sewa')
      .snapshots();
  final docKendaraanSnaphot =
      FirebaseFirestore.instance.collection('kendaraan').doc('uid').get();

  TextEditingController lamaSewaC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: customAppbar,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              "Sewa Mobil. - Beranda",
              style: richBlackTextStyle,
            ),
            const SizedBox(
              height: 14,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _kendaraanStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SkeletonTheme(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.43,
                        height: 200,
                        child: Column(
                          children: [
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Data sedang bermasalah",
                      style: richBlackTextStyle,
                    ));
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ListView(
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runSpacing: 14,
                            children: snapshot.data!.docs.map((e) {
                              Map<String, dynamic> data =
                                  e.data()! as Map<String, dynamic>;

                              return GestureDetector(
                                onTap: () async {
                                  await kendaraan.doc(e.id).get();
                                  try {
                                    if (snapshot.hasData) {
                                      return showModalBottomSheet(
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        )),
                                        builder: (context) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 14),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Konfirmasi Booking",
                                                      style:
                                                          prussianBlueTextStyle
                                                              .copyWith(
                                                        fontSize: 20,
                                                        fontWeight: semiBold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Nama Kendaraan",
                                                      style: richBlackTextStyle
                                                          .copyWith(
                                                        fontSize: 16,
                                                        fontWeight: medium,
                                                      ),
                                                    ),
                                                    Text(
                                                      data['nama_kendaraan'],
                                                      style: richBlackTextStyle
                                                          .copyWith(
                                                        fontSize: 16,
                                                        fontWeight: medium,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 7,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Nomor Polisi",
                                                      style: richBlackTextStyle
                                                          .copyWith(
                                                        fontSize: 16,
                                                        fontWeight: medium,
                                                      ),
                                                    ),
                                                    Text(
                                                      data['nopol'],
                                                      style: richBlackTextStyle
                                                          .copyWith(
                                                        fontSize: 16,
                                                        fontWeight: medium,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 7,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Transmisi",
                                                      style: richBlackTextStyle
                                                          .copyWith(
                                                        fontSize: 16,
                                                        fontWeight: medium,
                                                      ),
                                                    ),
                                                    Text(
                                                      data['transmisi'],
                                                      style: richBlackTextStyle
                                                          .copyWith(
                                                        fontSize: 16,
                                                        fontWeight: medium,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                                Divider(
                                                  height: 1,
                                                  thickness: 1,
                                                  color: prussianBlue,
                                                ),
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Lama Sewa (Hari)",
                                                      style: richBlackTextStyle
                                                          .copyWith(
                                                        fontSize: 16,
                                                        fontWeight: medium,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child: CustomTextField(
                                                        hintText: '0',
                                                        controller: lamaSewaC,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Harga Sewa (Hari)",
                                                      style: richBlackTextStyle
                                                          .copyWith(
                                                        fontSize: 16,
                                                        fontWeight: medium,
                                                      ),
                                                    ),
                                                    Text(
                                                      NumberFormat.currency(
                                                              locale: 'id')
                                                          .format(
                                                        data['harga_sewa'],
                                                      ),
                                                      style:
                                                          redTextStyle.copyWith(
                                                        fontSize: 16,
                                                        fontWeight: semiBold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 40,
                                                ),
                                                CustomElevatedButton(
                                                  label: "Booking",
                                                  onTap: () {
                                                    final namaKendaraan =
                                                        data['nama_kendaraan']
                                                            .toString();
                                                    final nopolKendaraan =
                                                        data['nopol']
                                                            .toString();
                                                    double hargaSewa =
                                                        data['harga_sewa'];
                                                    final lamaSewa =
                                                        double.tryParse(
                                                            lamaSewaC.text);
                                                    try {
                                                      if (lamaSewaC
                                                          .text.isEmpty) {
                                                        showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (context) {
                                                            return Center(
                                                              child:
                                                                  AlertDialog(
                                                                content: Text(
                                                                  "Lama Sewa harus diisi!",
                                                                  style: richBlackTextStyle
                                                                      .copyWith(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        medium,
                                                                  ),
                                                                ),
                                                                actions: [
                                                                  CustomElevatedButton(
                                                                    label:
                                                                        'Oke',
                                                                    onTap: () =>
                                                                        Navigator.of(context)
                                                                            .pop(),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                        setState(() {});
                                                      } else {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Booking(
                                                                namaKendaraan:
                                                                    namaKendaraan,
                                                                nopolKendaraan:
                                                                    nopolKendaraan,
                                                                hargaSewa:
                                                                    hargaSewa,
                                                                lamaSewa:
                                                                    lamaSewa!,
                                                              ),
                                                            ));

                                                        setState(() {
                                                          lamaSewaC.text = "";
                                                        });
                                                      }
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                  },
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.43,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: prussianBlue.withOpacity(0.1),
                                        blurRadius: 4,
                                        spreadRadius: 2,
                                        offset: const Offset(2, 4),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: borderColor,
                                    ),
                                    color: whiteColor,
                                  ),
                                  child: Column(
                                    children: [
                                      Image(
                                        image: NetworkImage(data['image']),
                                        height: 90,
                                      ),
                                      Text(
                                        data['nama_kendaraan'],
                                        style: richBlackTextStyle.copyWith(
                                          fontWeight: semiBold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        data['nopol'],
                                        style: richBlackTextStyle,
                                      ),
                                      Text(
                                        data['transmisi'],
                                        style: richBlackTextStyle,
                                      ),
                                      Text(
                                        NumberFormat.currency(
                                          locale: 'id',
                                        ).format(
                                          data['harga_sewa'],
                                        ),
                                        style: redTextStyle.copyWith(
                                          fontWeight: semiBold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
