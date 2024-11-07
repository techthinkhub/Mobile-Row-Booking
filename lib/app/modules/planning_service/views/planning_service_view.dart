import 'package:customer_bengkelly/app/data/endpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:search_page/search_page.dart';
import '../../../componen/color.dart';
import '../../../componen/shimmerbooking.dart';
import '../../../data/data_endpoint/history.dart';
import '../../../data/data_endpoint/historypic.dart';
import '../../../data/data_endpoint/plannningservice.dart';
import '../../../routes/app_pages.dart';
import '../../history/componen/listhistorypic.dart';
import '../componen/listplanning.dart';

class PlanningServiceView extends StatefulWidget {
  PlanningServiceView({Key? key}) : super(key: key);

  @override
  _PlanningServiceViewState createState() => _PlanningServiceViewState();
}

class _PlanningServiceViewState extends State<PlanningServiceView> {
  late List<RefreshController> _refreshControllers;
  late Future<PlanningService> _historyPlanningServiceFuture;
  late Future<HistoryPIC> _historyBookingPicFuture;

  @override
  void initState() {
    super.initState();
    _refreshControllers = List.generate(11, (index) => RefreshController());
    _historyPlanningServiceFuture = API.PlanningServiceID();
    _historyBookingPicFuture = API.HistoryBookingPICID();
  }

  Future<void> handleBookingTap(PlanningPelanggan booking) async {
    Get.toNamed(
      Routes.DETAILPLANNING,
      arguments: {
        'kode_planning': booking.kodePlanning ?? '',
      },
    );
  }
  Future<void> handleBookingpicTap(HistoryPic booking) async {
    Get.toNamed(
      Routes.DETAILHISTORY,
      arguments: {
        'alamat': booking.alamat ?? '',
        'id': booking.id.toString(),
        'nama_cabang': booking.namaCabang ?? '',
        'nama_jenissvc': booking.namaJenissvc ?? '',
        'no_polisi': booking.noPolisi ?? '',
        'nama_status': booking.namaStatus ?? '',
        'vin_number': booking.vinNumber ?? '',
        'kode_booking': booking.kodeBooking ?? '',
        'type_order': booking.typeOrder ?? '',
        // 'jasa': booking.jasa?.map((item) => item.toJson()).toList() ?? [],
        // 'part': booking.part?.map((item) => item.toJson()).toList() ?? [],
      },
    );
  }

  void _onRefresh(int index) async {
    try {
      final newHistoryBooking = await API.PlanningServiceID();
      setState(() {
        _historyPlanningServiceFuture = Future.value(newHistoryBooking);
      });
      _refreshControllers[index].refreshCompleted();
    } catch (e) {
      _refreshControllers[index].refreshFailed();
      print('Error during refresh: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(Routes.HOME);
        return true;

      },
      child: Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: Colors.white,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.offAllNamed(Routes.HOME);
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: Text(
            'Planning Service',
            style: GoogleFonts.nunito(
              color: MyColors.appPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: DefaultTabController(
          length: 11,
          child: Column(
            children: [
              FutureBuilder<PlanningService>(
                future: _historyPlanningServiceFuture,
                builder: (context, snapshot) {
                  print('HistoryBooking Snapshot: ${snapshot.data}');
                  print('HistoryBooking Snapshot Error: ${snapshot.error}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Container(
                      width: double.infinity,
                      height: 40,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100,
                        border: Border.all(color: MyColors.select),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Icon(Icons.search_rounded, color: MyColors.appPrimaryColor),
                          const SizedBox(width: 10),
                          Text('Cari Planning Service', style: GoogleFonts.nunito(color: Colors.grey)),
                        ],
                      ),
                    ),);
                  } else if (snapshot.hasError) {
                    return Center(child: Container(
                      width: double.infinity,
                      height: 40,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100,
                        border: Border.all(color: MyColors.select),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Icon(Icons.search_rounded, color: MyColors.appPrimaryColor),
                          const SizedBox(width: 10),
                          Text('Cari Planning Service', style: GoogleFonts.nunito(color: Colors.grey)),
                        ],
                      ),
                    ),);
                  } else if (snapshot.hasData) {
                    final data = snapshot.data?.planningPelanggan;
                    if (data != null && data.isNotEmpty) {
                      return InkWell(
                        onTap: () => showSearch(
                          context: context,
                          delegate: SearchPage<PlanningPelanggan>(
                            items: data,
                            searchLabel: 'Cari Planning Service',
                            searchStyle: GoogleFonts.nunito(color: Colors.black),
                            showItemsOnEmpty: true,
                            failure: Center(
                              child: Text(
                                'Planning Service Tidak Ditemukan :(',
                                style: GoogleFonts.nunito(),
                              ),
                            ),
                            filter: (booking) => [
                              booking.noPolisi,
                              booking.namaCabang,
                              booking.alamat,
                              booking.namaPelanggan,
                              booking.kodePlanning,
                            ],
                            builder: (items) => ListPlanning(
                              booking: items,
                              onTap: () {
                                handleBookingTap(items);
                              },
                            ),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100,
                            border: Border.all(color: MyColors.select),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Icon(Icons.search_rounded, color: MyColors.appPrimaryColor),
                              const SizedBox(width: 10),
                              Text('Cari Planning Service', style: GoogleFonts.nunito(color: Colors.grey)),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return FutureBuilder<HistoryPIC>(
                        future: _historyBookingPicFuture,
                        builder: (context, snapshotPic) {
                          // Log data untuk debugging
                          print('HistoryPIC Snapshot: ${snapshotPic.data}');
                          print('HistoryPIC Snapshot Error: ${snapshotPic.error}');
                          if (snapshotPic.connectionState == ConnectionState.waiting) {
                            return Center(child: Container(
                              width: double.infinity,
                              height: 40,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100,
                                border: Border.all(color: MyColors.select),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Icon(Icons.search_rounded, color: MyColors.appPrimaryColor),
                                  const SizedBox(width: 10),
                                  Text('Cari Transaksi', style: GoogleFonts.nunito(color: Colors.grey)),
                                ],
                              ),
                            ),
                            );
                          } else if (snapshotPic.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/logo/forbidden.png', width: 60),
                                  SizedBox(height: 10),
                                  Text('Terjadi Kesalahan: ${snapshotPic.error}'),
                                ],
                              ),
                            );
                          } else if (snapshotPic.hasData) {
                            final dataPic = snapshotPic.data?.historyPic;
                            if (dataPic != null && dataPic.isNotEmpty) {
                              return InkWell(
                                onTap: () => showSearch(
                                  context: context,
                                  delegate: SearchPage<HistoryPic>(
                                    items: dataPic,
                                    searchLabel: 'Cari Booking',
                                    searchStyle: GoogleFonts.nunito(color: Colors.black),
                                    showItemsOnEmpty: true,
                                    failure: Center(
                                      child: Text(
                                        'Booking Tidak Ditemukan :(',
                                        style: GoogleFonts.nunito(),
                                      ),
                                    ),
                                    filter: (booking) => [
                                      booking.noPolisi,
                                      booking.kodeBooking,
                                      booking.vinNumber,
                                      booking.namaCabang,
                                      booking.alamat,
                                      booking.namaStatus,
                                      booking.namaPelanggan,
                                    ],
                                    builder: (items) => ListHistorypic(
                                      booking: items,
                                      onTap: () {
                                        handleBookingpicTap(items);
                                      },
                                    ),
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade100,
                                    border: Border.all(color: MyColors.select),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      Icon(Icons.search_rounded, color: MyColors.appPrimaryColor),
                                      const SizedBox(width: 10),
                                      Text('Cari Transaksi', style: GoogleFonts.nunito(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Center(
                                child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade100,
                                    border: Border.all(color: MyColors.select),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      Icon(Icons.search_rounded, color: MyColors.appPrimaryColor),
                                      const SizedBox(width: 10),
                                      Text('Cari Transaksi', style: GoogleFonts.nunito(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              );
                            }
                          } else {
                            return Center(
                              child: Text(
                                'Data Tidak Tersedia',
                                style: GoogleFonts.nunito(),
                              ),
                            );
                          }
                        },
                      );
                    }
                  } else {
                    return Center(
                      child: Text(
                        'Data Tidak Tersedia',
                        style: GoogleFonts.nunito(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 17),
              Container(
                height: 50,
                color: Colors.white,
                padding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                child: TabBar(
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.white,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: MyColors.appPrimaryColor,
                  ),
                  tabs: [
                    _buildTab('Semua'),
                    _buildTab('Periodical Maintenance'),
                    _buildTab('Repair & Maintenance'),
                    _buildTab('General Check UP/P2H'),
                    _buildTab('Tire/ Ban'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildTabContent('Semua', 0),
                    _buildTabContent('Periodical Maintenance', 1),
                    _buildTabContent('Repair & Maintenance', 2),
                    _buildTabContent('General Check UP/P2H', 3),
                    _buildTabContent('Tire/ Ban', 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title) {
    return Tab(
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: MyColors.select, width: 1),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(title),
        ),
      ),
    );
  }

  Widget _buildTabContent(String status, int index) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return const ShimmerListHistory();
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/forbidden.png',
                  width: 60,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10),
                Text('Belum ada Data Palanning Service'),
              ],
            ),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/forbidden.png',
                  width: 60,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10),
                Text('Belum ada Data Palanning Service'),
              ],
            ),
          );
        }

        var historyBooking = snapshot.data?['historyBooking'] as PlanningService?;
        var historyPIC = snapshot.data?['historyPIC'] as HistoryPIC?;

        // Gunakan data dari historyPIC jika tersedia, jika tidak, gunakan data dari historyBooking
        var bookings = historyPIC?.historyPic ?? (historyBooking?.planningPelanggan ?? []);

        if (bookings.isEmpty) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/forbidden.png',
                  width: 60,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10),
                Text('Belum ada Data Palanning Service'),
              ],
            ),
          );
        }

        List<dynamic> filteredBookings = status == 'Semua'
            ? bookings
            : bookings.where((booking) {
          if (booking is HistoryPic) {
            return booking.namaStatus == status;
          } else if (booking is PlanningPelanggan) {
            return booking.namaJenissvc == status;
          } else {
            return false;
          }
        }).toList();

        if (filteredBookings.isEmpty) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/forbidden.png',
                  width: 60,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10),
                Text('Belum ada Data Palanning Service'),
              ],
            ),
          );
        }

        return SmartRefresher(
            controller: _refreshControllers[index],
            enablePullDown: true,
            header: const WaterDropHeader(),
            onRefresh: () => _onRefresh(index),
            child: SingleChildScrollView(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 475),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: filteredBookings.map((booking) {
                    // Debug: Print the type of booking
                    print("Booking Type: ${booking.runtimeType}");

                    if (booking is HistoryPic) {
                      return ListHistorypic(
                        booking: booking,
                        onTap: () => handleBookingpicTap(booking),
                      );
                    } else if (booking is PlanningPelanggan) {
                      return ListPlanning(
                        booking: booking,
                        onTap: () => handleBookingTap(booking),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }).toList(),
                ),
              ),
            )
        );
      },
    );
  }

  Future<Map<String, dynamic>> _fetchData() async {
    var historyBookingFuture = _historyPlanningServiceFuture;
    var historyPICFuture = _historyBookingPicFuture;

    var historyBooking = await historyBookingFuture;
    var historyPIC = await historyPICFuture;

    return {
      'historyBooking': historyBooking,
      'historyPIC': historyPIC,
    };
  }

}