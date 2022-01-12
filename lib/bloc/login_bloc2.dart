import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ministerio/model/login_model.dart';

part 'login_event2.dart';
part 'login_state2.dart';

class LoginBloc2 extends Bloc<LoginEvent2, LoginState2>{
  LoginBloc2() : super(LoginInitial());

  @override
  Stream<LoginState2> mapEventToState(LoginEvent2 event,) async*{
    if (event is Login2){
      yield* _login(event.username, event.password);
    }
  }
}

Stream<LoginState2> _login (String username, String password) async*{

  yield LoginWaiting();
  try{
    LoginModel  data = await _loginTest(username, password);
    yield LoginSuccess(loginData: data);
  }catch (ex){
    yield LoginError(errorMessage: ex.toString());
  }

}

Future<LoginModel> _loginTest(String username, String password) async{
  await Future.delayed(Duration(milliseconds: 1500));
  if((username == 'admin' || username == 'user1' || username == 'user2') && password == 'spi2022'){
    return LoginModel(nombre: 'admin');
  }else{
     throw 'Credenciales Incorrectos';
  }
}