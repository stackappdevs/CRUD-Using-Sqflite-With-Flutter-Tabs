import 'package:flutter/material.dart';


class CommonIconButton extends StatelessWidget {

  final VoidCallback? onPressed;
  final bool isPwdHide;

  const CommonIconButton({
    Key? key,
    this.isPwdHide=false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: Icon(
          (isPwdHide)
              ? Icons.visibility
              : Icons.visibility_off,
          color: Colors.blue.shade300,
        ));
  }
}

class CommonActionIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;

  const CommonActionIconButton({Key? key,this.onPressed,this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(icon),
        onPressed : onPressed,
    );
  }
}

