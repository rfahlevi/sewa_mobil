import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sewa_mobil/widgets/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    super.key,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final namaLengkapC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: celadonBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 20,
          ),
          child: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Row(
                        children: [
                          Text(
                            "Sewa Mobil.",
                            style: whiteTextStyle.copyWith(
                              fontSize: 28,
                              fontWeight: semiBold,
                            ),
                          ),
                          const SizedBox(
                            width: 14,
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 3,
                              height: 3,
                              color: whiteColor,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        "Selamat datang, silahkan buat akun",
                        style: whiteTextStyle.copyWith(
                          fontSize: 24,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomTextField(
                        hintText: 'Nama Lengkap',
                        controller: namaLengkapC,
                      ),
                      CustomTextField(
                        hintText: 'Email',
                        controller: emailC,
                      ),
                      CustomTextField(
                        hintText: 'Password',
                        controller: passwordC,
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      CustomElevatedButton(
                        label: "Buat Akun",
                        onTap: signUp,
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Sudah punya akun?",
                          style: whiteTextStyle,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamedAndRemoveUntil(
                              context, '/signin', (route) => false),
                          child: Text("Login",
                              style: whiteTextStyle.copyWith(
                                fontWeight: semiBold,
                                fontSize: 16,
                              )),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//SignUp Method
  Future signUp() async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailC.text, password: passwordC.text);

      print(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Email sudah terdaftar"),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (namaLengkapC.text.isEmpty ||
          emailC.text.isEmpty ||
          passwordC.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Semua field harus diisi"),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }

    addUser().then((value) => showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Center(
                child: Text("Akun berhasil dibuat!",
                    style: richBlackTextStyle.copyWith(
                      fontWeight: semiBold,
                    )),
              ),
              content: Text(
                "Anda otomatis login ke Aplikasi",
                style: richBlackTextStyle,
              ),
              actions: [
                CustomElevatedButton(
                  label: "Login",
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      '/main_screen', (route) => false),
                ),
              ],
            );
          },
        ));

    namaLengkapC.text = '';
    emailC.text = '';
    passwordC.text = '';
  }

// Add User Method
  Future<void> addUser() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      if (namaLengkapC.text.isEmpty ||
          emailC.text.isEmpty ||
          passwordC.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Semua field harus diisi"),
            duration: Duration(seconds: 3),
          ),
        );

        setState(() {});
      } else {
        return await users
            .add({
              'nama_lengkap': namaLengkapC.text,
              'email': emailC.text,
              'password': passwordC.text,
            })
            .then((value) => print("user berhasil ditambahkan"))
            .catchError((error) => print("Gagal menambahkan user: $error"));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
