import 'package:flutter/material.dart';
import 'package:whatsapp/view/common/text.dart';

class Button extends StatelessWidget {
  final double? height, width, fontSize;
  final String buttonName;
  final String? fontFamily;
  final GestureTapCallback onTap;
  final Color buttonColor;
  const Button({
    Key? key,
    this.height,
    this.width,
    required this.buttonName,
    required this.onTap,
    required this.buttonColor,
    this.fontSize,
    this.fontFamily = 'Poppins',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: buttonColor),
        onPressed: onTap,
        child: Ts(
          text: buttonName,
          size: fontSize,
          family: fontFamily!,
        ),
      ),
    );
  }
}
