part of 'login_bloc.dart';

enum LoginStatus { initial, loading, failure, loggedin }

class LoginState extends Equatable {
  const LoginState( {this.status = LoginStatus.initial, this.id, this.password});

  final LoginStatus status;
  final String? id;
  final String? password;

  LoginState copyWith({
    LoginStatus? status,
    String? id,
    String? password,
  }) {
    return LoginState(
      status: status ?? this.status,
      id: id ?? this.id,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [status, id, password];
}
