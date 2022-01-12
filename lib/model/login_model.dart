
import 'package:ministerio/pages/login2.dart';

class LoginModel {
  late String nombre;

  LoginModel ({required this.nombre});
  LoginModel.fromJson(Map<String, dynamic> json){
    nombre = json['nombre'];

  }
}