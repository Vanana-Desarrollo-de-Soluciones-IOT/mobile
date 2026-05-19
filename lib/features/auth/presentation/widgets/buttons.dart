import 'package:flutter/material.dart';
import '../../../../shared/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppTheme.primaryButtonTextActive,
                  strokeWidth: 2,
                ),
              )
            : Text(text),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String? iconPath;

  const SocialButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primaryText,
          side: const BorderSide(color: AppTheme.socialButtonBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: SvgPicture.asset(
          iconPath ?? 'assets/images/google_logo.svg',
          width: 24,
          height: 24,
        ),
        label: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
