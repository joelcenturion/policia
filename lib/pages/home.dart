import 'package:flutter/material.dart';
import 'package:ministerio/main.dart';
import 'package:ministerio/services/person_data.dart';
// import 'package:app/main.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  // const ({ Key? key }) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //controller para obtener el nro de cédula del textfiel
  final myController = TextEditingController();
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  // Color claroColor = Color(0xffDA291C);
  Color claroColor = (Colors.indigo[800])!;
  @override
  void initState() {
    super.initState();
    Global.pages = 0;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.indigo[700], // status bar color
    ));
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all(25),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.3, -0.3),
              end: Alignment.bottomRight,
              // colors: <Color>[Color(0xff0072b0), Color(0xFF1f1d1d)],
              colors: <Color>[Color(0xff006be6), Color(0xFF21232e)],
            ),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'assets/policia.png',
                      height: 120,
                      width: 320,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 25),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => showInputDialog(context).then((ciValue) {
                        myController.text = ''; //Limpiar textfield
                        ciValue = ciValue.replaceAll(' ', ''); //Remove white spaces
                        RegExp regexp =
                        RegExp(r'^[0-9]*$'); //Para validación de sólo números
                        if (!regexp.hasMatch(ciValue)) {
                          showAlert();
                        } else if (ciValue != false && ciValue != '') {
                          Global.ci = ciValue;
                          Navigator.pushNamed(context, '/loading');
                        }
                      }),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(50, 18, 50, 18),
                        child: Text(
                          'INGRESAR CÉDULA ',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff0563fa),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  // Expanded(child: SizedBox()),
                ],
              ),
              // Expanded(SizedBox()),
              Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'TSV S.R.L.  ',
                      style: TextStyle(
                        color: Colors.white70
                      ),
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/tsv.jpeg'),
                      maxRadius: 13,
                    )
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }

  Future<dynamic> showInputDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Ingrese Nro. de Cédula'),
            content: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'Ingrese Cédula',
                contentPadding: EdgeInsets.only(left: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              controller: myController,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: claroColor,
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    return Navigator.pop(context, myController.text.toString());
                  },
                  child: Text(
                    'Aceptar',
                    style: TextStyle(
                      color: claroColor,
                    ),
                  ))
            ],
          );
        });
  }

// MOSTRAR ALERT DIALOG CUANDO SE INGRESAN MAL LOS DATOS
  showAlert() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          Timer(Duration(milliseconds: 700), () {
            Navigator.pop(context);
          });
          return AlertDialog(
            title: Center(child: Text('Ingrese sólo números')),
          );
        });
  }
}
