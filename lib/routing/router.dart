import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/pages/Item_master/add_item_master.dart';
import 'package:flutter_web_dashboard/pages/OutboundOrderScreen/OutboundOrderScreen.dart';
import 'package:flutter_web_dashboard/pages/add_item/add_item.dart';
import 'package:flutter_web_dashboard/pages/diplay_inbound_order/diplay_inbound_order.dart';
import 'package:flutter_web_dashboard/pages/display_items/display_item.dart';
import 'package:flutter_web_dashboard/pages/display_out_order/display_out_order.dart';
import 'package:flutter_web_dashboard/pages/overview/overview.dart';
import 'package:flutter_web_dashboard/pages/EmployeePage/Employee.dart';
import 'package:flutter_web_dashboard/pages/adding_employee/adding_employee.dart';
import 'package:flutter_web_dashboard/pages/inboundPurchaseOrder/inboundPurchaseOrder.dart';

import 'package:flutter_web_dashboard/pages/customer/display_customer.dart';
import 'package:flutter_web_dashboard/pages/supplier/display_supplier.dart';
import 'package:flutter_web_dashboard/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case overviewPageRoute:
      return _getPageRoute(const OverviewPage());

    case inboundPurchaseOrderPageRoute:
      return _getPageRoute(InboundPurchaseOrderScreen());

    case displayinboundeOrderPageRoute:
      return _getPageRoute(displayINboundOrderPage());

    case outboundOrderPageRoute:
      return _getPageRoute(OutboundOrderScreen());

    case displayoutboundOrderPageRoute:
      return _getPageRoute(DisplayOUTorderPage());

    case itemAddingPageRoute:
      return _getPageRoute(AddItemPage());

    case displayitemsPageRoute:
      return _getPageRoute(DisplayItems());

    case itemMasterDataPageRoute:
      return _getPageRoute(ItemMaterFormPage());

    case employeePageRoute:
      return _getPageRoute(const EmployeePage());
    case addEmployeePageRoute:
      return _getPageRoute(const AddEmployee());

    case displayCustomersPageRoute:
      return _getPageRoute(const display_customers());

    case displaySupplierPageRoute:
      return _getPageRoute(const display_supplier());

    default:
      return _getPageRoute(const OverviewPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
