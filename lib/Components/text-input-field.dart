import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class textFormField extends StatelessWidget {
  final FocusNode focusNode;
  final VoidCallback onTap;
  final TextInputType keyboardType;
  final TextInputAction keyboardAction;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String> validator;
  final Widget? suffix;
  final Widget? prefix;
  final String label;
  final String? errorText;
  final bool obscure;
  final bool enabled;

  textFormField(
      {Key? key,
      TextEditingController? controller,
      required this.validator,
      required this.keyboardType,
      required this.focusNode,
      required this.onTap,
      this.errorText,
      required this.label,
      this.suffix,
      this.prefix,
      this.enabled = true,
      required this.keyboardAction,
      required this.onSaved,
      this.obscure = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        focusNode: focusNode,
        onTap: onTap,
        keyboardType: keyboardType,
        textInputAction: keyboardAction,
        onSaved: onSaved,
        validator: validator,
        obscureText: obscure,
        decoration: new InputDecoration(
          filled: true,
          fillColor: Color(0xFFE4EBF8),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          ),
          disabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFFD5066),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFFD5066),
            ),
          ),
          contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          labelText: label,
          labelStyle: TextStyle(
            color: focusNode.hasFocus ? Color(0xFF857A7A) : Colors.grey,
            fontSize: 18,
          ),
          prefixIcon: prefix,
          suffixIcon: suffix
        ),
      ),
    );
  }
}
