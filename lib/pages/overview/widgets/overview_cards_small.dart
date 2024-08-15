import 'package:flutter/material.dart';
import 'info_card_small.dart';

class OverviewCardsSmallScreen extends StatelessWidget {
  const OverviewCardsSmallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 400,
      child: Column(
        children: [
          InfoCardSmall(
            title: "Operations in porgress",
            value: "7",
            onTap: () {},
            isActive: true,
          ),
          SizedBox(
            height: width / 64,
          ),
          InfoCardSmall(
            title: "XXX",
            value: "17",
            onTap: () {},
          ),
          SizedBox(
            height: width / 64,
          ),
          InfoCardSmall(
            title: "XXXX",
            value: "3",
            onTap: () {},
          ),
          SizedBox(
            height: width / 64,
          ),
          InfoCardSmall(
            title: "XXXXX",
            value: "32",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
