// import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ministerio/services/person_data.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
import 'package:image/image.dart' as img;
import 'package:fluttertoast/fluttertoast.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  //En caso de que haya algún error con openface ó landmark
  bool timeout = false;
  bool error = false;
  Map data = {
    'image2.jpg': {'image1.jpg': 5}
  };
  Future<void> faceRecognition() async {
    Global.photoBytes = convert.base64Decode(Global.cameraBase64);
    String username = 'admin';
    String password = '1-bypersoft.';
    String basicAuth = 'Basic ' + convert.base64Encode(convert.utf8.encode('$username:$password'));
    try {
      String url = 'http://control.bypar.com.py:8000/';
      http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': basicAuth,
        },
        body: convert.jsonEncode(<String, String>{
          'image1': Global.ciBase64,
          'image2': Global.cameraBase64,
        }),
      ).timeout(
        const Duration(seconds: 90),
        onTimeout: (){
          return http.Response('Timeout', 408);
        }
      );
      print('STATUS CODE ${response.statusCode}');
      if (response.statusCode == 200) {
        Map dataTemp = convert.jsonDecode(response.body);
        print('dataTemp');
        print(dataTemp);
        if (!(dataTemp['image2.jpg']).isEmpty) {
          // if (dataTemp['image2.jpg']['image1.jpg'] != 5) {
          data = dataTemp;
          print('Data: $data');
          // }
        } else {
          print('NO FACES.........');
          error = true;
          Global.noFaces = true;
        }
      }else if(response.statusCode == 408){
        print('STATUS CODE2 ${response.statusCode}');
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "No se pudo conectar con el servidor. Verifique su conexión a internet",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        timeout = true;
      }
      else {
        error = true;
      }
    } catch (e) {
      print('ERROR FACE RECOGNITION');
      print('Error: $e');
      error = true;
    }

    if (!error) {
      print('Landmark detection starting...........');
      Uint8List landmark_data;
      try {
        String url = 'http://control.bypar.com.py:8001/';
        http.Response response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': basicAuth,
          },
          body: convert.jsonEncode(<String, String>{
            'image': Global.cameraBase64,
          }),
        ).timeout(
          Duration(seconds: 90),
          onTimeout: (){
            return http.Response('Timeout', 408);
          }
        );
        if (response.statusCode == 200) {
          landmark_data =
              convert.base64Decode(convert.jsonDecode(response.body));
          Global.photoBytes = landmark_data;
        }else if(response.statusCode == 408){
          Fluttertoast.showToast(
              msg: "No se pudo conectar con el servidor. Verifique su conexión a internet",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
          Navigator.pop(context);
          timeout=true;
        }
      } catch (e) {
        print('ERROR LANDMARK');
      }
    }
  }

  void doFaceRecognition() async {
    await faceRecognition();

    if(!timeout) {
      if (data['image2.jpg']['image1.jpg'] <= 1) {
        Global.message = 'RECO FACIAL POSITIVO';
      } else {
        Global.message = 'RECO FACIAL NEGATIVO';
      }

      Navigator.pushReplacementNamed(context, '/person', arguments: {
        'message': Global.message,
        'name': Global.name,
        'ci': Global.ci,
        'born_date': Global.bornDate,
        'dosage': Global.dosage,
        'vaccine': Global.vaccine,
        'photoBytes': Global.photoBytes,
        'height': 210.0,
        'widht': 157.5,
        'first_name': Global.first_name,
        'last_name': Global.last_name,
        'vaccine_date': Global.vaccine_date,
        'descripcion': Global.descripcion,
      });
    }else{
      Global.pages--;
      print('Global.pagesdo: ${Global.pages}');
    }
  }

  File? image;
  Uint8List? displayImage;

  Future pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 200,
        maxWidth: 200,
        imageQuality: 100
      );
      if (image == null) {
        Global.pages--;
        Navigator.pop(context);
        return;
      }

      print('displayImage = await image.readAsBytes()');

      File imageTemporary = File(image.path);

      this.image = imageTemporary;
      print('this.image = imageTemporary;');

    } on PlatformException catch (e) {
      print('Error al cargar imagen: $e');
    }
  }

  void startCamera() async {
    await pickImage();
    print('despues de pickimage');
    print('Global.pages: ${Global.pages}');
    if(this.image != null){
      final path = this.image!.path;
      final bytes = await File(path).readAsBytes();
      Global.cameraBase64 = convert.base64Encode(bytes);
      print('do faceRecognition');
      doFaceRecognition();
    }
  }

  @override
  void initState() {
    super.initState();
    startCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.9,
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.3, -0.3),
                  end: Alignment.bottomRight,
                  // colors: <Color>[Color(0xff0072b0), Color(0xFF1f1d1d)],
                  colors: <Color>[Color(0xff006be6), Color(0xFF21232e)],
                ),
              )
          ),
        ),
        Opacity(
          opacity: 0.9,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              width: 220,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    ' Verificando  ',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        letterSpacing: 1.5
                    ),
                  ),
                  CircularProgressIndicator(
                    strokeWidth: 5,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10)
                ],
              ),
            ),
          ),
        ),
      ]
    );
  }
}
