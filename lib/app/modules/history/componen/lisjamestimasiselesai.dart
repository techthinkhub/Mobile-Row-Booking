import 'package:customer_bengkelly/app/componen/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data_endpoint/history.dart';
import '../../../data/data_endpoint/jamistimasi.dart';
import '../../../data/endpoint.dart';

class ListjamEstimasiSelesai extends StatelessWidget {
  final Estimasi booking;
  const ListjamEstimasiSelesai({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(booking.jamEstimasiSelesai??""),
      ],
    );
  }
}
