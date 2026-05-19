import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/buttons.dart';
import '../../../../shared/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
            if (state.status == AuthStatus.success && state.user?.token != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login successful'), backgroundColor: AppTheme.successText),
              );
              context.go('/dashboard');
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
                      SvgPicture.asset(
                        'assets/images/logo_white.svg',
                        height: 60,
                        colorFilter: const ColorFilter.mode(AppTheme.primaryText, BlendMode.srcIn),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Login to Clair',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryText),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enter your credentials',
                        style: TextStyle(color: AppTheme.secondaryText, fontSize: 14),
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
                      const SizedBox(height: 32),
                      
                      PrimaryButton(
                        text: 'Login',
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            LoginSubmitted(
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
                            child: Text('OR LOGIN WITH', style: TextStyle(color: AppTheme.secondaryText, fontSize: 12)),
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
                          const Text("Don't have an account? ", style: TextStyle(color: AppTheme.secondaryText)),
                          GestureDetector(
                            onTap: () => context.go('/register'),
                            child: const Text(
                              'Register',
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
