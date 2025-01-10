import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Models/BannerModel.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Models/FirebaseMessageModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetBanner extends StatelessWidget {
  WidgetBanner(BannerModel this.model, {super.key});

  final BannerModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: model.image.toString(),
                  placeholder: (context, url) => Container(
                    width: 50, // Desired width
                    height: 50, // Desired height
                    alignment: Alignment.center,
                    child:CupertinoActivityIndicator(color: Colors.blueGrey),// CircularProgressIndicator.adaptive(backgroundColor: Colors.black12,),
                  ), // Loading indicator
                  errorWidget: (context, url, error) => Image.asset('assets/images/default_bannerImage.jpg',fit: BoxFit.fill,), // Error icon if loading fails
                  fit: BoxFit.cover,
                ),

                //Image.network(model.image.toString(), fit: BoxFit.fill),
                Align(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.title.toString(),
                          style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white)),
                        ),
                        SizedBox(height: 15),
                        Text(
                          model.description.toString(),
                          maxLines: 3,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500, wordSpacing: 0.8)),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
