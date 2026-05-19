import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/buttons.dart';
import '../../../../shared/theme.dart';

class ConfirmPage extends StatefulWidget {
  const ConfirmPage({Key? key}) : super(key: key);

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
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
                const SnackBar(content: Text('Registration confirmed successfully'), backgroundColor: AppTheme.successText),
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
                      const Text(
                        'Verify your email',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryText),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enter the code sent to your mail',
                        style: TextStyle(color: AppTheme.secondaryText, fontSize: 16),
                      ),
                      const SizedBox(height: 32),
                      
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Verification Code', style: TextStyle(color: AppTheme.primaryText, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _codeController,
                        hintText: 'H9GF-BRLL',
                        prefixIcon: const Icon(Icons.verified_user_outlined, color: AppTheme.secondaryText),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 32),
                      
                      PrimaryButton(
                        text: 'Confirm',
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            ConfirmRegistrationSubmitted(
                              verificationCode: _codeController.text,
                            ),
                          );
                        },
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
