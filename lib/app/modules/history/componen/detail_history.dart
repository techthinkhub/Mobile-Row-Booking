import 'dart:async';
import 'package:customer_bengkelly/app/modules/history/componen/view_image.dart';
import 'package:customer_bengkelly/app/modules/history/componen/view_image_stnk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../../../componen/color.dart';
import '../../../data/data_endpoint/generalcekup.dart';
import '../../../data/data_endpoint/jamistimasi.dart';
import '../../../data/endpoint.dart';
import '../../../widgets/timeline.dart';
import '../../../widgets/timeline_title.dart';
import '../../../widgets/widget_timeline_wrapper.dart';
import 'jamestimasi.dart';
import 'lisjamestimasi.dart';
import 'lisjamestimasiselesai.dart';
import 'listhistory.dart';
import 'listselesai.dart';

class DetailHistory extends StatefulWidget {
  const DetailHistory({super.key});

  @override
  _DetailHistoryState createState() => _DetailHistoryState();
}

class _DetailHistoryState extends State<DetailHistory> {
  late final RefreshController _refreshController;
  late Future<GeneralCheckup> futureGeneralCheckup;
  List<String> statusList = [
    'Booking',
    'Approve',
    'Diproses',
    'Estimasi',
    'PKB',
    'PKB Tutup',
    'Selesai Dikerjakan',
    'Invoice',
    'Lunas',
    'Ditolak'
  ];
  List<String> completedStatuses = [];
  List<String> completedStatusestypeorder = [];
  String currentStatus = '';
  late String id;
  late Map args;
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> statusKeys = {};

  @override
  void initState() {
    _refreshController = RefreshController();
    super.initState();
    futureGeneralCheckup = API.GCMekanikID(kategoriKendaraanId: '1');
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      loadStatus();
    });

    for (var status in statusList) {
      statusKeys[status] = GlobalKey();
    }
  }

  void loadStatus() async {
    final arguments = ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, dynamic>;
    id = arguments['id'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedStatuses = prefs.getStringList('completed_statuses_$id');
    if (savedStatuses != null && savedStatuses.isNotEmpty) {
      setState(() {
        completedStatuses = savedStatuses;
        currentStatus = completedStatuses.last;
      });

      int lunasIndex = completedStatuses.indexOf('Lunas');
      if (lunasIndex != -1 && lunasIndex > 0) {
        for (int i = 0; i < lunasIndex; i++) {
          if (!completedStatuses.contains(statusList[i])) {
            completedStatuses.add(statusList[i]);
          }
        }
        completedStatuses.sort((a, b) =>
            statusList.indexOf(a).compareTo(statusList.indexOf(b)));
      }
    } else {
      setState(() {
        currentStatus = statusList.first;
      });
    }
    checkAndUpdateStatus(arguments);
  }

  void checkAndUpdateStatus(Map<String, dynamic> arguments) async {
    final String newStatus = arguments['nama_status'];
    if (!completedStatuses.contains(newStatus)) {
      updateStatus(newStatus);
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollToStatus(newStatus);
    });
  }

  void updateStatus(String newStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!completedStatuses.contains(newStatus)) {
      completedStatuses.add(newStatus);
      await prefs.setStringList('completed_statuses_$id', completedStatuses);
    }
    setState(() {
      currentStatus = newStatus;
    });
  }

  void scrollToStatus(String status) {
    final key = statusKeys[status];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: Duration(milliseconds: 500),
        alignment: 0.5,
      );
    }
  }

  Color getStatusColor(String status) {
    bool isCompleted = completedStatuses.contains(status);
    if (isCompleted) {
      switch (status) {
        case 'Booking':
        case 'Approve':
        case 'Diproses':
        case 'Estimasi':
        case 'PKB':
        case 'PKB Tutup':
        case 'Selesai Dikerjakan':
          return MyColors.appPrimaryColor;
        case 'Invoice':
          return Colors.green;
        case 'Lunas':
          return Colors.blue;
        case 'Ditolak':
          return MyColors.redEmergencyMenu;
        default:
          return Colors.grey.shade200;
      }
    } else {
      return Colors.grey.shade200;
    }
  }

  Color getStatusColorTypeOrder(String typeorder) {
    bool isCompleted = completedStatusestypeorder.contains(typeorder);

    if (isCompleted) {
      switch (typeorder) {
        case 'Emergency Service':
          return Colors.red;
        case 'Booking Service':
          return Colors.green;
        default:
          return Colors.grey.shade300;
      }
    } else {
      return Colors.grey.shade200;
    }
  }

  Color getStatusColorarg(String status) {
    bool isCompleted = completedStatuses.contains(status);
    if (isCompleted) {
      switch (status) {
        case 'Booking':
          return Colors.blue;
        case 'Approve':
          return Colors.green;
        case 'Diproses':
          return Colors.orange;
        case 'Estimasi':
          return Colors.lime;
        case 'Selesai Dikerjakan':
          return Colors.blue;
        case 'PKB':
          return Colors.green;
        case 'PKB Tutup':
          return Colors.deepOrangeAccent;
        case 'Invoice':
          return Colors.blueAccent;
        case 'Lunas':
          return Colors.lightBlue;
        case 'Ditolak By Sistem':
          return Colors.grey;
        case 'Ditolak':
          return Colors.red;
        default:
          return Colors.transparent;
      }
    } else {
      return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final List<String> mediaUrls = arguments['media_urls']?.cast<String>() ??
        [];
    final String alamat = arguments['alamat'];
    final String restarea = arguments['nama_cabang'];
    final String nopol = arguments['no_polisi'];
    final String kodebooking = arguments['kode_booking'];
    final String photostnk = arguments['photo_stnk'] ?? "";
    final List<String> mediaUrlssstnk = photostnk.isNotEmpty ? [photostnk] : [];
    final String vinnomber = arguments['vin_number'];
    final String status = arguments['nama_status'];
    final String typeorder = arguments['type_order'];
    final String namajenissvc = arguments['nama_jenissvc'];
    final List<dynamic> jasa = arguments['jasa'];
    final List<dynamic> part = arguments['part'];
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double padding = screenWidth * 0.02;

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: _buildAppBar(status),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: CustomScrollView(
          slivers: [
            _buildDetailSection(
                namajenissvc, kodebooking, vinnomber, typeorder, status),
            _buildMediaSection(mediaUrls),
            _buildMediaSectionsNTK(mediaUrlssstnk ),
            _buildStatusSection(nopol, kodebooking),
            _buildServiceProsesSection(restarea, alamat, nopol, jasa, part),
            if (namajenissvc ==
                'General Check UP/P2H') _buildGeneralCheckUpSection(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(String status) {
    return AppBar(
      forceMaterialTransparency: true,
      elevation: 5,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
      title: Text(
        'Rincian Service',
        style: GoogleFonts.nunito(
            color: MyColors.appPrimaryColor, fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
    );
  }

  SliverToBoxAdapter _buildDetailSection(
      String namajenissvc,
      String kodebooking,
      String vinnomber,
      String typeorder,
      String status) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                namajenissvc,
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MyColors.appPrimaryColor,
                ),
              ),
            ),

            // Image Section
            Container(
              width: double.infinity,
              height: 200,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage('assets/images/bghistory.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detail',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildDetailRow('Kode Booking', kodebooking),
                  _buildDetailRow('Vin Number', vinnomber),
                  _buildDetailRow('Type Order', typeorder),
                  SizedBox(height: 10),
                  _buildStatusRow(status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$label',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 4), // Space between label and colon
          Text(
            ':',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          SizedBox(width: 4), // Space between colon and value
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/logo_nenz.png', // Replace with your image asset path
          width: 84, // Adjust the size as needed
          height: 44, // Adjust the size as needed
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: getStatusColorarg(status),
          ),
          child: Text(
            status,
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }



  SliverToBoxAdapter _buildMediaSectionsNTK(List<String> mediaUrls) {
    if (mediaUrls.isEmpty) {
      return SliverToBoxAdapter(
          child: Container());
    }

    if (mediaUrls.length == 1) {
      final url = mediaUrls.first;

      return SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child : Text(
                'Photo STNK',
                style: GoogleFonts.nunito(
                    fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.3, // Adjust height as needed
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ImagePreviewPage(mediaUrls: mediaUrls),
                    ),
                  );
                },
                child: url.endsWith('.mp4')
                    ? VideoPlayerWidget(
                    url: url) // Use the custom video player widget
                    : Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      );
    }

    // Multiple media items
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(4.0),
        height: MediaQuery.of(context).size.width / 4 * 2, // Adjust height as needed
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 3, // Adjust based on screen width
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            childAspectRatio: 1.0,
          ),
          itemCount: mediaUrls.length,
          itemBuilder: (context, index) {
            final url = mediaUrls[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImagePreviewPage(mediaUrls: mediaUrls),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: url.endsWith('.mp4')
                    ? VideoThumbnailWidget(url: url) // Use the custom video thumbnail widget
                    : Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Text('Failed to load image'));
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildMediaSection(List<String> mediaUrls) {
    if (mediaUrls.isEmpty) {
      return SliverToBoxAdapter(child: Center());
    }

    if (mediaUrls.length == 1) {
      final url = mediaUrls.first;
      return SliverToBoxAdapter(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3, // Adjust height as needed
              width: double.infinity,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImagePreviewPage(mediaUrls: mediaUrls),
                      ),
                    );
                  },
                  child: url.endsWith('.mp4')
                      ? VideoPlayerWidget(url: url) // Use the custom video player widget
                      : Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
              ),
            ),
          ],
        ),
      );
    }

    // Multiple media items
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(4.0),
        height: MediaQuery.of(context).size.width / 4 * 2, // Adjust height as needed
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 3, // Adjust based on screen width
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            childAspectRatio: 1.0,
          ),
          itemCount: mediaUrls.length,
          itemBuilder: (context, index) {
            final url = mediaUrls[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImagePreviewPage(mediaUrls: mediaUrls),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: url.endsWith('.mp4')
                    ? VideoThumbnailWidget(url: url) // Use the custom video thumbnail widget
                    : Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Text('Failed to load image'));
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }



  SliverToBoxAdapter _buildStatusSection( String? nopol, String? kodebooking) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                  color: MyColors.appPrimaryColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
              ),
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(children: [
                       Icon(Icons.calendar_month_rounded, color: Colors. white,),
                        SizedBox(width: 10,),
                        Text(
                          'Tanggal Keluar : ',
                          style: GoogleFonts.nunito(
                              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        FutureBuilder(
                          future: API.jamestimasiID(
                            nopolisi: nopol ?? "",
                            kodebooking: kodebooking ?? "",
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              print('Error: ${snapshot.error}');
                              return Center(child: Text(''));
                            } else if (snapshot.hasData) {
                              Jamistimasi getDataAcc = snapshot.data as Jamistimasi;
                              if (getDataAcc.estimasi != null) {
                                return Column(
                                  children: getDataAcc.estimasi!.map((e) {
                                    return ListjamEstimasi(booking: e);
                                  }).toList(),
                                );
                              } else {
                                return Center(child: Text(''));
                              }
                            } else {
                              return Center(child: Text(''));
                            }
                          },
                        ),

                      ],
                      ),
                        ],
                      ),
                  Row(
                    children: [
                      Row(children: [
                        Icon(Icons.timelapse_rounded, color: Colors. white,),
                        SizedBox(width: 10,),
                        Text(
                          'Estimasi Mobil Selesai : ',
                          style: GoogleFonts.nunito(
                              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        FutureBuilder(
                          future: API.jamestimasiID(
                            nopolisi: nopol ?? "",
                            kodebooking: kodebooking ?? "",
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              print('Error: ${snapshot.error}');
                              return Center(child: Text(''));
                            } else if (snapshot.hasData) {
                              Jamistimasi getDataAcc = snapshot.data as Jamistimasi;
                              if (getDataAcc.estimasi != null) {
                                return Column(
                                  children: getDataAcc.estimasi!.map((e) {
                                    return Listjam(booking: e);
                                  }).toList(),
                                );
                              } else {
                                return Center(child: Text(''));
                              }
                            } else {
                              return Center(child: Text(''));
                            }
                          },
                        ),
                      ],),
                    ],
                  ),
                  Divider(),
                  FutureBuilder(
                    future: API.jamestimasiID(
                      nopolisi: nopol ?? "",
                      kodebooking: kodebooking ?? "",
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        print('Error: ${snapshot.error}');
                        return Center(child: Text('Error occurred'));
                      } else if (snapshot.hasData) {
                        Jamistimasi getDataAcc = snapshot.data as Jamistimasi;
                        if (getDataAcc.estimasi != null && getDataAcc.estimasi!.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: getDataAcc.estimasi!.map((e) {
                              return ListSelesai(booking: e);
                            }).toList(),
                          );
                        } else {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.car_crash_rounded, color: Colors. white,),
                                    SizedBox(width: 10,),
                                  Text('Selesai : Proses Pengerjaan',style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),),
                                  ],
                                )

                              ]
                          );
                        }
                      } else {
                        return Center(child: Text('No data available'));
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text('Status Proses', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: statusList.map((status) {
                  bool isCompleted = completedStatuses.contains(status);
                  return Row(
                    key: statusKeys[status],
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: getStatusColor(status),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: isCompleted ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isCompleted)
                        Icon(Icons.check_circle_rounded, color: getStatusColor(status))
                      else
                        SizedBox(width: 24), // Placeholder for the check icon if not completed
                    ],
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildServiceProsesSection(String restarea, String alamat, String nopol, List<dynamic> jasa, List<dynamic> part) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(10),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Service Proses', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text('No Polisi: ', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        '$nopol',
                        style: GoogleFonts.nunito(fontWeight: FontWeight.normal, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            WidgetTimelinetitle(
              icon: Icons.location_on_rounded,
              bgcolor: MyColors.appPrimaryColor,
              title1: restarea,
              title2: alamat,
              time: "",
              showCard: false,
            ),
            WidgetTimeline(
              icon: Icons.note_alt,
              bgcolor: MyColors.grey,
              title1: "Detail Jasa",
              title2: "Jasa Perbaikan Kendaraan",
              time: "",
              showCard: true,
              jasa: jasa,
            ),
            WidgetTimeline(
              icon: Icons.settings,
              bgcolor: MyColors.grey,
              title1: "Detail Part",
              title2: "Sparepart yang diganti",
              time: "",
              showCard2: true,
              part: part,
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildGeneralCheckUpSection() {
    return SliverToBoxAdapter(
      child: FutureBuilder<GeneralCheckup>(
        future: futureGeneralCheckup,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data == null) {
            return Center();
          }
          final data = snapshot.data!.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return ExpansionTile(
                title: Text(item.subHeading ?? 'No subheading'),
                children: item.gcus?.map((gcu) {
                  return ListTile(
                    title: Text(gcu.gcu ?? 'No GCU'),
                  );
                }).toList() ?? [],
              );
            },
          );
        },
      ),
    );
  }



  _onLoading() {
    _refreshController.loadComplete(); // after data returned,set the //footer state to idle
  }

  _onRefresh() {
    HapticFeedback.lightImpact();
    setState(() {
      _refreshController.refreshCompleted();
    });
  }
}

class VideoThumbnailWidget extends StatelessWidget {
  final String url;

  VideoThumbnailWidget({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }
}


class VideoPlayerWidget extends StatefulWidget {
  final String url;

  VideoPlayerWidget({required this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {}); // Refresh the widget when the video is initialized
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
