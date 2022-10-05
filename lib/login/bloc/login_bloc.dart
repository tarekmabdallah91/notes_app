import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:notes_api/notes_api.dart';
import 'package:notes_app/utils/text_utils.dart';
import 'package:notes_repository/note_repository.dart';
part 'login_state.dart';
part 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required SessionRepository sessionRespository})
      : _repository = sessionRespository,
        super(const LoginState()) {
    on<LoginSubscriptionRequested>(_onSubscriptionRequested);
    on<LoginUserNameChanged>(_onUserNameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginOutSubmitted>(_loggout);
  }

  final SessionRepository _repository;

  Future<void> _onSubscriptionRequested(
    LoginSubscriptionRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    TextUtils.printLog("token", _repository.getUser().token);
    if (_repository.getUser().token.isNotEmpty) {
      emit(state.copyWith(status: LoginStatus.loggedin));
    } else {
      emit(state.copyWith(status: LoginStatus.initial));
    }
  }

  void _onUserNameChanged(
    LoginUserNameChanged event,
    Emitter<LoginState> emit,
  ) {
    if (event.id.length != 4) return;
    user = user.copyWith(id: event.id);
    emit(state.copyWith(id: event.id));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    if (event.password.length < 6) {
      emit(state.copyWith(password: ''));
    }
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    validateLoginData(state);
    try {
      _repository.saveUser(user);
      event.login();
      emit(state.copyWith(status: LoginStatus.loggedin));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }

  void validateLoginData(LoginState state) {
    // var id = state.id!;

    // var password = state.password!;

    login();
  }

  void login() {
    // call Api to login
    String token = "user token 101010101010";
    user = user.copyWith(token: token);
    _repository.saveUser(user);
    TextUtils.printLog('user from SP', _repository.getUser());
    TextUtils.printLog('login user', user.toJson());
  }

  User user = User(id: 'name', token: 'token');

  Future<void> _loggout(
    LoginOutSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    try {
      user = user.copyWith(token: '');
      _repository.saveUser(user);
      TextUtils.printLog('loggout', 'user loggout');
      emit(state.copyWith(status: LoginStatus.initial));
      event.logout();
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }
}
