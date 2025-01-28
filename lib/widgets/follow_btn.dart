import 'package:flutter/material.dart';
class FollowButton extends StatelessWidget {
  final Function()? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final Color borderColor;
  const FollowButton({super.key, this.onPressed, required this.backgroundColor, required this.textColor, required this.text, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2),
      child:TextButton(
        onPressed: onPressed,
        child: Container(alignment: Alignment.center,
        decoration: BoxDecoration(
          color:backgroundColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: borderColor),
        ),
        width: 200,
        height: 27,
        child: Text(text,style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        
        ),
        )
        ),
      
    );
  }
}