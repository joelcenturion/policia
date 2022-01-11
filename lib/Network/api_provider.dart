import 'package:dio/dio.dart';

const STATUS_NOT_FOUND = 404;
const STATUS_INTERNAL_ERROR = 500;
const STATUS_OK = 200;
const LOGIN_URL = '';

class ApiProvider {
  Dio dio = Dio();
  late Response response;
  String connErr = 'No se puede conectar con el servidor. Verifique su conexión a Internet.';

  Future<Response> postConnect(url, data) async{
    try{
      dio.options.headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJTQUkiLCJpYXQiOjE2MjMxMDY1OTMsInN1YiI6ImFkbWluIiwiZXhwIjoxNjIzMTI4MTkzfQ.-ghkzCHUghscyn9TQPv3-OqIJIhVx8fqXUaj6wI1o-4';
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.setRequestContentTypeWhenNoPayload = true;
      dio.options.connectTimeout = 30000; //5s
      dio.options.receiveTimeout = 25000;

      return await dio.post(url, data: data);

    }on DioError catch (e){
      if(e.type == DioErrorType.response){
        int? statusCode = e.response!.statusCode;
        if(statusCode == STATUS_NOT_FOUND){
          throw "Api not found";
        } else if(statusCode == STATUS_INTERNAL_ERROR){
          throw "Internal Server Error";
        } else {
          throw e.error.message.toString();
        }
      } else if(e.type == DioErrorType.connectTimeout){
        throw e.message.toString();
      } else if(e.type == DioErrorType.cancel){
        throw 'cancel';
      }
      throw connErr;
    }finally{
      dio.close();
    }
  }

  login(String username, String password) async{
    Map<String, dynamic> postData = {
      'username': username,
      'password': password
    };
    response = await postConnect(LOGIN_URL, postData);
    if(response.statusCode == STATUS_OK){

    }

  }



}