import 'package:flutter/material.dart';


class CommonElevatedButton extends StatelessWidget {

  final VoidCallback? onPressed;
  final Widget? child;

      CommonElevatedButton({
        Key? key,
        this.child,
        this.onPressed
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(width * 0.04)),
          textStyle: TextStyle(
              fontSize: height * 0.030,
              fontFamily: 'app',
              fontWeight: FontWeight.w400),
          primary: Colors.blue.shade600,
          minimumSize: Size(width * 0.35, height * 0.065)),
    );
  }
}
