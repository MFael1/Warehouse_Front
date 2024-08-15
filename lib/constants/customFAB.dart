import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/constants/style.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;

  const CustomFAB({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.primaryColor,
      child: icon,
      foregroundColor: Colors.white,
      tooltip: 'Add',
      elevation: 4.0,
      splashColor: AppColors.secondaryColor,
    );
  }
}
