import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sewa_mobil/screens/main_screen.dart';
import 'package:sewa_mobil/widgets/theme.dart';

class SignIn extends StatefulWidget {
  // final VoidCallback onClickedSignUp;
  const SignIn({
    super.key,
    // required this.onClickedSignUp,
  });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();

    super.dispose();
  }

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
                      "Selamat datang, silahkan masuk",
                      style: whiteTextStyle.copyWith(
                        fontSize: 24,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
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
                    Text(
                      "Lupa Password?",
                      style: whiteTextStyle,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomElevatedButton(
                      label: "Masuk",
                      onTap: signIn,
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
                        "Belum punya akun?",
                        style: whiteTextStyle,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamedAndRemoveUntil(
                            context, '/signup', (route) => false),
                        child: Text("Buat Akun",
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
    );
  }

//Login Method
  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailC.text,
        password: passwordC.text,
      );
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Berhasil",
              style: richBlackTextStyle.copyWith(
                fontWeight: semiBold,
                fontSize: 16,
              ),
            ),
            content: Text(
              "Silahkan klik OK untuk melanjutkan",
              style: richBlackTextStyle.copyWith(
                fontWeight: medium,
              ),
            ),
            actions: [
              CustomElevatedButton(
                  label: "OK",
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        return const MainScreen();
                      },
                    ));
                  }),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: redColor,
            content: const Text("Email atau Password salah!"),
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (emailC.text.isEmpty || passwordC.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: redColor,
            content: const Text("Email atau Password tidak boleh kosong!"),
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: redColor,
            content: const Text("Email atau Password salah!"),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
