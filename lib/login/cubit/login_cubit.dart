import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:notes_api/notes_api.dart';
import 'package:notes_app/utils/text_utils.dart';
import 'package:notes_repository/note_repository.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required SessionRepository sessionRespository})
      : _repository = sessionRespository,
        super(const LoginState());

  final SessionRepository _repository;
  User user = User(id: 'name', token: 'token');

  void checkCurrentStatus() {
    emit(state.copyWith(status: LoginStatus.loading));
    String token = _repository.getUser().token;
    TextUtils.printLog("token", token);
    if (token.isNotEmpty) {
      emit(state.copyWith(status: LoginStatus.loggedin));
    } else {
      emit(state.copyWith(status: LoginStatus.initial));
    }
  }

  void onUserNameChanged(String id) {
    if (id.length != 4) return;
    user = user.copyWith(id: id);
    emit(state.copyWith(id: id));
  }

  String? validateUserName(String? value) {
    final idRegex = RegExp(r'[0-9\s][0-9\s][0-9\s][0-9\s]');
    if (value == null || value.isEmpty) {
      return 'User Id Required';
    } else {
      if (!idRegex.hasMatch(value)) {
        return 'Id must be 4 digits';
      }
      return null;
    }
  }

  void onPasswordChanged(String password) {
    if (password.length < 6) {
      emit(state.copyWith(password: ''));
    }
    emit(state.copyWith(password: password));
  }

  String? validatPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }
    return null;
  }

  void onLoginBtnPressed(Function login) async {
    emit(state.copyWith(status: LoginStatus.loading));
    if (!isLoginDataValid(state)) return;
    _saveToken();
    try {
      _repository.saveUser(user);
      login();
      emit(state.copyWith(status: LoginStatus.loggedin));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }

  bool isLoginDataValid(LoginState state) {
    if (state.id == null ||
        state.id!.isEmpty ||
        state.password == null ||
        state.password!.isEmpty) {
      TextUtils.printLog('validateLoginData', 'invalid data');
      return false;
    }
    return true;
  }

  void _saveToken() {
    // call Api to login
    String token = "user token 101010101010";
    user = user.copyWith(token: token);
    _repository.saveUser(user);
    TextUtils.printLog('user from SP', _repository.getUser());
    TextUtils.printLog('login user', user.toJson());
  }

  void loggout(Function logout) async {
    try {
      user = user.copyWith(token: '');
      _repository.saveUser(user);
      TextUtils.printLog('loggout', 'user loggout');
      emit(state.copyWith(status: LoginStatus.initial));
      logout();
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }
}
