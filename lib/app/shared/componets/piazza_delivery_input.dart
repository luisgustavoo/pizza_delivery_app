import 'package:flutter/material.dart';

class PizzaDeliveryInput extends TextFormField {
  PizzaDeliveryInput(
    label, {
    TextEditingController controller,
    TextInputType keyboardType,
    Icon suffixIcon,
    obscureText = false,
    FormFieldValidator validator,
    Function suffixIconOnPressed,
  }) : super(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText as bool,
          decoration: InputDecoration(
              labelText: label as String,
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      icon: suffixIcon,
                      onPressed: () {
                        suffixIconOnPressed();
                      })
                  : null),
          validator: validator,
        );
}
