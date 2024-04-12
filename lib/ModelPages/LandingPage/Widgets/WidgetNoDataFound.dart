import 'package:flutter/material.dart';

class WidgetNoDataFound extends StatelessWidget {
  const WidgetNoDataFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/no_data_found.png",
              width: 300,
            ),
            Text(
              "No Data Available.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            Text(
              "There is no data to show you\nright now.",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
