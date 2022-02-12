import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextFormField extends StatelessWidget {


  final TextEditingController? controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final  GestureTapCallback? onTap;
  final Widget? icon;
  final TextInputType? keyboardType;
  final bool isObscureText;
  final FormFieldSetter<String>? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final Widget? suffix;


  CommonTextFormField({
    Key? key,
    this.controller,
    this.hintText,
    this.icon,
    this.inputFormatters,
    this.isObscureText=false,
    this.onSaved,
    this.onTap,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.validator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffix,
      ),
      validator: validator,
      onSaved: onSaved,
      onTap: onTap,
      obscureText: isObscureText,
      controller: controller,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
    );
  }
}

