import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/constants/customFAB.dart';
import 'package:flutter_web_dashboard/pages/adding_supplier_and_customer.dart/dialogCusSup.dart';
import 'package:flutter_web_dashboard/helpers/local_navigator.dart';
import 'package:flutter_web_dashboard/helpers/reponsiveness.dart';
import 'package:flutter_web_dashboard/widgets/large_screen.dart';
import 'package:flutter_web_dashboard/widgets/side_menu.dart';

import 'widgets/top_nav.dart';

class SiteLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  SiteLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: topNavigationBar(context, scaffoldKey),
      drawer: const Drawer(
        child: SideMenu(),
      ),
      body: ResponsiveWidget(
          largeScreen: const LargeScreen(),
          smallScreen: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: localNavigator(),
          )),
      floatingActionButton: CustomFAB(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddDialog(),
          );
        },
        icon: const Icon(Icons.add),
      ),
    );
  }
}
