part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginSubscriptionRequested extends LoginEvent {
  const LoginSubscriptionRequested();
}

class LoginUserNameChanged extends LoginEvent {
  const LoginUserNameChanged(this.id);
  final String id;
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);
  final String password;
}

class LoginSubmitted extends LoginEvent {
  LoginSubmitted(this.login);
  Function() login;
}

class LoginOutSubmitted extends LoginEvent {
  LoginOutSubmitted(this.logout);
  Function() logout;
}
