import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Page/CompletedListPage.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Page/PendingListPage.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetSlidingNotification.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MenuActiveListPage extends StatelessWidget {
  MenuActiveListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetSlidingNotificationPanel(),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                indicatorColor: HexColor("1970FF"),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: HexColor('FD9700'),
                            border: Border.all(width: 1, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Pending",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        )
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: HexColor('5AC686'),
                            border: Border.all(width: 1, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Completed",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        )
                      ],
                    ),
                  ),
                  // Tab(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Icon(Icons.settings),
                  //       SizedBox(width: 10),
                  //       Text(
                  //         "KPI",
                  //         style: TextStyle(
                  //           fontSize: 13,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              body: TabBarView(
                children: [
                  PendingListPage(),
                  CompletedListPage(),
                  // KPIPage(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
