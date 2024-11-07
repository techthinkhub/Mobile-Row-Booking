import 'package:customer_bengkelly/app/data/endpoint.dart';
import 'package:flutter/material.dart';
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
import '../../../routes/app_pages.dart';
import '../componen/listhistory.dart';
import '../componen/listhistorypic.dart';
import '../controllers/history_controller.dart';

class HistoryView extends StatefulWidget {
  HistoryView({Key? key}) : super(key: key);

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late List<RefreshController> _refreshControllers;
  late Future<HistoryBooking> _historyBookingFuture;
  late Future<HistoryPIC> _historyBookingPicFuture;

  @override
  void initState() {
    super.initState();
    _refreshControllers = List.generate(11, (index) => RefreshController());
    _historyBookingFuture = API.HistoryBookingID();
    _historyBookingPicFuture = API.HistoryBookingPICID();
  }

  Future<void> handleBookingTap(HistoryPelanggan booking) async {
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
        'media_urls': booking.mediaUrls ?? [],
        'jasa': booking.jasa?.map((item) => item.toJson()).toList() ?? [],
        'part': booking.part?.map((item) => item.toJson()).toList() ?? [],
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
        'jasa': booking.jasa?.map((item) => item.toJson()).toList() ?? [],
        'part': booking.part?.map((item) => item.toJson()).toList() ?? [],
      },
    );
  }

  void _onRefresh(int index) async {
    try {
      final newHistoryBooking = await API.HistoryBookingID();
      setState(() {
        _historyBookingFuture = Future.value(newHistoryBooking);
      });
      _refreshControllers[index].refreshCompleted();
    } catch (e) {
      _refreshControllers[index].refreshFailed();
      print('Error during refresh: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          'History',
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
                child: SvgPicture.asset(
                  'assets/icons/massage.svg',
                  width: 26,
                ),
              ),
              SizedBox(width: 20),
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.NOTIFIKASI);
                },
                child: SvgPicture.asset(
                  'assets/icons/notif.svg',
                  width: 26,
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: DefaultTabController(
        length: 11,
        child: Column(
          children: [
            FutureBuilder<HistoryBooking>(
              future: _historyBookingFuture,
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
                        Text('Cari Transaksi', style: GoogleFonts.nunito(color: Colors.grey)),
                      ],
                    ),
                  ),);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/logo/forbidden.png', width: 60),
                        SizedBox(height: 10),
                        Text('Terjadi Kesalahan: ${snapshot.error}'),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data?.historyPelanggan;
                  if (data != null && data.isNotEmpty) {
                    return InkWell(
                      onTap: () => showSearch(
                        context: context,
                        delegate: SearchPage<HistoryPelanggan>(
                          items: data,
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
                            booking.namaCabang,
                            booking.alamat,
                            booking.namaStatus,
                            booking.namaPelanggan,
                          ],
                          builder: (items) => ListHistory(
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
                            Text('Cari Transaksi', style: GoogleFonts.nunito(color: Colors.grey)),
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
                  _buildTab('Booking'),
                  _buildTab('Approve'),
                  _buildTab('Diproses'),
                  _buildTab('Estimasi'),
                  _buildTab('PKB'),
                  _buildTab('PKB TUTUP'),
                  _buildTab('Selesai Dikerjakan'),
                  _buildTab('Invoice'),
                  _buildTab('Lunas'),
                  _buildTab('Ditolak'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTabContent('Semua', 0),
                  _buildTabContent('Booking', 1),
                  _buildTabContent('Approve', 2),
                  _buildTabContent('Diproses', 3),
                  _buildTabContent('Estimasi', 4),
                  _buildTabContent('PKB', 5),
                  _buildTabContent('PKB TUTUP', 6),
                  _buildTabContent('Selesai Dikerjakan', 7),
                  _buildTabContent('Invoice', 8),
                  _buildTabContent('Lunas', 9),
                  _buildTabContent('Ditolak', 10),
                ],
              ),
            ),
          ],
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
                Text('Belum ada Data History Booking'),
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
                Text('Belum ada Data History Booking'),
              ],
            ),
          );
        }

        var historyBooking = snapshot.data?['historyBooking'] as HistoryBooking?;
        var historyPIC = snapshot.data?['historyPIC'] as HistoryPIC?;

        // Gunakan data dari historyPIC jika tersedia, jika tidak, gunakan data dari historyBooking
        var bookings = historyPIC?.historyPic ?? (historyBooking?.historyPelanggan ?? []);

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
                Text('Belum ada Data History Booking'),
              ],
            ),
          );
        }

        List<dynamic> filteredBookings = status == 'Semua'
            ? bookings
            : bookings.where((booking) {
          if (booking is HistoryPic) {
            return booking.namaStatus == status;
          } else if (booking is HistoryPelanggan) {
            return booking.namaStatus == status;
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
                Text('Belum ada Data History Booking'),
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
                  if (booking is HistoryPic) {
                    return ListHistorypic(
                      booking: booking,
                      onTap: () => handleBookingpicTap(booking),
                    );
                  } else if (booking is HistoryPelanggan) {
                    return ListHistory(
                      booking: booking,
                      onTap: () => handleBookingTap(booking),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _fetchData() async {
    var historyBookingFuture = _historyBookingFuture;
    var historyPICFuture = _historyBookingPicFuture;

    var historyBooking = await historyBookingFuture;
    var historyPIC = await historyPICFuture;

    return {
      'historyBooking': historyBooking,
      'historyPIC': historyPIC,
    };
  }

}