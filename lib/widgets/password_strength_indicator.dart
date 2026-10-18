import 'package:flutter/material.dart';

enum PasswordStrength { none, weak, medium, strong }

/// Menghitung kekuatan password.
/// Lemah  : < 8 karakter (atau tidak memenuhi kriteria sedang).
/// Sedang : >= 8 karakter, mengandung huruf dan angka.
/// Kuat   : >= 8 karakter, huruf kapital, huruf kecil, angka, dan simbol.
PasswordStrength calculatePasswordStrength(String password) {
  if (password.isEmpty) return PasswordStrength.none;
  if (password.length < 8) return PasswordStrength.weak;

  final hasUpper = password.contains(RegExp(r'[A-Z]'));
  final hasLower = password.contains(RegExp(r'[a-z]'));
  final hasDigit = password.contains(RegExp(r'[0-9]'));
  final hasSymbol = password.contains(RegExp(r'[^A-Za-z0-9]'));

  if (hasUpper && hasLower && hasDigit && hasSymbol) {
    return PasswordStrength.strong;
  }
  if ((hasUpper || hasLower) && hasDigit) {
    return PasswordStrength.medium;
  }
  return PasswordStrength.weak;
}

/// Indikator visual kekuatan password (bar + label).
class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;

  const PasswordStrengthIndicator({super.key, required this.strength});

  @override
  Widget build(BuildContext context) {
    if (strength == PasswordStrength.none) return const SizedBox.shrink();

    final (label, color, value) = switch (strength) {
      PasswordStrength.weak => ('Lemah', Colors.red, 0.33),
      PasswordStrength.medium => ('Sedang', Colors.orange, 0.66),
      PasswordStrength.strong => ('Kuat', Colors.green, 1.0),
      PasswordStrength.none => ('', Colors.grey, 0.0),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Kekuatan password: $label',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
