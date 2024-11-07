import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../componen/ButtonSubmitWidget.dart';
import '../../../../componen/color.dart';
import '../../../../data/dummy_data.dart';
import '../../../../routes/app_pages.dart';

class DetailSpecialOffer extends StatefulWidget {
  @override
  State<DetailSpecialOffer> createState() => _DetailSpecialOfferState();
}

class _DetailSpecialOfferState extends State<DetailSpecialOffer> {
  late final String description;
  late final String nama;
  late final String image;

  final String phoneNumber = '081288835539';
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> arguments = Get.arguments;
    description = arguments['description'];
    nama = arguments['name'];
    image = arguments['image'];
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: ElevatedButton(
            onPressed: () async {
              String url = 'https://api.whatsapp.com/send/?phone=6281288835539&text&type=phone_number&app_absent=0';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.appPrimaryColor, // Ganti dengan warna yang sesuai
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/whatsapp.svg', width: 20),
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
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
                systemNavigationBarColor: Colors.transparent,
              ),
              backgroundColor: Colors.white,
              pinned: true,
              snap: false,
              floating: true,
              automaticallyImplyLeading: false,
              expandedHeight: 270,
              leading: Container(
                margin: const EdgeInsets.fromLTRB(15, 7, 0, 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Stack(
                    children: [
                      ArgumentsGambar(gambar: image,)
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  ArgumentsLokasi(
                    description: description,
                    nama: nama,
                  ),
                  // _SliderOffer(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _SliderOffer(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            pauseAutoPlayOnTouch: true,
            aspectRatio: 1.2,
            scrollDirection: Axis.horizontal,
            enableInfiniteScroll: true,
            viewportFraction: 0.5533,  // Kira-kira sepertiga
            enlargeCenterPage: false,  // Opsi ini memperbesar item di tengah
          ),
          items: dataProduct.map((product) {
            return Builder(
                builder: (BuildContext context) {
                  return InkWell(
                      onTap: () {
                        Get.toNamed(Routes.DETAILSPECIAL,
                            arguments:
                            {
                              'description': product['description'],
                              'name': product['name'],
                              'image': product['image'],
                            }
                        );
                      },
                      child:
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(product['image'], fit: BoxFit.cover, height: 120),
                            SizedBox(height: 20),
                            Text(product['name'], style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),

                            SizedBox(height: 10),
                            Row(children: [
                              Icon(Icons.star, color: Colors.yellow,),
                              SizedBox(width: 5,),
                              Text('4.9 ${product['terjual']} Terjual',style: GoogleFonts.nunito(color: Colors.grey),),
                            ],),
                            Row(children: [
                              Icon(Icons.shield_moon_rounded, color: Colors.green,),
                              SizedBox(width: 5,),
                              Text('Dilayani Bengkelly',style: GoogleFonts.nunito(color: Colors.grey),),
                            ],),
                          ],
                        ),
                      )
                  );
                }
            );
          }

          ).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class ArgumentsLokasi extends StatefulWidget {
  final String description;
  final String nama;

  const ArgumentsLokasi({Key? key, required this.description, required this.nama,}) : super(key: key);

  @override
  State<ArgumentsLokasi> createState() => _ArgumentsLokasiState();
}

class _ArgumentsLokasiState extends State<ArgumentsLokasi> {

  @override
  Widget build(BuildContext context) {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.nama, style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 17),),
                SizedBox(height: 10,),
                Text('Deskripsi', style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 17 ),),
                SizedBox(height: 10,),
                ExpandableText(
                  widget.description,
                  expandText: 'Lihat Selengkapnya',
                  collapseText: 'show less',
                  maxLines: 10,
                  linkColor: Colors.blue,
                ),
              ],),),
          SizedBox(height: 20,),
          // _sectionTitle('Spesialis Offer'),
        ],

      );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 17, color: MyColors.appPrimaryColor)),
          Text('Lihat Semua', style: GoogleFonts.nunito(color: Colors.grey)),
        ],
      ),
    );
  }

}

class ArgumentsGambar extends StatefulWidget {
  final String gambar;

  const ArgumentsGambar({Key? key,required this.gambar}) : super(key: key);

  @override
  State<ArgumentsGambar> createState() => _ArgumentsGambarState();
}

class _ArgumentsGambarState extends State<ArgumentsGambar> {

  @override
  Widget build(BuildContext context) {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(widget.gambar, fit: BoxFit.contain,),
        ],

      );
  }
}
class ArgumentsDiskon extends StatefulWidget {
  final String gambar;

  const ArgumentsDiskon({Key? key,required this.gambar}) : super(key: key);

  @override
  State<ArgumentsDiskon> createState() => _ArgumentsDiskonState();
}

class _ArgumentsDiskonState extends State<ArgumentsDiskon> {

  @override
  Widget build(BuildContext context) {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(widget.gambar, fit: BoxFit.contain,),
        ],

      );
  }
}