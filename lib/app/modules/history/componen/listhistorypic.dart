import 'package:customer_bengkelly/app/componen/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data_endpoint/history.dart';
import '../../../data/data_endpoint/historypic.dart';
import '../../../data/endpoint.dart';

class ListHistorypic extends StatelessWidget {
  final HistoryPic booking;
  final VoidCallback onTap;
  const ListHistorypic({super.key, required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color statusColor = StatusColor.getColor(booking.namaStatus ?? '');
    Color statusColorbooking = StatusColoremergency.getColor(booking.typeOrder ?? '');

    // Mapping namaCabang to corresponding image assets
    Map<String, String> cabangImageAssets = {
      'Bengkelly Rest Area KM 379A': 'assets/logo/logo_vale.png',
      'Bengkelly Rest Area KM 228A': 'assets/logo/logo_vale.png',
      'Bengkelly Rest Area KM 389B': 'assets/logo/logo_vale.png',
      'Bengkelly Rest Area KM 575B': 'assets/logo/logo_vale.png',
      'Bengkelly Rest Area KM 319B': 'assets/logo/logo_vale.png',
    };

    // Default image if namaCabang does not match any key
    String imageAsset = cabangImageAssets[booking.namaCabang] ?? 'assets/icons/drop.png';


    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Menampilkan Type Order jika tidak "Emergency Service"
            if (booking.typeOrder != null && booking.typeOrder != "Booking Service")
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Type Order :',
                    style: GoogleFonts.nunito(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: statusColorbooking,
                    ),
                    child: Text(
                      booking.typeOrder ??"",
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 10), // Add space after the Type Order if displayed

            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${booking.namaCabang ?? ''}',
                      style: GoogleFonts.nunito(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 280,
                      child: Text(
                        '${booking.alamat ?? ''}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Text(
                    'Kode Booking : ',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${booking.kodeBooking ?? ''}',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${booking.namaJenissvc ?? ''}',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: statusColor,
                      ),
                      child: Text(
                        '${booking.namaStatus ?? ''}',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 5),
            Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'No Pol : ',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '${booking.noPolisi ?? ''}',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Nomor Lambung : ',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '${booking.vinNumber ?? ''}',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class StatusColoremergency {
  static Color getColor(String status) {
    switch (status.toLowerCase()) {
      case 'emergency service':
        return Colors.red;
      case 'booking service':
        return Colors.blue;
      default:
        return Colors.transparent;
    }
  }
}

class StatusColor {
  static Color getColor(String status) {
    switch (status.toLowerCase()) {
      case 'booking':
        return Colors.blue;
      case 'approve':
        return Colors.green;
      case 'diproses':
        return Colors.orange;
      case 'estimasi':
        return Colors.lime;
      case 'selesai dikerjakan':
        return Colors.blue;
      case 'pkb':
        return Colors.green;
      case 'pkb tutup':
        return Colors.deepOrangeAccent;
      case 'invoice':
        return Colors.blueAccent;
      case 'lunas':
        return Colors.lightBlue;
      case 'ditolak by sistem':
        return Colors.grey;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.transparent;
    }
  }
}
