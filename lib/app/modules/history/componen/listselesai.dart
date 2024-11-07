import 'package:customer_bengkelly/app/componen/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../data/data_endpoint/history.dart';
import '../../../data/data_endpoint/jamistimasi.dart';
import '../../../data/endpoint.dart';

class ListSelesai extends StatelessWidget {
  final Estimasi booking;

  const ListSelesai({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    // Tentukan apakah proses pengerjaan
    final bool isProsesPengerjaan = booking.tglEstimasi == "-";
    final Color containerColor = isProsesPengerjaan ? Colors.white : Colors.white;
    final String titleText = isProsesPengerjaan ? "Proses Pengerjaan" : "Selesai : ";
    final String selesaiText = isProsesPengerjaan ? "" : (booking.selesai ?? "");
    String formattedDatetgl = _formatDatetgl(booking.tglEstimasi ?? "");
    String formattedDatejam = _formatDatejam(booking.tglEstimasi ?? "");
    bool shouldShowJamEstimasiSelesai = booking.jamEstimasiSelesai != null &&
        booking.jamEstimasiSelesai!.isNotEmpty &&
        booking.jamEstimasiSelesai != '-';
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.car_crash_rounded, color: Colors. white,),
          SizedBox(width: 10,),
          Text(
            titleText,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: containerColor,
            ),
          ),
          SizedBox(width: 10,),
          if (!isProsesPengerjaan)
            Row(children: [
              Icon(Icons.calendar_month_rounded, color: Colors. white, size: 17,),
              SizedBox(width: 5,),
              Text(
                formattedDatetgl,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Style sesuai kebutuhan
                ),
              ),
              SizedBox(width: 5,),
              Row(children: [
                Icon(Icons.access_time_filled_sharp, color: Colors. white, size: 17,),
                SizedBox(width: 5,),
                Text(
                  formattedDatejam,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Style sesuai kebutuhan
                  ),
                ),
                ],
              ),

            ],)
        ],
      ),
    );
  }
  String _formatDatetgl(String dateString) {
    try {
      // Parsing string ke DateTime
      DateTime dateTime = DateTime.parse(dateString);

      // Mengubah format tanggal ke "dd MMMM yyyy"
      return DateFormat('dd MMMM yyyy').format(dateTime);
    } catch (e) {
      // Jika terjadi error saat parsing, kembalikan string kosong atau pesan error
      print('Error formatting date: $e');
      return 'Invalid date';
    }
  }
  String _formatDatejam(String dateString) {
    try {
      // Parsing string ke DateTime
      DateTime dateTime = DateTime.parse(dateString);

      // Mengubah format tanggal ke "dd MMMM yyyy"
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      // Jika terjadi error saat parsing, kembalikan string kosong atau pesan error
      print('Error formatting date: $e');
      return 'Invalid date';
    }
  }
}

// Di dalam FutureBuilder
