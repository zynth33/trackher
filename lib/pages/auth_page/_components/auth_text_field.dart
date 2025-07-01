import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String label;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        onTap: onTap,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) =>
        (value == null || value.trim().isEmpty) ? 'Required field' : null,
      ),
    );
  }
}
