import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/buttons.dart';
import '../../../../shared/theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.success && state.user?.sessionId != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration initiated successfully'), backgroundColor: AppTheme.successText),
              );
              context.go('/confirm');
            } else if (state.status == AuthStatus.failure && state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!), backgroundColor: AppTheme.errorText),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Create an account',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryText),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Start monitoring your air',
                        style: TextStyle(color: AppTheme.secondaryText, fontSize: 16),
                      ),
                      const SizedBox(height: 32),
                      
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Mail', style: TextStyle(color: AppTheme.primaryText, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'name@gmail.com',
                        prefixIcon: const Icon(Icons.mail_outline, color: AppTheme.secondaryText),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),
                      
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Password', style: TextStyle(color: AppTheme.primaryText, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: '••••••••',
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.secondaryText),
                      ),
                      const SizedBox(height: 24),
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: state.termsAccepted,
                              onChanged: (val) {
                                context.read<AuthBloc>().add(TermsToggled(val ?? false));
                              },
                              fillColor: MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.selected)) {
                                  return AppTheme.primaryText;
                                }
                                return AppTheme.pageBackground;
                              }),
                              checkColor: AppTheme.pageBackground,
                              side: const BorderSide(color: AppTheme.secondaryText),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Acepto los ',
                                style: const TextStyle(color: AppTheme.secondaryText),
                                children: [
                                  TextSpan(
                                    text: 'Términos y Condiciones',
                                    style: const TextStyle(color: AppTheme.primaryText, fontWeight: FontWeight.bold),
                                  ),
                                  const TextSpan(text: ' y la '),
                                  TextSpan(
                                    text: 'Política de Privacidad',
                                    style: const TextStyle(color: AppTheme.primaryText, fontWeight: FontWeight.bold),
                                  ),
                                  const TextSpan(text: '\nde Clair.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      PrimaryButton(
                        text: 'Register',
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            RegisterSubmitted(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      
                      Row(
                        children: [
                          Expanded(child: Divider(color: AppTheme.dividerLine)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('OR REGISTER WITH', style: TextStyle(color: AppTheme.secondaryText, fontSize: 12)),
                          ),
                          Expanded(child: Divider(color: AppTheme.dividerLine)),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      SocialButton(
                        text: 'Google',
                        onPressed: () {
                          // No functionality yet, just UI
                        },
                      ),
                      const SizedBox(height: 32),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? ', style: TextStyle(color: AppTheme.secondaryText)),
                          GestureDetector(
                            onTap: () => context.go('/login'),
                            child: const Text(
                              'Login',
                              style: TextStyle(color: AppTheme.primaryText, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
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
