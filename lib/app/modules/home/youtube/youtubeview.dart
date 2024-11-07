import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../componen/color.dart';
import '../../../routes/app_pages.dart';

class YouTubeVideoList extends StatefulWidget {
  @override
  _YouTubeVideoListState createState() => _YouTubeVideoListState();
}

class _YouTubeVideoListState extends State<YouTubeVideoList> {
  late YoutubePlayerController _topController;
  final List<String> _videoIds = [
    'Qp_R6CYWK04',
    'R4KGpPis0Uw',
    'mnVbRVSbGVU',
    'C7lW2IlRZ4A',
    '6J9OVBFV53k',
    'u_NSaEvbJbo',
    'BsGdf3jKjok',
    'EzNRn36pHjE',
    'qHqsaZp5iTg',
    'e8otfhwsJEg',
  ];
  final List<String> _dummyTitles = [
    'WELCOME TO MY CHANNEL!',
    'FROM CIREBON TO GENERAL CHECK UP AT REAL AUTO WORKSHOP',
    '1st Anniversary Real Auto Benz Workshop Rebranding jadi Real Auto Workshop',
    'Review Jujur SMART BUYER Real Auto Benz | W205 C250 AMG 2016',
    'Mercedes-Benz S350 BATAL Flushing Oli Matic dan Harus OVERHAUL, KENAPA?',
    'JAUH-JAUH DARI SURABAYA KE REAL AUTO BENZ WORKSHOP',
    'Dari Surabaya ke Jakarta demi Tune-up All Perfect dan Premium Coating 3 Layers',
    'Segera Open for Book!! Rare Item W211 E320 CBU!!',
    'Parade Memecahkan Rekor 1000 Mercy Berkumpul di Sirkuit Sentul | Indonesia Auto Speed Festival 2023',
    'OPEN for BOOKED! Mercedes Benz E55 AMG Full Spect Kilometer 18ribu! Full Original! (REALDEAL)',
  ];
  final List<String> _dummyDescriptions = [
    'Di channel ini, kita akan ngebahas otomotif dan sharing seputar Mercedes-Benz. Bagi kamu penggemar Mercedes-Benz dan bidang otomotif apapun, ini adalah channel yang tepat banget buat kamu cari informasi.',
    'Ada pertanyaan seputar Mercedes-Benz dan atau bidang #otomotif lainnya? ',
    'Kami siap berkembang jadi lebih besar lagi! ',
    'Ada pertanyaan seputar Mercedes-Benz dan atau bidang #otomotif lainnya? ',
    'Dalam video kali ini Real Auto Benz akan menjelaskan alasan kenapa unit S350 ini harus dilakukan OVERHAUL. Tentu tidak semua keluhan harus dilakukan OVERHAUL, tapi ada saat kapan harus dilakuikan OVERHAUL dan kapan tidak harus dilakukan OVERHAUL.',
    'Kali ini ada Customer yang jauh2 datang dari Surabaya ke Real Auto Benz Workshop Jakarta untuk membuat perfect mercedes-benz nya.',
    'Mercedes-Benz V Class V260 milik Mas Adi yang datang jauh-jauh dari Surabaya ke Jakarta.',
    'Unit W211 E320 CBU yang akan kita open for book ini termasuk RARE ITEM! Bisa dihitung jari jumlahnya di Indonesia. Unit ini sudah kita sempurnakan dengan Tune Up All Perfect, gearbox matic overhaul total, oli mesin baru, oli matic baru, busi baru, dan kaki-kaki tidak ada PR. Dengan kaca double glass membuat mobil ini semakin senyap ketika dibawa berkendara.',
    'Rekor ini dipecahkan oleh Mercedes-Benz Club Indonesia, mulai dari E Class, C Class, S Class dari muda mau pun tua berkumpul jadi satu. tidak hanya 1000 tapi 1400 Mercy memenuhi Sirkuit Sentul.',
    'Open for Booked...Open for Booked... Open for Booked....Open for Booked',
  ];
  bool _isLoading = true;
  late VideoPlayerController _controllers;
  @override
  void initState() {
    super.initState();
    // _controllers = VideoPlayerController.asset('assets/video/infinix_video.mp4')
    //   ..initialize().then((_) {
    //     setState(() {}); // Update the UI when the video is initialized
    //   });
    // Future.delayed(Duration(seconds: 0), () {
    //   _showAdBottomSheet();
    // });
    _topController = YoutubePlayerController(
      initialVideoId: _videoIds[0],
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    // Simulate a delay to show the shimmer effect
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }
  void _showAdBottomSheet() {
    Get.bottomSheet(
      Container(
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: _controllers.value.aspectRatio,
                child: VideoPlayer(_controllers),
              ),
            ),
            TextButton(
                onPressed: () {
                  _controllers.pause(); // Pause the video when closing the bottom sheet
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
    _controllers.play(); // Play the video when the bottom sheet is shown
  }


  @override
  void dispose() {
    _topController.dispose();
    super.dispose();
  }

  String getThumbnail(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Youtube Channel',
          style: GoogleFonts.nunito(
            color: MyColors.appPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 250,
              child: Stack(
                children: [
                  YoutubePlayer(
                    controller: _topController,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.amber,
                  ),

                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _dummyTitles[0],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    _dummyDescriptions[0],
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            _isLoading ? _buildShimmerGrid() : _buildVideoGrid(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.75, // Adjust as needed
        ),
        itemCount: _videoIds.length,
        itemBuilder: (context, index) {
          return _buildShimmerItem();
        },
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.75, // Adjust as needed
        ),
        itemCount: _videoIds.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _topController.load(_videoIds[index]);
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20), topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(
                      getThumbnail(_videoIds[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _dummyTitles[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          _dummyDescriptions[index],
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}