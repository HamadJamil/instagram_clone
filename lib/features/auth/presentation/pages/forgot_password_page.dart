import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram/core/routes/app_route_name.dart';
import 'package:instagram/core/widgets/custom_filled_button.dart';
import 'package:instagram/core/widgets/custom_outlined_button.dart';
import 'package:instagram/core/widgets/cutom_text_form_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailSent = false;

  void _sendResetEmail(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {});
    // Logic to Send Email
    //////////////////////
    if (!context.mounted) return;
    FocusScope.of(context).unfocus();
    await Future.delayed(Duration(seconds: 2));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.only(
          left: size.width * 0.05,
          right: size.width * 0.05,
          top: size.height * 0.16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                text: 'Forgot Password?',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: _isEmailSent
                        ? '\nCheck your email for reset link'
                        : '\nEnter your email to reset password',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.05),
            if (!_isEmailSent) ...[
              Form(
                key: _formKey,
                child: CustomTextFormField(
                  textController: _emailController,
                  keyBoard: TextInputType.emailAddress,
                  label: 'Email',
                  validator: (value) {
                    //////////////////////////
                    return null;
                  },
                ),
              ),
              SizedBox(height: size.height * 0.05),
              CustomFilledButton(
                onPressed: () => _sendResetEmail(context),
                isEmailSent: (isEmailSent) {
                  setState(() {
                    _isEmailSent = isEmailSent;
                  });
                },
                label: 'Send Reset Email',
              ),
            ] else ...[
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 30),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email Sent!',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Check your email for the password reset link.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Text(
                'Didn\'t receive the email?',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: size.height * 0.02),
              CustomOutlinedButton(onPressed: () {}, label: 'Re-send Email'),
            ],
            SizedBox(height: size.height * 0.05),
            Center(
              child: InkWell(
                onTap: () {
                  context.goNamed(AppRouteName.login);
                },
                child: Text('Back to Login', style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
