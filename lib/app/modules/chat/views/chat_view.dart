import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../componen/color.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  int _currentIndex = 0;
  final List<String> imgList = [
    'assets/images/gamabar20.jpg',
    'assets/images/gamabar21.jpg',
    'assets/images/gamabar22.jpg',
    'assets/images/gamabar23.jpg',
  ];
  final String phoneNumber = '081288835539';
  void _launchPhoneCall(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunch(phoneLaunchUri.toString())) {
        await launch(phoneLaunchUri.toString());
      } else {
        final AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data: phoneLaunchUri.toString(),
        );
        await intent.launch();
      }
    } catch (e) {
      print('Error launching phone call: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // <-- SEE HERE
            statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
            statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
            systemNavigationBarColor:  Colors.transparent,
          ),
          elevation: 0,
          // leadingWidth: 45,
          actionsIconTheme: const IconThemeData(size: 20),
          backgroundColor: Colors.transparent,
          title: Text(
            'Help Center',
            style: GoogleFonts.nunito(fontWeight: FontWeight.bold,),
          ),
        ),
        body: Column(
          children: [
            _Slider(context),
            SizedBox(height: 10,),
            Text(
              'Karena Kami Memahami\nPentingnya Performa Mercedes-Benz Anda',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child:
              Text(
                'Datang Dan Buktikan Bagaimana Tim Kami Mampu Membuat Mercedes-Benz Anda Like NEW!, Tentunya Dengan Pengalaman Dan Dukungan Tim Profesional Kami.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: MyColors.appPrimaryDarkmod
              ),
              child: Column(
                children: [
                  SvgPicture.asset('assets/icons/merci.svg', width: 40),
                  SizedBox(height: 10,),
                  Text(
                    'PERFECT CONDITION',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    'Area Engine & Matic bukan hanya Full Tune Up biasa, melainkan pergantian menyeluruh pada area mesin & maticnya..Dengan Perfect Engine Smart Customers bisa benar-benar merasakan Performa yang Maksimal pada Unitnya.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          String url = 'https://api.whatsapp.com/send/?phone=6281288835539&text&type=phone_number&app_absent=0';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Ganti dengan warna yang sesuai
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 4.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/whatsapp2.svg', width: 20),
                            SizedBox(width: 10),
                            Text(
                              'WhatsApp',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10,),
                      ElevatedButton(
                        onPressed: () async {
                          _launchPhoneCall(phoneNumber);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Ganti dengan warna yang sesuai
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 4.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.call,color: Colors.white, ),
                            SizedBox(width: 10),
                            Text(
                              'Telephone',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        )
    );
  }

  Widget _Slider(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            pauseAutoPlayOnTouch: true,
            aspectRatio: 2.7,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: imgList.map((item) => Container(
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image:  AssetImage(item),
                fit: BoxFit.cover,
              ),
            ),
          )).toList(),
        ),
        const SizedBox(height: 10),
        Container(
          width: 145,
          decoration: BoxDecoration(
            color: MyColors.slider,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.map((url) {
              int index = imgList.indexOf(url);
              return Container(
                width: 19.0,
                height: 5.0,
                margin: EdgeInsets.symmetric(vertical: 7.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  shape: BoxShape.rectangle,
                  color: _currentIndex == index ? MyColors.appPrimaryColor : MyColors.slider,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}