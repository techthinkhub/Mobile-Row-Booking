import 'package:customer_bengkelly/app/componen/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/data_endpoint/detailplannningservice.dart';
import '../../../data/endpoint.dart';
import '../../../routes/app_pages.dart';
class DetailPlanningPage extends StatefulWidget {
  @override
  _DetailPlanningPageState createState() => _DetailPlanningPageState();
}

class _DetailPlanningPageState extends State<DetailPlanningPage> {
  bool _isLoading = false; // To track loading state

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final String kodeplanning = arguments['kode_planning'];

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.white,
        elevation: 0,
        child: Container(
          width: double.infinity,
          child: SizedBox(
            height: 48.0,
            child: ElevatedButton(
              onPressed: _isLoading ? null : () async {
                setState(() {
                  _isLoading = true;
                });

                try {
                  final response = await API.ConfirmPlanningID(kodeplanning: kodeplanning);
                  Get.snackbar('Success', 'Konfirmasi berhasil');
                  Get.offAllNamed(Routes.PLANNING_SERVICE);
                } catch (e) {
                  Get.snackbar('Gagal', 'Anda sudah Konfirmasi Sebelumnya',
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Konfirmasi Pelanggan',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Detail Planning', style: TextStyle(color: MyColors.appPrimaryColor),),
      ),
      body: FutureBuilder<DetailPlanningService>(
        future: API.DetailPallaningID(kodeplanning: kodeplanning),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          final detailPlanning = snapshot.data!.detailPlanning;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Container(
              padding: EdgeInsets.all(16),
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
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Planning Details', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold),),
                      Text(detailPlanning?.dataPlanning?.tglEstimasi ?? '', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold),)
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildInfoRow(context, 'Tanggal PKB:', detailPlanning?.dataPlanning?.tglPkb ?? ''),
                  _buildInfoRow(context, 'Kode Planning:', detailPlanning?.dataPlanning?.kodePlanning ?? ''),
                  _buildInfoRow(context, 'Kode Pelanggan:', detailPlanning?.dataPlanning?.tipeSvc ?? ''),
                  _buildInfoRow(context, 'Kode Kendaraan:', detailPlanning?.dataPlanning?.noPolisi ?? ''),
                  _buildInfoRow(context, 'Penanggung Jawab:', detailPlanning?.dataPlanning?.penanggungJawab ?? ''),
                  _buildInfoRow(context, 'Tanggal Keluar:', detailPlanning?.dataPlanning?.tglKeluar ?? ''),
                  SizedBox(height: 16),
                  Divider(),
                  _buildSectionTitle(context, 'Detail Kendaraan'),
                  _buildInfoRow(context, 'Merk:', detailPlanning?.dataPlanning?.namaMerk ?? ''),
                  _buildInfoRow(context, 'Tipe:', detailPlanning?.dataPlanning?.namaTipe ?? ''),
                  _buildInfoRow(context, 'Odometer:', detailPlanning?.dataPlanning?.odometer ?? ''),
                  _buildInfoRow(context, 'Km Terakhir:', detailPlanning?.dataPlanning!.kmTerakhir.toString()??''),
                  _buildInfoRow(context, 'Nomor Lambung:', detailPlanning?.dataPlanning!.vinNumber??'-'),
                  Divider(),
                  _buildSectionTitle(context, 'Paket Planning'),
                  ..._buildPaketPlanningList(context, detailPlanning?.paketPlanning ?? []),
                  SizedBox(height: 16),
                  _buildSectionTitle(context, 'Detail Parts'),
                  ..._buildDetailPartList(context, detailPlanning?.dataPlanningDtlPart ?? []),
                  SizedBox(height: 16),
                  _buildSectionTitle(context, 'Detail Services'),
                  ..._buildDetailServiceList(context, detailPlanning?.dataSvcDtlJasa ?? []),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13)),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 13), textAlign: TextAlign.right,),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPaketPlanningList(BuildContext context, List<PaketPlanning> paketPlanning) {
    return paketPlanning.map((paket) {
      final harga = paket.harga?.toDouble() ?? 0.0;
      final qty = paket.qty ?? 0;
      return Card(
        elevation: 0,
        color: Colors.grey[100],
        margin: EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          title: Text(paket.namaPaket ?? ''),
          subtitle: Text('Qty: $qty - Harga: $harga'),
          trailing: Text('Total: ${_calculateTotal(harga, qty)}'),
        ),
      );
    }).toList();
  }

  List<Widget> _buildDetailPartList(BuildContext context, List<DataPlanningDtlPart> detailParts) {
    return detailParts.map((part) {
      final harga = part.hargaSparepart?.toDouble() ?? 0.0;
      final qty = part.qtySparepart ?? 0;
      return Card(
        elevation: 0,
        color: Colors.grey[100],
        margin: EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(part.namaSparepart ?? ''),
              Row(
                children: [
                  Text('Brand: ', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.normal),),
                  Text(part.brand ?? '', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.normal),),
                ],
              ),
            ],
          ),
          subtitle: Text('Qty: $qty - Harga: $harga'),
          trailing: Text('Total: ${_calculateTotal(harga, qty)}'),
        ),
      );
    }).toList();
  }

  List<Widget> _buildDetailServiceList(BuildContext context, List<DataSvcDtlJasa> detailServices) {
    return detailServices.map((service) {
      final harga = service.hargaJasa?.toDouble() ?? 0.0;
      final qty = service.qtyJasa ?? 0;
      return Card(
        elevation: 0,
        color: Colors.grey[100],
        margin: EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          title: Text(service.namaJasa ?? ''),
          subtitle: Text('Qty: $qty - Harga: $harga'),
          trailing: Text('Total: ${_calculateTotal(harga, qty)}'),
        ),
      );
    }).toList();
  }

  String _calculateTotal(double harga, int qty) {
    final total = harga * qty;
    return total.toStringAsFixed(2); // Adjust precision if needed
  }
}

