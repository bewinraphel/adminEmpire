import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/commonvalidator.dart';
import 'package:empire/feature/auth/domain/usecase/save_login_status_usecase.dart';
import 'package:empire/feature/auth/presentation/bloc/login_bloc.dart';
import 'package:empire/feature/auth/presentation/widget/widget.dart';

import 'package:empire/feature/homepage/presentation/view/home_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Loginpage extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final usernamecController = TextEditingController();
  final passwordController = TextEditingController();
  bool isremberme = false;

  Loginpage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginBloc(sl(), sl<SaveLoginStatus>()),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxwidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;
            final issmallScreen = constraints.maxWidth < 600;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: maxwidth * 0.05,
                vertical: maxHeight * 0.02,
              ),
              child: SingleChildScrollView(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: maxHeight / 7),
                        const Headline(headlind: 'Login'),
                        SizedBox(height: maxHeight / 7),
                        LoginField(
                          controller: usernamecController,
                          label: 'Email',
                          prefixican: Icons.person,
                          issmallScreen: issmallScreen,
                          maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
                          validator: (value) {
                            return Validators.validateEmail(value ?? "");
                          },
                        ),
                        SizedBox(height: maxHeight * 0.030),
                        LoginField(
                          obscureText: true,
                          controller: passwordController,
                          label: 'Password',
                          prefixican: Icons.lock_outline,
                          issmallScreen: issmallScreen,
                          maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
                          validator: (value) {
                            return Validators.validatePassword(value ?? '');
                          },
                        ),
                        const SizedBox(height: 20),

                        const SizedBox(height: 80),
                        BlocListener<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state is LoginSucess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('suceesfuly logined'),
                                ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const HomePage();
                                  },
                                ),
                              );
                            } else if (state is ErrorLogin) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.error)),
                              );
                            }
                          },
                          child: Authbutton(
                            name: 'Login',
                            issmallScreen: issmallScreen,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<LoginBloc>().add(
                                  LogPresed(
                                    usernamecController.text,
                                    passwordController.text,
                                  ),
                                );
                              }
                            },
                            maxwidth: maxwidth,
                            formKey: formKey,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
