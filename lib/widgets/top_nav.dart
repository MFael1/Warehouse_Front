import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/constants/style.dart';
import 'package:flutter_web_dashboard/helpers/reponsiveness.dart';
import 'package:flutter_web_dashboard/widgets/custom_text.dart';
// import 'package:flutter_web_dashboard/widgets/settings_dialog.dart';
// import 'package:flutter_web_dashboard/widgets/notifications_popup.dart';

AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
    AppBar(
      leading: !ResponsiveWidget.isSmallScreen(context)
          ? const Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 16)),
              ],
            )
          : IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                key.currentState?.openDrawer();
              }),
      title: Row(
        children: [
          Visibility(
              visible: !ResponsiveWidget.isSmallScreen(context),
              child: const CustomText(
                text: "Admin Panel",
                color: lightGrey,
                size: 20,
                weight: FontWeight.bold,
              )),
          Expanded(child: Container()),
          IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              onPressed: () {
                showSettingsDialog(context); // Show the settings dialog
              }),
          Stack(
            children: [
              const NotificationsPopup(), // Use NotificationsPopup directly here
              Positioned(
                top: 7,
                right: 7,
                child: Container(
                  width: 12,
                  height: 12,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: active,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black, width: 2)),
                ),
              ),
            ],
          ),
          Container(
            width: 1,
            height: 22,
            color: lightGrey,
          ),
          const SizedBox(
            width: 24,
          ),
          const SizedBox(
            width: 16,
          ),
          Container(
            decoration: BoxDecoration(
                color: active.withOpacity(.5),
                borderRadius: BorderRadius.circular(30)),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.all(2),
              child: const CircleAvatar(
                backgroundColor: light,
                child: Icon(
                  Icons.person_outline,
                  color: dark,
                ),
              ),
            ),
          )
        ],
      ),
      iconTheme: const IconThemeData(color: dark),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );

// import 'package:flutter/material.dart';
class NotificationsPopup extends StatelessWidget {
  const NotificationsPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.notifications, color: Colors.black), // Custom icon
      onSelected: (item) => onSelected(context, item),
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: const [
              Icon(Icons.notification_important, color: Colors.black),
              SizedBox(width: 8),
              Text('Notification 1'),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: const [
              Icon(Icons.notification_important, color: Colors.black),
              SizedBox(width: 8),
              Text('Notification 2'),
            ],
          ),
        ),
      ],
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        print("Notification 1 Clicked");
        // Handle notification 1
        break;
      case 1:
        print("Notification 2 Clicked");
        // Handle notification 2
        break;
    }
  }
}

void onSelected(BuildContext context, int item) {
  switch (item) {
    case 0:
      print("Notification 1 Clicked");
      // Handle notification 1
      break;
    case 1:
      print("Notification 2 Clicked");
      // Handle notification 2
      break;
  }
}

// import 'package:flutter/material.dart';

void showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Settings'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Profile'),
              SizedBox(height: 10),
              Text('Logout'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
