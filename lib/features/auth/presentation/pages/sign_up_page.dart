import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram/core/constants/routes/app_route_name.dart';
import 'package:instagram/core/widgets/custom_password_field.dart';
import 'package:instagram/core/widgets/cutom_text_form_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.17),
              const Image(
                image: AssetImage('assets/images/instagram.png'),
                height: 80.0,
                width: 80.0,
              ),
              SizedBox(height: size.height * 0.1),
              CustomTextFormField(
                label: 'Username',
                textController: TextEditingController(), // Add Controller
                keyBoard: TextInputType.name,
                validator: (value) {
                  return null;
                }, // Add validation logic here
              ),
              SizedBox(height: size.height * 0.015),
              CustomTextFormField(
                label: 'Email',
                textController: TextEditingController(), //
                keyBoard: TextInputType.emailAddress,
                validator: (value) {
                  return null;
                }, //
              ),
              SizedBox(height: size.height * 0.015),
              CustomPasswordField(
                label: 'Password',
                textController: TextEditingController(),
              ),
              SizedBox(height: size.height * 0.015),
              SizedBox(
                width: double.infinity,
                height: size.height * 0.055,
                child: FilledButton(onPressed: () {}, child: Text('Sign up')),
              ),
              SizedBox(height: size.height * 0.2),
              InkWell(
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
            ],
          ),
        ),
      ),
    );
  }
}
