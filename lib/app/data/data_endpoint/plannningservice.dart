class PlanningService {
  bool? status;
  String? message;
  List<PlanningPelanggan>? planningPelanggan;

  PlanningService({this.status, this.message, this.planningPelanggan});

  PlanningService.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['planningPelanggan'] != null) {
      planningPelanggan = <PlanningPelanggan>[];
      json['planningPelanggan'].forEach((v) {
        planningPelanggan!.add(new PlanningPelanggan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.planningPelanggan != null) {
      data['planningPelanggan'] =
          this.planningPelanggan!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanningPelanggan {
  int? id;
  String? kodePlanning;
  String? kodeBooking;
  String? kodeSvc;
  String? kodeEstimasi;
  String? kodePelanggan;
  String? kodeKendaraan;
  String? odometer;
  String? referensi;
  String? konfirmasi;
  String? createdAt;
  String? namaPelanggan;
  String? namaCabang;
  String? alamat;
  String? noPolisi;
  String? vinNumber;
  String? namaJenissvc;

  PlanningPelanggan(
      {this.id,
        this.kodePlanning,
        this.kodeBooking,
        this.kodeSvc,
        this.kodeEstimasi,
        this.kodePelanggan,
        this.kodeKendaraan,
        this.odometer,
        this.referensi,
        this.konfirmasi,
        this.createdAt,
        this.namaPelanggan,
        this.namaCabang,
        this.alamat,
        this.noPolisi,
        this.vinNumber,
        this.namaJenissvc});

  PlanningPelanggan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kodePlanning = json['kode_planning'];
    kodeBooking = json['kode_booking'];
    kodeSvc = json['kode_svc'];
    kodeEstimasi = json['kode_estimasi'];
    kodePelanggan = json['kode_pelanggan'];
    kodeKendaraan = json['kode_kendaraan'];
    odometer = json['odometer'];
    referensi = json['referensi'];
    konfirmasi = json['konfirmasi'];
    createdAt = json['created_at'];
    namaPelanggan = json['nama_pelanggan'];
    namaCabang = json['nama_cabang'];
    alamat = json['alamat'];
    noPolisi = json['no_polisi'];
    vinNumber = json['vin_number'];
    namaJenissvc = json['nama_jenissvc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kode_planning'] = this.kodePlanning;
    data['kode_booking'] = this.kodeBooking;
    data['kode_svc'] = this.kodeSvc;
    data['kode_estimasi'] = this.kodeEstimasi;
    data['kode_pelanggan'] = this.kodePelanggan;
    data['kode_kendaraan'] = this.kodeKendaraan;
    data['odometer'] = this.odometer;
    data['referensi'] = this.referensi;
    data['konfirmasi'] = this.konfirmasi;
    data['created_at'] = this.createdAt;
    data['nama_pelanggan'] = this.namaPelanggan;
    data['nama_cabang'] = this.namaCabang;
    data['alamat'] = this.alamat;
    data['no_polisi'] = this.noPolisi;
    data['vin_number'] = this.vinNumber;
    data['nama_jenissvc'] = this.namaJenissvc;
    return data;
  }
}
