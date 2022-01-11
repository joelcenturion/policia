import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ministerio/model/login_model.dart';

part 'login_event2.dart';
part 'login_state2.dart';

class LoginBloc2 extends Bloc<LoginEvent2, LoginState2>{
  LoginBloc2() : super(LoginInitial());


}