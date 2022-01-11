
class LoginModel {
  late String nombre;

  LoginModel.fromJson(Map<String, dynamic> json){
    nombre = json['nombre'];
  }
}