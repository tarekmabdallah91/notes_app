import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/home/home.dart';
import 'package:notes_app/login/bloc/login_bloc.dart';
import 'package:notes_app/utils/text_utils.dart';
import 'package:notes_repository/note_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(
        sessionRespository: context.read<SessionRepository>(),
      )..add(const LoginSubscriptionRequested()),
      child: const CheckSessionStatus(),
    );
  }
}

class CheckSessionStatus extends StatelessWidget {
  const CheckSessionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    var currentStatus = BlocProvider.of<LoginBloc>(context).state.status;
    TextUtils.printLog('CheckSessionStatus', '$currentStatus');
    if (currentStatus == LoginStatus.logout) {
      return const LoginView();
    } else {
      return const HomePage();
    }
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            elevation: 10,
            margin: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _UserNameField(),
                _PasswordField(),
                ElevatedButton(
                    onPressed: () => context.read<LoginBloc>().add(
                          LoginSubmitted(() {
                            TextUtils.printLog("login btn ", 'pressed');
                            GoRouter.of(context).go(
                              HomePage.route,
                            );
                          }),
                        ),
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
    final state = context.watch<LoginBloc>().state;
    const hintText = '1234';

    return TextFormField(
      key: const Key('loggin_userId_textFormField'),
      initialValue: '',
      decoration: const InputDecoration(
        enabled: true,
        labelText: "User id",
        hintText: hintText,
      ),
      maxLength: 4,
      inputFormatters: [
        LengthLimitingTextInputFormatter(4),
        FilteringTextInputFormatter.allow(RegExp(r'[0-9\s]')),
      ],
      onChanged: (value) {
        context.read<LoginBloc>().add(LoginUserNameChanged(value));
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;
    const hintText = '';

    return TextFormField(
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
        context.read<LoginBloc>().add(LoginPasswordChanged(value));
      },
    );
  }
}
