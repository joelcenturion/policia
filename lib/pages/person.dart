import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ministerio/main.dart';
import 'package:ministerio/services/icons.dart';
import 'package:mrzflutterplugin/mrzflutterplugin.dart';
import 'dart:io' show Platform;
import 'dart:convert';
import 'package:ministerio/services/person_data.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Person extends StatefulWidget {
  // const ({ Key? key }) : super(key: key);
  @override
  _PersonState createState() => _PersonState();
}

class _PersonState extends State<Person> {
  int selectedIndex = 0;
  void onItemTapped(int index) async {
    setState(() {
      selectedIndex = index;
    });
    if (index == 0) {
      // Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      if(Global.pages > 1){
        Navigator.pop(context);
        Navigator.pop(context);
      }else{
        Navigator.pop(context);
      }

    } else if (index == 1) {
      Global.pages++;
      print('Global.pages: ${Global.pages}, index1');
      if (Global.pages > 2) {
        Global.pages--;
        Navigator.pushReplacementNamed(context, '/camera');
      } else {
        Navigator.pushNamed(context, '/camera');
      }
    } else if (index == 2) {
      // startScanning();
      // dynamic result = await Navigator.pushNamed(context, '/scanner');
      // print('////////////////result/////////////////////////////////////');
      // print(result.documentNumber);
      // print('result: ');
      // print(result.sex);
      // if (result != null) {
      //   setState(() {
      //     validationHidden = false;
      //     validationString = result.documentNumber;
      //   });
      //   if (result.documentNumber == Global.ci) {
      //     validationString = 'Validación Positiva';
      //   } else {
      //     validationString = 'Validación Negativa';
      //   }
      // }
    }
  }

  /*Parte MRZ SCANNER*/
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      Mrzflutterplugin.registerWithLicenceKey(
          "F79CD0A43780F6722114469AB6551D4E854CA8CDE5A13B7030835B59E0F2426AEAFB378423AD7F013B00F795E8103507");
      //F79CD0A43780F6722114469AB6551D4E854CA8CDE5A13B7030835B59E0F2426AEAFB378423AD7F013B00F795E8103507
    } else if (Platform.isIOS) {
      Mrzflutterplugin.registerWithLicenceKey("ios_licence_key");
    }
  }

  Color? _colorValidation;
  IconData? _iconValidation;
  bool validationHidden = true;
  String? validationString;
  bool scanningFail = false;
  // Platform messages are asynchronous, so we initialize in an async method.

  Future<void> startScanning() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      Mrzflutterplugin.setIDActive(true);
      Mrzflutterplugin.setPassportActive(true);
      Mrzflutterplugin.setVisaActive(true);
      Mrzflutterplugin.setVibrateOnSuccessfulScan(true);

      String jsonResultString = await Mrzflutterplugin.startScanner;

      Map<String, dynamic> jsonResult = jsonDecode(jsonResultString);
      // fullImage = jsonResult['full_image'];
      if (jsonResult['document_number'] == Global.ci) {
        validationString = 'Validación Positiva';
      } else {
        validationString = 'Validación Negativa';
      }
    } on PlatformException catch (ex) {
      String? message = ex.message;
      print('scannerResult = Scanning failed: $message');
      scanningFail = true;
    }

    if (!mounted) return;
    setState(() {
      if (!scanningFail) {
        validationHidden = false;
      }
    });
  }

  // Variables para elegir iconos y colores apropiados
  Color? _iconDosisColor;
  IconData? _iconDosis;

  //El titulo RECO FACIAL está oculto antes de hacer el reconocimiento facial
  late bool titleIsHidden;
  // Color claroColor = const Color(0xffD.A291C);
  Color claroColor = (Colors.indigo.shade800);
  //Color de cuadro sobre foto de ci
  Color? _color;
  IconData? _icon;

  // height y widht de Foto de cédula
  late double height;
  late double widht;

  //Obtener datos de la persona desde loading.dart
  Map person = {};
  initialize(){
    person = ModalRoute.of(context)!.settings.arguments as Map;
    //Tamaño para la foto de ci y para la foto de reco facial
    height = person['height'];
    widht = person['widht'];
    //Según resultado de la verificación facial, se eligen el icono y el color
    //para el mensaje que está sobre la foto de ci
    if (person['message'] == 'RECO FACIAL NEGATIVO') {
      _color = Colors.red;
      _icon = Icons.close;
      titleIsHidden = false;
    } else if (person['message'] == 'RECO FACIAL POSITIVO') {
      _color = Colors.green[400];
      _icon = Icons.offline_pin_outlined;
      titleIsHidden = false;
    } else {
      titleIsHidden = true;
      _color = Colors.green[400];
      _icon = Icons.offline_pin_outlined;
    }

    if (validationString == 'Validación Positiva') {
      _colorValidation = Colors.green[400];
      _iconValidation = Icons.offline_pin_outlined;
    } else {
      _colorValidation = Colors.red;
      _iconValidation = Icons.close;
    }

    if (person['dosage'] == '1RA.') {
      _iconDosis = Icons.warning_rounded;
      _iconDosisColor = Colors.orange[600];
    } else if (person['dosage'] == '2DA.' || person['dosage'] == '3RA.') {
      _iconDosis = Icons.offline_pin_outlined;
      _iconDosisColor = Colors.green[400];
    } else {
      _iconDosis = Icons.highlight_off_rounded;
      // _iconDosis = Icons.dangerous_rounded;
      _iconDosisColor = Colors.red[600];
    }
    print('titleIsHidden: $titleIsHidden');

    // Future.delayed(Duration(seconds: 1), () {
    //   if (Global.noFaces) {
    //     showAlert('No se encontraron Rostros');
    //     Global.noFaces = false;
    //   }
    // });
  }
  @override
  Widget build(BuildContext context) {
    initialize();
    return WillPopScope(
      onWillPop: () async {
        Global.pages--;
        print('Global.pages: ${Global.pages}, onWillPop');
        return true;
      },
      child: Scaffold(
        appBar: MyAppBar(),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.3, -0.3),
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xff0072b0), Color(0xFF1f1d1d)],
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'VERIFICACIÓN DE PERSONAS',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold,),
                      ),
                    ),
                  ],
                ),
                //MENSAJE SOBRE LA FOTO DE CI. RECOFACIAL
                !titleIsHidden
                    ? Container(
                        margin: EdgeInsets.only(bottom: 5),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: _color,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _icon,
                              color: Colors.white,
                            ),
                            Text(
                              '   ${person['message']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),

                !validationHidden
                    ? Container(
                        margin: EdgeInsets.only(bottom: 5),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: _colorValidation,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _iconValidation,
                              color: Colors.white,
                            ),
                            Text(
                              '   $validationString'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),

                //FOTO DE LA PERSONA
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  height: height,
                  width: widht,
                  margin: EdgeInsets.only(bottom: 10, top: 3),
                  child: Image.memory(
                    person['photoBytes'],
                    fit: BoxFit.cover,
                    //EN CASO DE QUE NO SE PUEDA CARGAR LA IMAGEN
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset(
                        'assets/empty_photo.jpg',
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                ),

                //DATOS
                Flexible(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Divider(
                        height: 5,
                        thickness: 2,
                        color: Colors.green
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 3),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'DATOS PERSONALES',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    'C.I.: ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  Text(
                                    '${person['ci']}',
                                    style: TextStyle(color: Colors.grey.shade300),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    'NOMBRE: ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        '${person['first_name']}'.toUpperCase(),
                                        style:
                                            TextStyle(color: Colors.grey.shade300),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    'APELLIDO: ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        '${person['last_name']}'.toUpperCase(),
                                        style:
                                            TextStyle(color: Colors.grey.shade300),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    'FECHA DE NACIMIENTO: ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  Text(
                                    '${person['born_date']}',
                                    style: TextStyle(color: Colors.grey.shade300),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    'DESCRIPCIÓN: ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  Text(
                                    '${person['descripcion']}',
                                    style: TextStyle(color: Colors.grey.shade300),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 5,
                        thickness: 2,
                          color: Colors.green
                      ),
                      //4to. elemento de la columna principal. Datos de Vacunación
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 3),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'DATOS DE VACUNACIÓN',
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    'VACUNA: ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        '${person['vaccine']}'.toUpperCase(),
                                        style:
                                            TextStyle(color: Colors.grey.shade300),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    'DOSIS APLICADA: ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  Text(
                                    '${person['dosage']}  ',
                                    style: TextStyle(color: Colors.grey.shade300),
                                  ),
                                  Icon(
                                    _iconDosis,
                                    color: _iconDosisColor,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    'FECHA DE APLICACIÓN: ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  Text(
                                    '${person['vaccine_date']}',
                                    style: TextStyle(color: Colors.grey.shade300),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 12,
          elevation: 3.0,
          type: BottomNavigationBarType.fixed,
          // iconSize: 20,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: Colors.indigo,
              ),
              label: 'INICIO',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  MyIcon.face1,
                  color: Colors.indigo,
                ),
                label: 'VERIFICACION'),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.document_scanner_outlined,
            //     color: Colors.indigo,
            //   ),
            //   label: 'Validación',
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.comment_outlined,
            //     color: Colors.indigo,
            //   ),
            //   label: 'Comentarios',
            // )
          ],
          currentIndex: selectedIndex,
          // selectedItemColor: Colors.white,
          fixedColor: Colors.black,
          onTap: onItemTapped,
        ),
      ),
    );
  }

  showAlert(String alert) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(milliseconds: 900), () {
            Navigator.pop(context);
          });
          // var screen = MediaQuery.of(context).size;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AlertDialog(
                // backgroundColor: Colors.orange[900],
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: Colors.orange[900],
                    ),
                    Text(
                      '   $alert',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                titlePadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ],
          );
        });
  }
}
