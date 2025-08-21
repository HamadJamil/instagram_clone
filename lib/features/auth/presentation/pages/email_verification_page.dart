import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram/core/routes/app_route_name.dart';
import 'package:instagram/core/theme/app_colors.dart';
import 'package:instagram/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:instagram/features/auth/presentation/cubits/auth_state.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            height: size.height,
            width: size.width,
            padding: const EdgeInsets.only(left: 15, right: 15, top: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text.rich(
                  TextSpan(
                    text: 'Verify Email',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: '\nCheck your email for verification link',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.mark_email_unread_outlined,
                        color: Colors.green,
                        size: 30,
                      ),
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
                              'Check your email or spam folder for the verification link.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Didn\'t receive the email?',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 15),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return OutlinedButton(
                      onPressed: () {
                        context.read<AuthCubit>().sendVerificationEmail();
                      },
                      child: state is AuthLoading
                          ? SpinKitWave(color: AppColors.primary, size: 20.0)
                          : const Text('Re-send Email'),
                    );
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        context.pushNamed(AppRouteName.login);
                      },
                      child: Text(
                        'Back to Login',
                        style: TextStyle(fontSize: 14),
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
}
