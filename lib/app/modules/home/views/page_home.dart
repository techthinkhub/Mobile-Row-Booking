import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:customer_bengkelly/app/componen/color.dart';
import 'package:customer_bengkelly/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:video_player/video_player.dart';

import '../../../data/data_endpoint/news.dart';
import '../../../data/dummy_data.dart';
import '../../../data/endpoint.dart';
import '../../news/componen/news.dart';
import '../../news/componen/todaydeals.dart';
import '../controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Get.put(HomeController());
  String _currentAddress = 'Mengambil lokasi...';
  int _currentIndex = 0;
  Position? _currentPosition;
  final List<String> imgList = [
    'assets/images/sliderrealbenz1.jpeg',
    'assets/images/sliderrealbenz2.jpeg',
    'assets/images/sliderrealbenz3.jpeg',
    'assets/images/sliderrealbenz4.jpeg',
    'assets/images/sliderrealbenz5.jpeg',
    'assets/images/sliderrealbenz6.jpeg',
    'assets/images/sliderrealbenz7.jpeg',
    'assets/images/sliderrealbenz8.jpeg',
  ];
  late RefreshController _refreshController;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _refreshController =
        RefreshController();
    _checkPermissions();
    _checkPermissionsfile();
    _requestNotificationPermission();
    _initializeNotifications();
    // _controller = VideoPlayerController.asset('assets/video/infinix_video.mp4')
    //   ..initialize().then((_) {
    //     setState(() {});
    //   });
    Future.delayed(Duration(seconds: 5), () {
      _showAdBottomSheet();
    });
  }
  Future<void> _requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }
  void _showAdBottomSheet() {
    Get.bottomSheet(
      Container(
        height: 260,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
            TextButton(
                onPressed: () {
                  _controller.pause(); // Pause the video when closing the bottom sheet
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100)
                  ),
                  child:  Icon(Icons.close,color: Colors.white,),
                )
            ),
          ],
        ),
      ),
      isDismissible: true,
      backgroundColor: Colors.transparent,
    );
    _controller.play(); // Play the video when the bottom sheet is shown
  }
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  Future<void> _checkPermissions() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      await _getCurrentLocation();
    } else {
      var requestedStatus = await Permission.location.request();
      if (requestedStatus.isGranted) {
        await _getCurrentLocation();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Permission denied'),
        ));
      }
    }
  }
  Future<void> _checkPermissionsfile() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
    } else {
      var requestedStatus = await Permission.storage.request();
      if (requestedStatus.isGranted) {
      } else {
      }
    }
  }
  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print('Current position: $_currentPosition');
      _getAddressFromLatLng();
      setState(() {});
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.subAdministrativeArea}";
      });
    } catch (e) {
      print('Error getting address: $e');
    }
  }
  void _CommingSoon(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: MyColors.appPrimaryDarkmod
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 40,),
              Text('Comming Soon', style: GoogleFonts.nunito(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
              Image.asset(
                'assets/logo/logo_autobenz2.png',
                width: 100.0,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 40,)
            ],
          ),
        );
      },
    );
  }
  final limitedProducts = dataProduct.take(2).toList();

  @override
  Widget build(BuildContext context) {
    controller.checkForUpdate();
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: MyColors.appPrimaryColor,
          ),
          title: Row(
            children: [
              SvgPicture.asset('assets/icons/lokasi.svg', width: 26),
              SizedBox(width: 10),
              Expanded( // Gunakan Expanded atau Flexible di sini
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lokasi Saat ini', style: GoogleFonts.nunito(fontSize: 12)),
                    Text(
                      _currentAddress,
                      style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.CHAT);
                  },
                  child:
                  SvgPicture.asset('assets/icons/massage.svg', width: 26,),),
                SizedBox(width: 20,),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.NOTIFIKASI);
                  },
                  child: SvgPicture.asset('assets/icons/notif.svg', width: 26),
                ),
                SizedBox(width: 10),
              ],
            ),
          ],
        ),

        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          header: const WaterDropHeader(),
          onLoading: _onLoading,
          onRefresh: _onRefresh,
          child:
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 475),
                childAnimationBuilder: (widget) => SlideAnimation(
                  child: SlideAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  _Slider(context),
                  SizedBox(height: 20),
                  _sectionTitle2('Menu'),
                  SizedBox(height: 20),
                  _menuItemsRow(),
                  SizedBox(height: 20),
                  _sectionTitle1('Special Offer'),
                  SizedBox(height: 20),
                  _SliderOffer(context),
                  SizedBox(height: 20),
                  _sectionTitle3('Today Deals'),
                  SizedBox(height: 20),
                  _todaydeals(context),
                ],
              ),
            ),
          ),
        ),
      ),
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
          width: 200,
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

  Widget _menuItemsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _menuItemHelp(() => Get.toNamed(Routes.EmergencyBookingView), 'assets/icons/help.png', "Emergency\nService"),
        _menuItem(() => Get.toNamed(Routes.BOOKING), 'assets/icons/bookingservice.png', "Booking\nService"),
        _menuItem(() => Get.toNamed(Routes.PLANNING_SERVICE), 'assets/icons/repear.png', "Planing\nService"),
        _menuItembenz(() => _CommingSoon(context), 'assets/logo/logo_community.jpeg', "Community\n"),
      ],
    );
  }
  Widget _menuItemsRow2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _menuItemCharger(() => Get.toNamed(Routes.LOKASILISTRIK), 'assets/icons/dropcar2.png', "Recharge \n Stasiun"),
        SizedBox(width: 10,),
        _menuItemCharger(() =>null, null,''),
        _menuItemCharger(() =>null, null,''),
        _menuItemCharger(() =>null, null,''),
      ],
    );
  }

  Widget _menuItem( VoidCallback onTap, String iconPath, String label,) {
    return InkWell(
      onTap: onTap,
      child:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(iconPath, width: 50),
          SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: GoogleFonts.nunito(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  Widget _menuItembenz( VoidCallback onTap, String iconPath, String label,) {
    return InkWell(
      onTap: onTap,
      child:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: MyColors.bgform,
                borderRadius: BorderRadius.all(Radius.circular(200))
            ),
            child:
            Image.asset(iconPath, width: 50),),
          SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: GoogleFonts.nunito(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  Widget _menuItemHelp(VoidCallback onTap, String iconPath, String label,) {
    return InkWell(
      onTap: onTap,
      child:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(iconPath, width: 50),
          SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: GoogleFonts.nunito(color: Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  Widget _menuItemCharger(VoidCallback onTap, String? iconPath, String? label) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (iconPath != null)
            Image.asset(iconPath, width: 50)
          else
            SizedBox(width: 50, height: 50), // Placeholder if no icon
          SizedBox(height: 8),
          if (label != null)
            Text(label, textAlign: TextAlign.center, style: GoogleFonts.nunito(color: Colors.blue, fontWeight: FontWeight.bold))
          else
            Text('', textAlign: TextAlign.center, style: GoogleFonts.nunito(color: Colors.green, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 17, color: MyColors.appPrimaryColor)),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.SEMUALOKASIBENGKELLY);
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: MyColors.bgform,
              ),
              child:
              Text('Lihat Semua', style: GoogleFonts.nunito(color: Colors.grey, fontWeight: FontWeight.bold)),),
          ),
        ],
      ),
    );
  }
  Widget _sectionTitle3(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 17, color: MyColors.appPrimaryColor)),
          SlideCountdownSeparated(
            duration: const Duration(days: 1),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10)
            ),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.LihatSemuaToday);
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: MyColors.bgform,
              ),
              child:
              Text('Lihat Semua', style: GoogleFonts.nunito(color: Colors.grey, fontWeight: FontWeight.bold)),),
          ),
        ],
      ),
    );
  }
  Widget _sectionTitle1(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 17, color: MyColors.appPrimaryColor)),
          SlideCountdownSeparated(
            duration: const Duration(days: 1),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10)
            ),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.LIHATSEMUASPESIALIS);
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: MyColors.bgform,
              ),
              child:
              Text('Lihat Semua', style: GoogleFonts.nunito(color: Colors.grey, fontWeight: FontWeight.bold)),),
          ),
        ],
      ),
    );
  }
  Widget _sectionTitle4(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 17, color: MyColors.appPrimaryColor)),
        ],
      ),
    );
  }
  Widget _sectionTitle2(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 17, color: MyColors.appPrimaryColor)),
        ],
      ),
    );
  }
  // Widget _item(String title) {
  //   return const Row(
  //     children: [
  //       Con
  //     ],
  //   );
  // }
  Widget _SliderLokasi(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            pauseAutoPlayOnTouch: true,
            aspectRatio: 2.7,
          ),
          items: restAreaPlace.map((area) {
            return Builder(
                builder: (BuildContext context) {
                  return InkWell(
                    onTap: () {
                      Get.toNamed(Routes.DETAILLOKASIBENGKELLY,
                          arguments:
                          {
                            'id': area['id'],
                            'description': area['description'],
                            'name': area['name'],
                            'sliderImages': area['sliderImages'],
                          }
                      );
                    },
                    child:
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(right: 10, top: 20, bottom: 20),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(children: [
                              ClipOval(
                                child:  Image.asset(
                                    area['logo'],
                                    fit: BoxFit.cover,
                                    height: 50,
                                    width: 50),
                              ),
                              SizedBox(width: 10),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(area['name'], style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
                                    Text(area['address'], style: GoogleFonts.nunito(fontWeight: FontWeight.normal)),
                                    SizedBox(height: 10,),
                                    SvgPicture.asset('assets/icons/icond.svg', width: 60,),
                                  ]
                              )
                            ])
                          ]
                      ),
                    ),
                  );
                }
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
  Widget _todaydeals(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GridView.builder(
                padding: const EdgeInsets.all(10.0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth < 600 ? 2 : 4,
                  crossAxisSpacing: 9,
                  mainAxisSpacing: 0.9,
                  childAspectRatio: 0.56,
                ),
                itemCount: dataProduct2.length,
                itemBuilder: (context, index) {
                  final product = dataProduct2[index];
                  return InkWell(
                    onTap: () {
                      Get.toNamed(Routes.DETAILSPECIAL,
                          arguments:
                          {
                            'description': product['description'],
                            'name': product['name'],
                            'image': product['image'],
                            'Harga': product['Harga'],
                            'harga_asli': product['harga_asli'],
                            'diskon': product['diskon'],
                          }
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 475),
                            childAnimationBuilder: (widget) => SlideAnimation(
                              child: SlideAnimation(
                                child: widget,
                              ),
                            ),
                            children: [
                              Image.asset(product['image'], fit: BoxFit.cover, height: 120, width: double.infinity),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(product['name'], style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.yellow),
                                        SizedBox(width: 5),
                                        Text('4.9 ${product['terjual']} Terjual', style: GoogleFonts.nunito(color: Colors.grey)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.shield_moon_rounded, color: Colors.green),
                                        SizedBox(width: 5),
                                        Text('Dilayani RealAuto', style: GoogleFonts.nunito(color: Colors.grey)),
                                      ],
                                    ),
                                  ],),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _SliderOffer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: limitedProducts.map((product) {
        return Expanded(
          child: InkWell(
            onTap: () {
              Get.toNamed(Routes.DETAILSPECIAL, arguments: {
                'description': product['description'],
                'name': product['name'],
                'image': product['image'],
                'Harga': product['Harga'],
                'harga_asli': product['harga_asli'],
                'diskon': product['diskon'],
              });
            },
            child: Container(
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
                  Image.asset(
                    product['image'],
                    fit: BoxFit.cover,
                    height: 120,
                    width: double.infinity,
                  ),
                  SizedBox(height: 20),
                  Text(
                    product['name'],
                    style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      SizedBox(width: 5),
                      Text(
                        '4.9 ${product['terjual']} Terjual',
                        style: GoogleFonts.nunito(color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.shield_moon_rounded, color: Colors.green),
                      SizedBox(width: 5),
                      Text(
                        'Dilayani RealAuto',
                        style: GoogleFonts.nunito(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  _onLoading() {
    _refreshController
        .loadComplete(); // after data returned,set the //footer state to idle
  }

  _onRefresh() {
    HapticFeedback.lightImpact();
    setState(() {

      HomePage();
      _refreshController
          .refreshCompleted();
    });
  }
}
