import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    Key? key,
    this.buttonText,
    this.onTap,
    this.color,
    this.textColor,
  }) : super(key: key);

  final String? buttonText;
  final Widget? onTap;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => onTap!,
            ),
          );
        },
        highlightColor: Colors.transparent, // Düğme vurgu rengini belirleyin
        radius: 50.0, // Basınç yarıçapını ayarlayın
        child: Container(
          padding: const EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            color: color!,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
            ),
          ),
          child: Center(
            child: Text(
              buttonText!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: textColor!,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
