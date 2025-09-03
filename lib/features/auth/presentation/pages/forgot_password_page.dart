import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram/core/routes/app_route_name.dart';
import 'package:instagram/core/utils/toast.dart';
import 'package:instagram/core/widgets/cutom_text_form_field.dart';
import 'package:instagram/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:instagram/features/auth/presentation/cubits/auth_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ToastUtils.showErrorToast(context, state.message);
        }
      },
      builder: (context, state) {
        bool isEmailSent = state is AuthVerificationSent;
        bool isLoading = state is AuthLoading;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16, right: 16, top: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Forgot Password?',
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: isEmailSent
                            ? '\nCheck your email for reset link'
                            : '\nEnter your email to reset password',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                if (!isEmailSent) ...[
                  Form(
                    key: _formKey,
                    child: CustomTextFormField(
                      textController: _emailController,
                      keyBoard: TextInputType.emailAddress,
                      label: 'Email',
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
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: isLoading ? null : () => _sendResetEmail(),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Send Reset Email'),
                  ),
                ] else ...[
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 32),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email Sent!',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Check your email for the password reset link.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Didn\'t receive the email?',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: isLoading ? null : () => _sendResetEmail(),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Resend Email'),
                  ),
                ],
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        context.goNamed(AppRouteName.login);
                      },
                      child: const Text(
                        'Back to Login',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().resetPassword(_emailController.text);
  }
}
