import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  void toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Color claroColor = (Colors.indigo[800])!;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.indigo[700], // status bar color
    ));
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.3, -0.3),
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xff0072b0), Color(0xFF1f1d1d)],
            ),
          ),
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    'assets/policia.png',
                    height: 120,
                    width: 320,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Text(
                  'INICIAR SESIÓN',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: Text('Policía Nacional',
                    style: TextStyle(
                      fontSize: 15,
                    )),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.all(10),
                      child: Text(
                        'Email',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'funcionario@mail.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: claroColor,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.all(10),
                      child: Text(
                        'Contraseña',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextField(
                      enableSuggestions: false,
                      obscureText: _obscureText,
                      autocorrect: false,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: toggleObscureText,
                          child: Icon(
                            _obscureText
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: claroColor,
                          ),
                        ),
                        hintText: '6+ caracteres',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: claroColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text('INGRESAR'),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: claroColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      )),
                ),
              ),
              Row(
                children: [
                  Text('¿Olvidó su contraseña?'),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'Recuperar',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
