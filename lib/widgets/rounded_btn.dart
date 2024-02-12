import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String buttonName;
  final Icon? icon;
  final Color? backgroundcolor;
  final VoidCallback? callback;

  RoundedButton(
      {required this.buttonName, this.icon, this.backgroundcolor=Colors.blue, this.callback});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          callback!();
        },
        child:icon!=null? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon!,
            Container(width: 11,),
            Text(buttonName)
          ],
        ):Text(buttonName),
        style:ElevatedButton.styleFrom(
          primary: backgroundcolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(21),
              bottomLeft: Radius.circular(21),
            )
          )
        ) ,
    );
  }
}
