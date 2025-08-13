import 'package:flutter/material.dart';
import 'package:instagram/core/widgets/custom_password_field.dart';
import 'package:instagram/core/widgets/cutom_text_form_field.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Center(
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
                  label: 'Email',
                  textController: TextEditingController(), // Add Controller
                  keyBoard: TextInputType.emailAddress,
                  validator: (value) {
                    return null;
                  }, // Add validation logic here
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
                  child: FilledButton(onPressed: () {}, child: Text('Log in')),
                ),
                SizedBox(height: size.height * 0.025),
                InkWell(onTap: () {}, child: Text('Forgot password?')),
                SizedBox(height: size.height * 0.225),
                SizedBox(
                  height: size.height * 0.055,
                  width: double.infinity,
                  child: Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Text(
                        'Create new account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
