import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram/core/routes/app_route_name.dart';
import 'package:instagram/core/theme/app_colors.dart';
import 'package:instagram/core/widgets/custom_password_field.dart';
import 'package:instagram/core/widgets/cutom_text_form_field.dart';
import 'package:instagram/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:instagram/features/auth/presentation/cubits/auth_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is AuthVerificationSent) {
          context.goNamed(AppRouteName.emailVerification);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 140),
                  const Image(
                    image: AssetImage('assets/images/instagram.png'),
                    height: 80.0,
                    width: 80.0,
                  ),
                  const SizedBox(height: 40.0),
                  CustomTextFormField(
                    label: 'Username',
                    textController: _usernameController,
                    keyBoard: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  CustomTextFormField(
                    label: 'Email',
                    textController: _emailController,
                    keyBoard: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  CustomPasswordField(
                    label: 'Password',
                    textController: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => _signUp(context),
                          child: state is AuthLoading
                              ? SpinKitWave(color: AppColors.white, size: 20.0)
                              : const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          context.goNamed(AppRouteName.login);
                        },
                        child: Text(
                          'I already have an account',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signUp(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signUp(
        name: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }
}
