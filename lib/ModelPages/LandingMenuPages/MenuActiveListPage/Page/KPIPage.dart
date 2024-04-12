import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class KPIPage extends StatefulWidget {
  const KPIPage({super.key});

  @override
  State<KPIPage> createState() => _KPIPageState();
}

class _KPIPageState extends State<KPIPage> {
  var _leaveExpanded = false;
  var _ticketExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.only(left: 40, top: 20, bottom: 20, right: 20),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: HexColor('EDF0F8')), borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(child: Image.asset('assets/images/axpert.png')),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Reporting To",
                          style: GoogleFonts.nunito(textStyle: TextStyle(fontSize: 12, color: HexColor('58658F')))),
                      SizedBox(height: 3),
                      Text(
                        "Vaidheesh",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: HexColor('58658F'))),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.only(left: 40, top: 20, bottom: 20, right: 20),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: HexColor('EDF0F8')), borderRadius: BorderRadius.circular(10)),
              child: Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    "Leave Details",
                    style: GoogleFonts.nunito(
                        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: HexColor('495057'))),
                  ),
                  onExpansionChanged: (value) {
                    setState(() {
                      _leaveExpanded = value;
                    });
                  },
                  trailing: Transform.rotate(
                    angle: !_leaveExpanded ? 0 : 180 * 3.17 / 180,
                    child: Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      size: 30,
                    ),
                  ),
                  children: [
                    SizedBox(height: 3),
                    Container(
                      height: 1,
                      color: Colors.grey.withOpacity(0.4),
                    ),
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text(
                            "Last Availed",
                            style: GoogleFonts.nunito(textStyle: TextStyle(fontSize: 12, color: HexColor('495057'))),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Jun 24",
                            style: GoogleFonts.nunito(
                                textStyle:
                                    TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: HexColor('3366FF'))),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Pending",
                            style: GoogleFonts.nunito(textStyle: TextStyle(fontSize: 12, color: HexColor('495057'))),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "04",
                            style: GoogleFonts.nunito(
                                textStyle:
                                    TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: HexColor('E3B113'))),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Casual Leave",
                            style: GoogleFonts.nunito(textStyle: TextStyle(fontSize: 12, color: HexColor('495057'))),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "12",
                            style: GoogleFonts.nunito(
                                textStyle:
                                    TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: HexColor('19AC81'))),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Available : 8",
                            style: GoogleFonts.nunito(textStyle: TextStyle(fontSize: 12, color: HexColor('495057'))),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.only(left: 40, top: 20, bottom: 20, right: 20),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: HexColor('EDF0F8')), borderRadius: BorderRadius.circular(10)),
              child: Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    "Ticket Details",
                    style: GoogleFonts.nunito(
                        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: HexColor('495057'))),
                  ),
                  onExpansionChanged: (value) {
                    setState(() {
                      _ticketExpanded = value;
                    });
                  },
                  trailing: Transform.rotate(
                    angle: !_ticketExpanded ? 0 : 180 * 3.17 / 180,
                    child: Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      size: 30,
                    ),
                  ),
                  children: [
                    SizedBox(height: 3),
                    Container(
                      height: 1,
                      color: Colors.grey.withOpacity(0.4),
                    ),
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.only(left: 15, right: 35),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "All Tickets",
                                    style: GoogleFonts.nunito(
                                        textStyle: TextStyle(fontSize: 12, color: HexColor('495057'))),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "14",
                                    style: GoogleFonts.nunito(
                                        textStyle: TextStyle(
                                            fontSize: 20, fontWeight: FontWeight.w800, color: HexColor('3366FF'))),
                                  ),
                                ],
                              ),
                              Expanded(child: Text("")),
                              Icon(Icons.domain_add_sharp),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Completed Task",
                                    style: GoogleFonts.nunito(
                                        textStyle: TextStyle(fontSize: 12, color: HexColor('495057'))),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "07",
                                    style: GoogleFonts.nunito(
                                        textStyle: TextStyle(
                                            fontSize: 20, fontWeight: FontWeight.w800, color: HexColor('E3B113'))),
                                  ),
                                ],
                              ),
                              Expanded(child: Text("")),
                              Icon(Icons.domain_add_sharp),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pending Task",
                                    style: GoogleFonts.nunito(
                                        textStyle: TextStyle(fontSize: 12, color: HexColor('495057'))),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "07",
                                    style: GoogleFonts.nunito(
                                        textStyle: TextStyle(
                                            fontSize: 20, fontWeight: FontWeight.w800, color: HexColor('19AC81'))),
                                  ),
                                ],
                              ),
                              Expanded(child: Text("")),
                              Icon(Icons.domain_add_sharp),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
