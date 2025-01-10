import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetMenuFolderPanelBottomSheet extends StatelessWidget {
  const WidgetMenuFolderPanelBottomSheet({super.key, required this.baseItems});
  final List<Widget> baseItems;

  @override
  Widget build(BuildContext context) {
    final double maxHeight = _getBottomSheetHeight(context: context);

    return Container(
      height: maxHeight,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(20))),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Spacer(),
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.cancel)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: GridView.builder(
                itemCount: baseItems.length,
                // physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 15),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (context, index) {
                  return baseItems[index];
                }),
          )
        ],
      ),
    );
  }

  double _getBottomSheetHeight({required BuildContext context}) {
    if (baseItems.length <= 12) {
      return MediaQuery.of(context).size.width - 30;
    } else if (baseItems.length > 20) {
      return MediaQuery.of(context).size.height * 0.75;
    } else {
      var width = MediaQuery.of(context).size.width - 30;
      width = width + width / 2;
      return width;
    }
  }
}
