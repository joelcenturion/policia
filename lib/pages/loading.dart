import 'package:ministerio/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:ministerio/services/person_data.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void getPerson() async {
    PersonData person = PersonData(ciValue: Global.ci);
    await person.getData(context);

    //SI NO HAY ERRORES SE CARGAN LOS DATOS DE LA PERSONA. SI HAY ALGÚN ERROR SE VUELVE A LA
    //PÁGINA PRINCIPAL

    if (Global.error == false) {
      Global.pages++;
      print('Global.pages: ${Global.pages}');
      Global.noFaces = false;
      Navigator.pushReplacementNamed(context, '/person', arguments: {
        //Pasar los valores a la página person.dart para mostrar
        'message': Global.message,
        'name': Global.name,
        'ci': Global.ci,
        'born_date': Global.bornDate,
        'dosage': Global.dosage,
        'vaccine': Global.vaccine,
        'photoBytes': Global.photoBytes,
        'widht': 120.0,
        'height': 150.0,
        'first_name': Global.first_name,
        'last_name': Global.last_name,
        'vaccine_date': Global.vaccine_date,
        'descripcion': Global.descripcion,
      });
    } else {
      //SI HAY ALGÚN ERROR. RETORNA A LA PÁGINA PRINCIPAL;
      // Navigator.pushNamedAndRemoveUntil(
      //     context, '/home', (Route<dynamic> route) => false);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.3,
          child: AbsorbPointer(child: Home()),
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
        )
      ],
    );
  }
}
