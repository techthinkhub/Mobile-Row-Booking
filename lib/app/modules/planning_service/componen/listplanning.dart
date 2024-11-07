import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/data_endpoint/plannningservice.dart';
import '../../../componen/color.dart';

class ListPlanning extends StatelessWidget {
  final PlanningPelanggan booking;
  final VoidCallback onTap;

  const ListPlanning({
    super.key,
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get color based on status
    Color statusColor = StatusColor.getColor(booking.konfirmasi ?? '');

    // Map for branch images
    final Map<String, String> cabangImageAssets = {
      'Bengkelly Rest Area KM 379A': 'assets/logo/logo_vale.png',
      'Bengkelly Rest Area KM 228A': 'assets/logo/logo_vale.png',
      'Bengkelly Rest Area KM 389B': 'assets/logo/logo_vale.png',
      'Bengkelly Rest Area KM 575B': 'assets/logo/logo_vale.png',
      'Bengkelly Rest Area KM 319B': 'assets/logo/logo_vale.png',
    };

    // Default image if namaCabang does not match any key
    final String imageAsset = cabangImageAssets[booking.namaCabang] ?? 'assets/logo/logo_vale.png';

    // Helper function to format konfirmasi status
    String formatKonfirmasi(String? status) {
      if (status == null) return '';
      return status.replaceAll('_', ' ').toUpperCase(); // Replace underscores and convert to uppercase
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Tanggal/Jam Planning',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${booking.createdAt ?? "Data Belum ada"}',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
                        formatKonfirmasi(booking.konfirmasi),
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

            SizedBox(height: 12),

            // Cabang and Address Section
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
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${booking.namaCabang ?? ''}',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${booking.alamat ?? ''}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Divider
            Divider(color: Colors.grey.shade100),

            // Booking Code Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoRow(label: 'Kode Planning ', value: ': ${booking.kodePlanning ?? ''}'),
                ],
              ),
            ),
            SizedBox(height: 8),

            // Service Type and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${booking.namaJenissvc ?? ''}',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Additional Information
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRow(label: 'No Pol ', value: ': ${booking.noPolisi ?? ''}'),
                SizedBox(height: 4),
                InfoRow(label: 'Nomor Lambung ', value: ': ${booking.vinNumber ?? ''}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class StatusColor {
  static Color getColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirm':
        return Colors.blue; // Color for confirmed status
      case 'not_confirm':
        return Colors.orange; // Color for not confirmed status
      default:
        return Colors.grey; // Default color for unexpected status
    }
  }
}
