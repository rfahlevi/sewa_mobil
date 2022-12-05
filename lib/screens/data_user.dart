import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sewa_mobil/widgets/theme.dart';
import 'package:skeletons/skeletons.dart';

class DataUser extends StatefulWidget {
  const DataUser({super.key});

  @override
  State<DataUser> createState() => _DataUserState();
}

class _DataUserState extends State<DataUser> {
  final authUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final _userStream =
      FirebaseFirestore.instance.collection('users').snapshots();

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
              "Sewa Mobil. - Data User",
              style: richBlackTextStyle,
            ),
            const SizedBox(
              height: 40,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: 50,
                      decoration: BoxDecoration(
                        color: prussianBlue,
                      ),
                      child: Center(
                        child: Text(
                          "No",
                          style: whiteTextStyle,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 50,
                      decoration: BoxDecoration(
                        color: prussianBlue,
                      ),
                      child: Center(
                        child: Text(
                          "Nama Lengkap",
                          style: whiteTextStyle,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 50,
                      decoration: BoxDecoration(
                        color: prussianBlue,
                      ),
                      child: Center(
                        child: Text(
                          "Email",
                          style: whiteTextStyle,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: 50,
                      decoration: BoxDecoration(
                        color: prussianBlue,
                      ),
                      child: Center(
                        child: Text(
                          "Aksi",
                          style: whiteTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _userStream,
                    builder: (context, snapshot) {
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
                                  e.data()! as Map<String, dynamic>;

                              return Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: greyColor.withOpacity(0.5))),
                                    child: Center(
                                      child: Text(
                                        "1",
                                        style: richBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: greyColor.withOpacity(0.5))),
                                    child: Center(
                                      child: Text(
                                        data['nama_lengkap'],
                                        style: richBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: greyColor.withOpacity(0.5))),
                                    child: Center(
                                      child: Text(
                                        data['email'],
                                        style: richBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  greyColor.withOpacity(0.5))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: Text(
                                                        "Ingin menghapus data user?",
                                                        style:
                                                            richBlackTextStyle,
                                                      ),
                                                      actions: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.resolveWith(
                                                                        (states) =>
                                                                            prussianBlue),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(true);
                                                              },
                                                              child: const Text(
                                                                  "Batal"),
                                                            ),
                                                            OutlinedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                side: MaterialStateProperty
                                                                    .resolveWith(
                                                                  (states) =>
                                                                      BorderSide(
                                                                    color:
                                                                        prussianBlue,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                users
                                                                    .doc(e.id)
                                                                    .delete()
                                                                    .then((value) =>
                                                                        authUser!
                                                                            .delete());
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
                                              child: Icon(
                                                Icons.delete,
                                                color: richBlack,
                                              )),
                                        ],
                                      )),
                                ],
                              );
                            }).toList());
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
