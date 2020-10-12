import 'package:flutter/material.dart';

class PizzaDeliveryButton extends Container {
  PizzaDeliveryButton(
    String label, {
    @required double width,
    @required double height,
    ShapeBorder shape,
    TextStyle textStyle,
    double labelSize = 12,
    Color labelColor,
    Function onPressed,
    Color buttonColor,
  }) : super(
          width: width,
          height: height,
          child: RaisedButton(
            onPressed: onPressed,
            color: buttonColor,
            child: Text(
              label,
              style: textStyle ??
                  TextStyle(fontSize: labelSize, color: labelColor),
            ),
            shape: shape ??
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        );
}
