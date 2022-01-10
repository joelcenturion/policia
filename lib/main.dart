import 'package:ministerio/pages/camera.dart';
import 'package:ministerio/services/scanner.dart';
import 'package:flutter/material.dart';
import 'package:ministerio/pages/home.dart';
import 'package:ministerio/pages/person.dart';
import 'package:ministerio/pages/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ministerio/pages/login.dart';

void main() {
  runApp(MaterialApp(
    // theme: ThemeData(primaryColor: Colors.red),
    initialRoute: '/login',
    routes: {
      '/home': (context) => Home(),
      '/person': (context) => Person(),
      '/loading': (context) => Loading(),
      '/camera': (context) => Camera(),
      '/login': (context) => Signin2Page(),
      '/scanner': (context) => Scanner()
    },
  ));
}

//Mi appBar personalizado
Widget myAppBar() {
  return MyAppBar();
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);
  @override
  Size get preferredSize => Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Control de Circulación',
            style: TextStyle(fontSize: 19),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              'assets/escudo.jpg',
              height: 45,
              width: 45,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.indigo[800],
    );
  }
}
