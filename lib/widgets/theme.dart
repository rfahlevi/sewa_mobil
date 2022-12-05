import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sewa_mobil/screens/data_kendaraan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sewa_mobil/screens/signin.dart';

// Color
Color prussianBlue = const Color(0XFF003459);
Color celadonBlue = const Color(0XFF007EA7);
Color richBlack = const Color(0XFF00171F);
Color ceruleanCrayola = const Color(0XFF00A7E1);
Color whiteColor = const Color(0XFFFFFFFF);
Color greyColor = const Color(0XFF24272B);
Color redColor = const Color(0XFFCC2936);
Color borderColor = prussianBlue.withOpacity(0.4);
// FontWeight
FontWeight thin = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

// TextStyle
TextStyle prussianBlueTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: regular,
  color: prussianBlue,
);
TextStyle celadonBlueTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: regular,
  color: celadonBlue,
);
TextStyle richBlackTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: regular,
  color: richBlack,
);
TextStyle ceruleanCrayolaTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: regular,
  color: ceruleanCrayola,
);
TextStyle whiteTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: regular,
  color: whiteColor,
);
TextStyle greyTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: regular,
  color: greyColor,
);
TextStyle redTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: regular,
  color: redColor,
);

// Custom Text Field
class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      child: TextField(
        keyboardType: keyboardType,
        cursorHeight: 20,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: greyTextStyle.copyWith(
            height: 1,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: prussianBlue,
            ),
          ),
          filled: true,
          fillColor: whiteColor,
        ),
      ),
    );
  }
}

// Custom ElevatedButton
class CustomElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CustomElevatedButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => prussianBlue,
        ),
        minimumSize: MaterialStateProperty.resolveWith(
          (states) => Size(MediaQuery.of(context).size.width, 50),
        ),
      ),
      onPressed: onTap,
      child: Text(
        label,
        style: whiteTextStyle.copyWith(
          fontSize: 18,
        ),
      ),
    );
  }
}

// Drawer
class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isLogin = true;
  void toggle() => setState(
        () => isLogin = !isLogin,
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: prussianBlue),
            child: Center(
              child: Text(
                "Sewa Mobil",
                style: whiteTextStyle,
              ),
            ),
          ),
          ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.home_rounded,
                    color: richBlack,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Text(
                    "Beranda",
                    style: richBlackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/main_screen', (route) => false);
              }),
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.menu_open,
                  color: richBlack,
                  size: 30,
                ),
                const SizedBox(
                  width: 14,
                ),
                Text(
                  "Data User",
                  style: richBlackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/data_user', (route) => false);
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.car_rental,
                  color: richBlack,
                  size: 30,
                ),
                const SizedBox(
                  width: 14,
                ),
                Text(
                  "Data Kendaraan",
                  style: richBlackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const DataKendaraan();
                },
              ));
            },
          ),
          Divider(
            color: prussianBlue,
          ),
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: richBlack,
                  size: 30,
                ),
                const SizedBox(
                  width: 14,
                ),
                Text(
                  "Logout",
                  style: richBlackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
            onTap: () {
              signOut();
              // Navigator.of(context).pushReplacement(MaterialPageRoute(
              //   builder: (context) => const SignIn(),
              // ));
            },
          ),
        ],
      ),
    );
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignIn(),
          ));
    });
  }
}

// AppBar
PreferredSizeWidget customAppbar = AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  iconTheme: IconThemeData(
    color: prussianBlue,
  ),
  title: Text(
    "Sewa Mobil.",
    style: prussianBlueTextStyle.copyWith(
      fontWeight: semiBold,
      fontSize: 20,
    ),
  ),
  centerTitle: true,
);
