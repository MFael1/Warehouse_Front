import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/constants/style.dart';
import 'package:flutter_web_dashboard/routing/routes.dart';
import 'package:get/get.dart';

class MenuController extends GetxController {
  static MenuController instance = Get.find();
  var activeItem = overviewPageDisplayName.obs;

  var hoverItem = "".obs;

  changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  isHovering(String itemName) => hoverItem.value == itemName;

  isActive(String itemName) => activeItem.value == itemName;

  Widget returnIconFor(String itemName) {
    switch (itemName) {
      case overviewPageDisplayName:
        return _customIcon(Icons.trending_up, itemName);

      case inboundPurchaseOrderPageDisplayName:
        return _customIcon(Icons.file_download, itemName);

      case diplayinboundOrderPageDisplayName:
        return _customIcon(Icons.downhill_skiing_sharp, itemName);

      case outboundOrderPageDisplayName:
        return _customIcon(Icons.file_upload, itemName);

      case itemAddingPageDisplayName:
        return _customIcon(Icons.add_box_outlined, itemName);

      case displayitemsPageDisplayName:
        return _customIcon(Icons.add_box_outlined, itemName);

      case itemMasterDataPageDisplayName:
        return _customIcon(Icons.file_upload, itemName);

      case employeePageDisplayName:
        return _customIcon(Icons.people_alt_outlined, itemName);

      case addEmployeePageDisplayName:
        return _customIcon(Icons.person_add_alt_rounded, itemName);

      case displayCustomersPageDisplayName:
        return _customIcon(Icons.currency_bitcoin_sharp, itemName);

      case displaySupplierPageDisplayName:
        return _customIcon(Icons.train, itemName);

      case authenticationPageDisplayName:
        return _customIcon(Icons.exit_to_app, itemName);
      default:
        return _customIcon(Icons.exit_to_app, itemName);
    }
  }

  Widget _customIcon(IconData icon, String itemName) {
    if (isActive(itemName)) return Icon(icon, size: 22, color: dark);

    return Icon(
      icon,
      color: isHovering(itemName) ? dark : lightGrey,
    );
  }
}
