import 'package:flutter/material.dart';
import '../utils/app_color.dart';

class TextFieldWidget {
  Widget textFieldWidget({TextEditingController? controller,
    Color? cursorColor,
    TextInputAction? textInputAction,
    InputDecoration? decoration,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    void Function()? onTap,
    Widget? suffixIcon,
    InputBorder? border,
    Color? fillColor,
    int? maxLines = 1,
    int? maxLength,
    String? prefixText,
    String? counterText,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
    String? initialValue,
    bool readOnly = false,
    String? hintText,
    bool obscureText = false,
    InputBorder? focusedBorder,
    String? labelText,
    TextStyle? labelStyle
  }) {
    return TextFormField(
      readOnly: readOnly,
      cursorColor: Colors.white,
      //style: const TextStyle(fontSize: 13,color: AppColor.whiteColor),
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      maxLines: maxLines,
      obscureText: obscureText,
      textInputAction : textInputAction,
      maxLength: maxLength,
      minLines: 1,
      decoration: InputDecoration(
        isDense: false,
        filled: true,
        labelText: labelText,
        labelStyle: TextStyle(color: AppColor.whiteColor.withOpacity(0.5)),
        hintText: hintText,
        counterText: counterText,
        hintStyle: TextStyle(color: AppColor.whiteColor.withOpacity(0.5),fontSize: 12),
        prefixText: prefixText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.appColor.withOpacity(0.3)),borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(10)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.redColor.withOpacity(0.1)),borderRadius: BorderRadius.circular(10)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.appColor.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(10)
        ),
        errorStyle: const TextStyle(
          fontSize: 12.0,
        ),
      ),
    );
  }
}