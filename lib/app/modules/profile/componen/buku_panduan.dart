import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

import '../../../componen/color.dart';
import '../../../routes/app_pages.dart';

class PdfViewScreen extends StatefulWidget {
  @override
  _PdfViewScreenState createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  String pdfPath = '';

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    // Memanggil getApplicationDocumentsDirectory() untuk mendapatkan direktori dokumen aplikasi
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/buku_panduan.pdf';

    // Memuat file PDF dari assets
    final byteData = await rootBundle.load('assets/buku_panduan.pdf');
    final file = File(filePath);
    await file.writeAsBytes(byteData.buffer.asUint8List());

    setState(() {
      pdfPath = filePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text('Buku Panduan Aplikasi', style: GoogleFonts.nunito(color: MyColors.appPrimaryColor, fontWeight: FontWeight.bold),),
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
                child:
                SvgPicture.asset('assets/icons/notif.svg', width: 26,),),
              SizedBox(width: 10,),
            ],),
        ],
      ),
      body: pdfPath.isEmpty
          ? Center(child: CircularProgressIndicator())
          : PDFView(
        filePath: pdfPath,
      ),
    );

  }
}
