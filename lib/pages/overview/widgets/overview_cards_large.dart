import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/pages/overview/widgets/info_card.dart';

class OverviewCardsLargeScreen extends StatelessWidget {
  const OverviewCardsLargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        InfoCard(
          title: "Operations in porgress",
          value: "7",
          onTap: () {},
          topColor: const Color.fromARGB(255, 64, 112, 241),
        ),
        SizedBox(
          width: width / 64,
        ),
        InfoCard(
          title: "XX",
          value: "17",
          topColor: const Color.fromARGB(255, 64, 112, 241),
          onTap: () {},
        ),
        SizedBox(
          width: width / 64,
        ),
        InfoCard(
          title: "XX",
          value: "3",
          topColor: const Color.fromARGB(255, 64, 112, 241),
          onTap: () {},
        ),
        SizedBox(
          width: width / 64,
        ),
        InfoCard(
          title: "XX",
          value: "32",
          topColor: const Color.fromARGB(255, 64, 112, 241),
          onTap: () {},
        ),
      ],
    );
  }
}
