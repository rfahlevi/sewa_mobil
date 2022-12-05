// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sewa_mobil/widgets/theme.dart';
import 'package:dotted_line/dotted_line.dart';
import 'dart:math' show Random;

class Booking extends StatelessWidget {
  String namaKendaraan;
  String nopolKendaraan;
  double hargaSewa;
  double lamaSewa;

  int kodeBooking = Random().nextInt(100000) + 99999;

  Booking({
    super.key,
    required this.namaKendaraan,
    required this.nopolKendaraan,
    required this.hargaSewa,
    required this.lamaSewa,
  });

  CollectionReference booking =
      FirebaseFirestore.instance.collection('booking');
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  final _userStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  final docUser =
      FirebaseFirestore.instance.collection('users').doc('uid').get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Data Booking",
                  style: prussianBlueTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: semiBold,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            DottedLine(
              lineThickness: 1.5,
              dashColor: prussianBlue,
            ),
            const SizedBox(
              height: 14,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _userStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(
                    color: prussianBlue,
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    "Data sedang bermasalah",
                    style: richBlackTextStyle,
                  );
                } else {
                  return Column(
                      children: snapshot.data!.docs.map((e) {
                    Map<String, dynamic> data =
                        e.data()! as Map<String, dynamic>;

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Nama Pemesan",
                              style: richBlackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              data['nama_lengkap'],
                              style: richBlackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Email",
                              style: richBlackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              data['email'],
                              style: richBlackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Kendaraan",
                              style: richBlackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              namaKendaraan,
                              style: richBlackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Nomor Polisi",
                              style: richBlackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              nopolKendaraan,
                              style: richBlackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Lama Sewa",
                              style: richBlackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${lamaSewa.toStringAsFixed(0)} Hari",
                              style: redTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: semiBold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Harga (Per Hari)",
                              style: richBlackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                locale: 'id',
                              ).format(hargaSewa),
                              // 'Rp. ${hargaSewa.toStringAsFixed(0)} ,-',
                              style: redTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: semiBold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Biaya",
                              style: richBlackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(locale: 'id')
                                  .format(hargaSewa * lamaSewa),
                              style: redTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: semiBold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }).toList());
                }
              },
            ),
            const SizedBox(
              height: 24,
            ),
            DottedLine(
              lineThickness: 1.5,
              dashColor: prussianBlue,
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Kode Booking",
                  style: richBlackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
                Text(
                  kodeBooking.toString(),
                  style: prussianBlueTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            DottedLine(
              lineThickness: 1.5,
              dashColor: prussianBlue,
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "* Harap screenshot bukti pemesanan untuk ditunjukkan ke admin sewa mobil.",
                    style: richBlackTextStyle.copyWith(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => whiteColor,
                ),
                side: MaterialStateProperty.resolveWith((states) => BorderSide(
                      color: prussianBlue,
                    )),
                minimumSize: MaterialStateProperty.resolveWith(
                  (states) => Size(MediaQuery.of(context).size.width, 50),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Pemberitahuan",
                        textAlign: TextAlign.center,
                        style: richBlackTextStyle.copyWith(
                          fontWeight: semiBold,
                          fontSize: 18,
                        ),
                      ),
                      content: Text(
                        "Screenshot bukti pemesanan untuk ditunjukkan ke admin Sewa Mobil.",
                        style: richBlackTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        CustomElevatedButton(
                          label: 'Oke',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                "Bayar di Tempat",
                style: prussianBlueTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: medium,
                ),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            CustomElevatedButton(
              label: 'Bayar via Transfer',
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 40,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Image(
                                image: AssetImage('assets/bank_bca.png'),
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                "9788767899",
                                style: richBlackTextStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: medium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Image(
                                image: AssetImage('assets/bank_mandiri.png'),
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                "1221887615162",
                                style: richBlackTextStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: medium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
