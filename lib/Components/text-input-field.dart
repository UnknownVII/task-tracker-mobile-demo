import 'package:flutter/material.dart';

class textFormField extends StatelessWidget {
  final FocusNode? focusNode;
  final VoidCallback onTap;
  final TextInputType keyboardType;
  final TextInputAction keyboardAction;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String> validator;
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final TextAlignVertical? textAlignVertical;
  final Widget? suffix;
  final Widget? prefix;
  final String label;
  final String? errorText;
  final bool obscure;
  final bool enabled;
  final int? maxLine;
  final int? maxLength;
  final bool readOnly;
  final bool? alignLabelWithHint;
  final bool? enableInteractiveSelection;

  textFormField({Key? key,
    required this.validator,
    required this.keyboardType,
    this.controller,
    this.textAlignVertical,
    this.focusNode,
    required this.textCapitalization,
    this.alignLabelWithHint,
    required this.onTap,
    this.errorText,
    required this.label,
    this.suffix,
    this.prefix,
    required this.readOnly,
    this.enableInteractiveSelection,
    this.enabled = true,
    this.maxLength,
    this.maxLine,
    required this.keyboardAction,
    required this.onSaved,
    this.obscure = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      readOnly: readOnly,
      controller: controller,
      enableInteractiveSelection: enableInteractiveSelection,
      textCapitalization: textCapitalization,
      focusNode: focusNode,
      onTap: onTap,
      keyboardType: keyboardType,
      textInputAction: keyboardAction,
      onSaved: onSaved,
      validator: validator,
      obscureText: obscure,
      decoration: new InputDecoration(
        filled: true,
        fillColor: enabled ? Color(0xFFE4EBF8): Color(0x93E4EBF8),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme
                .of(context)
                .primaryColor
                .withOpacity(0.2),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme
                .of(context)
                .primaryColor
                .withOpacity(0.6),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF21e6c1),
            width: 1.5
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
        // contentPadding: EdgeInsets.only(left: 0, bottom: 11, top: 11, right: 0),
        labelText: label,
        labelStyle: TextStyle(
          color:  enabled ? (focusNode != null ? (focusNode!.hasFocus ? Color(0xFF021632) : Colors.grey) : Colors.grey) : Color(0xFF021632),
          fontSize: 18,
          height: 3,
        ),
        iconColor: enabled ? Color(0xFF021632): Color(0x79021632),
        prefixIcon: prefix,
        prefixIconColor:  enabled ? Color(0xFF021632): Color(0x79021632),
        suffixIcon: suffix,
        suffixIconColor:  enabled ? Color(0xFF021632): Color(0x79021632),
        counterStyle: TextStyle(color: Color(0xFFE4EBF8), fontSize: 16),
        alignLabelWithHint: alignLabelWithHint,
      ),
      maxLength: maxLength,
      maxLines: maxLine,
      textAlignVertical: textAlignVertical,

    );
  }
}
