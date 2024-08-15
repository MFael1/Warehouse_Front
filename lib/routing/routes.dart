const rootRoute = "/";

const overviewPageDisplayName = "Overview";
const overviewPageRoute = "/overview";

const inboundPurchaseOrderPageDisplayName = " InboundOrder";
const inboundPurchaseOrderPageRoute = "/inboundPurchaseOrder";

const diplayinboundOrderPageDisplayName = " DisplayInboundOrder";
const displayinboundeOrderPageRoute = "/DisplayinboundOrder";

const outboundOrderPageDisplayName = " OutboundOrder";
const outboundOrderPageRoute = "/outboundOrder";

const displayoutboundOrderPageDisplayName = " Display out-bound Order";
const displayoutboundOrderPageRoute = "/displayoutboundOrder";

const itemAddingPageDisplayName = " Add  Item";
const itemAddingPageRoute = "/itemadding";

//!
const displayitemsPageDisplayName = " Display Items";
const displayitemsPageRoute = "/displayitems";

const itemMasterDataPageDisplayName = " Item Master Data";
const itemMasterDataPageRoute = "/itemMasterData";

const employeePageDisplayName = "Employee";
const employeePageRoute = "/employee";

const addEmployeePageDisplayName = "Add Employee";
const addEmployeePageRoute = "/addEmployee";

const displayCustomersPageDisplayName = "Display Customres";
const displayCustomersPageRoute = "/displaycustomer";

const displaySupplierPageDisplayName = "Display Supplier";
const displaySupplierPageRoute = "/displaysupplier";

const authenticationPageDisplayName = "Log out";
const authenticationPageRoute = "/auth";

class MenuItem {
  final String name;
  final String route;

  MenuItem(this.name, this.route);
}

List<MenuItem> sideMenuItemRoutes = [
  MenuItem(overviewPageDisplayName, overviewPageRoute),
  MenuItem(inboundPurchaseOrderPageDisplayName, inboundPurchaseOrderPageRoute),
  MenuItem(diplayinboundOrderPageDisplayName, displayinboundeOrderPageRoute),
  MenuItem(outboundOrderPageDisplayName, outboundOrderPageRoute),
  MenuItem(displayoutboundOrderPageDisplayName, displayoutboundOrderPageRoute),
  MenuItem(itemAddingPageDisplayName, itemAddingPageRoute),

  // !
  MenuItem(displayitemsPageDisplayName, displayitemsPageRoute),

  MenuItem(itemMasterDataPageDisplayName, itemMasterDataPageRoute),
  MenuItem(employeePageDisplayName, employeePageRoute),
  MenuItem(addEmployeePageDisplayName, addEmployeePageRoute),
  MenuItem(displayCustomersPageDisplayName, displayCustomersPageRoute),
  MenuItem(displaySupplierPageDisplayName, displaySupplierPageRoute),
  MenuItem(authenticationPageDisplayName, authenticationPageRoute),
];
