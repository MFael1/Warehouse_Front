import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/pages/diplay_inbound_order/widgets/table_display_inbound_order.dart';
import 'package:get/get.dart';
import 'package:flutter_web_dashboard/constants/controllers.dart';
import 'package:flutter_web_dashboard/helpers/reponsiveness.dart';
import 'package:flutter_web_dashboard/widgets/custom_text.dart';

class displayINboundOrderPage extends StatelessWidget {
  const displayINboundOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                child: CustomText(
                  text: menuController.activeItem.value,
                  size: 24,
                  weight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              InboundOrderTable(),
            ],
          ),
        ),
      ],
    );
  }
}
