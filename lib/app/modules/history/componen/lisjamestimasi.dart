import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../data/data_endpoint/jamistimasi.dart'; // Import intl package

class ListjamEstimasi extends StatelessWidget {
  final Estimasi booking;

  const ListjamEstimasi({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    String formattedDate = _formatDate(booking.tglEstimasi ?? "");
    bool shouldShowJamEstimasiSelesai = booking.jamEstimasiSelesai != null &&
        booking.jamEstimasiSelesai!.isNotEmpty &&
        booking.jamEstimasiSelesai != '-';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          formattedDate,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Style sesuai kebutuhan
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
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
}
