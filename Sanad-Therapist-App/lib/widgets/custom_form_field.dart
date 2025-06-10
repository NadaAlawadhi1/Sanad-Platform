import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final double height;
  final RegExp validationRegEx;
  final void Function(String?) onSaved;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;

  const CustomFormField({
    super.key,
    required this.hintText,
    required this.height,
    required this.validationRegEx,
    required this.onSaved,
    this.obscureText = false,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        obscureText: obscureText,
        onSaved: onSaved,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your ${hintText.toLowerCase()}";
          }
          // Check for email validation
          else if (hintText.toLowerCase() == "email") {
            if (!validationRegEx.hasMatch(value)) {
              return "Please enter a valid email address.";
            }
          }
          // Check for password validation
          else if (hintText.toLowerCase() == "password") {
            if (value.length < 8) {
              return "Password must be at least 8 characters long.";
            } else if (!RegExp(r".*[A-Z].*").hasMatch(value)) {
              return "Password must contain at least one uppercase letter.";
            } else if (!RegExp(r".*[a-z].*").hasMatch(value)) {
              return "Password must contain at least one lowercase letter.";
            } else if (!RegExp(r".*\d.*").hasMatch(value)) {
              return "Password must contain at least one number.";
            }
          }
          // Check for name validation
          else if (hintText.toLowerCase() == "name") {
            if (!validationRegEx.hasMatch(value)) {
              return "Please enter a valid name.";
            }
          }

          // General validation using provided regex
          else if (!validationRegEx.hasMatch(value)) {
            return "Enter a valid ${hintText.toLowerCase()}";
          }

          // If all validations pass
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
          suffixIcon: obscureText
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
        ),
      ),
    );
  }
}
