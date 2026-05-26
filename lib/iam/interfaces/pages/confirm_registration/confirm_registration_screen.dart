import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/iam/interfaces/pages/confirm_registration/confirm_registration_cubit.dart';
import 'package:mobile/iam/interfaces/widgets/auth_button.dart';
import 'package:mobile/iam/interfaces/widgets/auth_text_field.dart';

class ConfirmRegistrationScreen extends StatefulWidget {
  final String? sessionId;

  const ConfirmRegistrationScreen({super.key, this.sessionId});

  @override
  State<ConfirmRegistrationScreen> createState() => _ConfirmRegistrationScreenState();
}

class _ConfirmRegistrationScreenState extends State<ConfirmRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sessionController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.sessionId != null) {
      _sessionController.text = widget.sessionId!;
    }
  }

  @override
  void dispose() {
    _sessionController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ConfirmRegistrationCubit, ConfirmRegistrationState>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.go('/login');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration confirmed! Please sign in.')),
            );
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Confirm Registration',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Enter the verification code sent to your email.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    AuthTextField(
                      controller: _sessionController,
                      label: 'Session ID',
                      readOnly: widget.sessionId != null,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Session ID is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _codeController,
                      label: 'Verification Code (XXXX-XXXX)',
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Verification code is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    AuthButton(
                      label: 'Confirm',
                      isLoading: state.isLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ConfirmRegistrationCubit>().confirmRegistration(
                                sessionId: _sessionController.text.trim(),
                                verificationCode: _codeController.text.trim().toUpperCase(),
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Back to Sign In'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
