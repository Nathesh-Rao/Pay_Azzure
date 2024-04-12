import 'package:axpertflutter/ModelPages/LandingPage/Models/FirebaseMessageModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetNotification extends StatelessWidget {
  WidgetNotification(FirebaseMessageModel this.model, {super.key});
  final FirebaseMessageModel model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        child: Row(
          children: [
            Image.asset(
              'assets/images/announce2.png',
              width: 50,
              height: 50,
            ),
            SizedBox(width: 25),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 15),
                  Text(
                    model.body,
                    maxLines: 3,
                    style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
