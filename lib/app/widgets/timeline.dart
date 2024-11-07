import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../componen/color.dart';
import 'componen/my_font_size.dart';
import 'componen/my_style.dart';
import 'customcard.dart';

class WidgetTimeline extends StatelessWidget {
  final IconData? icon;
  final Color? bgcolor;
  final String? title1;
  final String? title2;
  final String? time;
  final bool? showCard;
  final bool? showCard2;
  final List<dynamic>? jasa;
  final List<dynamic>? part;

  const WidgetTimeline({
    Key? key,
    this.icon,
    this.bgcolor,
    this.title1,
    this.title2,
    this.time,
    this.showCard,
    this.showCard2,
    this.jasa,
    this.part,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Column(
              children: [
                CustomCard(
                  shadow: false,
                  height: 50,
                  width: 50,
                  bgColor: (jasa != null && jasa!.isNotEmpty) ||
                      (part != null && part!.isNotEmpty) ? MyColors
                      .appPrimaryColor : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(100),
                  child: Center(child: Icon(icon, color: Colors.white)),
                ),
                Expanded(
                  child: Container(
                    width: 1,
                    color: MyColors.appPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title1 ?? '',
                            style: MyStyle.textTitleBlack.copyWith(
                                fontSize: MyFontSize.medium2),
                          ),
                          SizedBox(height: 5),
                          Text(
                            title2 ?? '',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: MyFontSize.medium1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      time ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyColors.yellow,
                        fontSize: MyFontSize.small3,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (showCard ?? false && jasa != null)
                  CustomCard(
                    shadow: false,
                    bgColor: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                    padding: EdgeInsets.all(15),
                    child: _buildDetailList1(
                        jasa!, 'nama_jasa', 'qty_jasa', 'tgl', 'harga'),
                  ),
                if (showCard2 ?? false && part != null)
                  CustomCard(
                    shadow: false,
                    bgColor: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                    padding: EdgeInsets.all(15),
                    child: _buildDetailList2(
                        part!, 'nama_sparepart', 'kode_sparepart', 'tgl',
                        'harga'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailList1(List<dynamic> items, String titleKey,
      String subtitleKey, String trailingKey, String titleKey2) {

    String formatCurrency(int? amount) {
      if (amount == null) {
        return 'Rp. -'; // or any default value you prefer for null case
      }
      var format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
      return format.format(amount);
    }

    return Column(
      children: items.map((item) {
        final title = item[titleKey]?.toString() ?? '';
        final subtitle = item[subtitleKey]?.toString() ?? '';
        final trailing = item[trailingKey]?.toString() ?? '';
        final additionalTitleString = item[titleKey2]?.toString() ?? '';
        final additionalTitle = int.tryParse(additionalTitleString);

        return Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 15,
                ),
              ),
              SizedBox(width: 5),
              Row(
                children: [
                  Text(
                    'Jumlah : ',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Tanggal: $trailing',
                style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
              ),
              Text(
                'Harga: ${formatCurrency(additionalTitle)}',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Divider(color: Colors.grey,)
            ],
          ),
        );
      }).toList(),
    );
  }



  Widget _buildDetailList2(List<dynamic> items, String titleKey,
      String subtitleKey, String trailingKey, String titleKey2) {
    String formatCurrency(int? amount) {
      if (amount == null) {
        return 'Rp. -'; // or any default value you prefer for null case
      }
      var format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
      return format.format(amount);
    }

    return Column(
      children: items.map((item) {
        final title = item[titleKey]?.toString() ?? '';
        final subtitle = item[subtitleKey]?.toString() ?? '';
        final trailing = item[trailingKey]?.toString() ?? '';
        final additionalTitleString = item[titleKey2]?.toString() ?? '';
        final additionalTitle = int.tryParse(additionalTitleString);

        return Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 15,
                ),
              ),
              SizedBox(width: 5),
              Text(
                subtitle,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Tanggal: $trailing',
                style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
              ),
              Text(
                'Harga: ${formatCurrency(additionalTitle)}',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Divider(color: Colors.grey,)
            ],
          ),
        );
      }).toList(),
    );
  }
}