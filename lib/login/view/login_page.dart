import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/home/home.dart';
import 'package:notes_app/login/cubit/login_cubit.dart';
import 'package:notes_app/utils/text_utils.dart';
import 'package:notes_repository/note_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        sessionRespository: context.read<SessionRepository>(),
      ),
      child: const CheckSessionStatus(),
    );
  }
}

class CheckSessionStatus extends StatelessWidget {
  const CheckSessionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    var loginCubit = BlocProvider.of<LoginCubit>(context);
    loginCubit.checkCurrentStatus();
    // var currentStatus = loginCubit.state.status;
    
    return BlocConsumer<LoginCubit, LoginState>(builder: (context, state) {
      TextUtils.printLog('CheckSessionStatus', state.status);
      if (state.status == LoginStatus.loggedin){
        return const HomePage();
    } else {
      return const LoginView();
    }
    }, listener: (context, state) {},);
    
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 117, 183, 124),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({
    Key? key,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            elevation: 10,
            margin: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _UserNameField(),
                _PasswordField(),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        context.read<LoginCubit>().onLoginBtnPressed(()=> () {
                          TextUtils.printLog("login btn ", 'pressed');
                          GoRouter.of(context).go(
                            HomePage.route,
                          );
                        });
                      }
                    },
                    child: Text('Login'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserNameField extends StatelessWidget {
  const _UserNameField();

  @override
  Widget build(BuildContext context) {
    const hintText = '1234';
    final idRegex =
        RegExp(r'[0-9\s]'); // r'([0-9]{4}$)' r'[0-9\s]' TODO need to be fixed
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        key: const Key('loggin_userId_textFormField'),
        initialValue: '',
        decoration: const InputDecoration(
          enabled: true,
          labelText: "User Id",
          hintText: hintText,
        ),
        maxLength: 4,
        inputFormatters: [
          LengthLimitingTextInputFormatter(4),
          FilteringTextInputFormatter.allow(idRegex),
        ],
        onChanged: (value) {
          context.read<LoginCubit>().onUserNameChanged(value);
        },
        validator: (value) {
          return context.read<LoginCubit>().validateUserName(value);
        },
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    const hintText = '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        key: const Key('login_password_textFormField'),
        initialValue: '',
        decoration: const InputDecoration(
          enabled: true,
          labelText: 'password',
          hintText: hintText,
        ),
        maxLength: 20,
        maxLines: 1,
        inputFormatters: [
          LengthLimitingTextInputFormatter(20),
        ],
        onChanged: (value) {
          context.read<LoginCubit>().onPasswordChanged(value);
        },
        validator: (value) {
         return context.read<LoginCubit>().validatPassword(value);
          
        },
        obscureText: true,
      ),
    );
  }
}
