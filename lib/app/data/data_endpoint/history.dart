class HistoryBooking {
  bool? status;
  String? message;
  List<HistoryPelanggan>? historyPelanggan;

  HistoryBooking({this.status, this.message, this.historyPelanggan});

  HistoryBooking.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['historyPelanggan'] != null) {
      historyPelanggan = <HistoryPelanggan>[];
      json['historyPelanggan'].forEach((v) {
        historyPelanggan!.add(new HistoryPelanggan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.historyPelanggan != null) {
      data['historyPelanggan'] =
          this.historyPelanggan!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HistoryPelanggan {
  int? id;
  String? kodeBooking;
  String? typeOrder;
  String? namaPelanggan;
  String? namaCabang;
  String? alamat;
  String? noPolisi;
  String? vinNumber;
  String? namaStatus;
  String? namaJenissvc;
  List<Jasa>? jasa;
  String? message;
  List<Part>? part;
  List<String>? mediaUrls;

  HistoryPelanggan(
      {this.id,
        this.kodeBooking,
        this.typeOrder,
        this.namaPelanggan,
        this.namaCabang,
        this.alamat,
        this.noPolisi,
        this.vinNumber,
        this.namaStatus,
        this.namaJenissvc,
        this.jasa,
        this.message,
        this.part,
        this.mediaUrls});

  HistoryPelanggan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kodeBooking = json['kode_booking'];
    typeOrder = json['type_order'];
    namaPelanggan = json['nama_pelanggan'];
    namaCabang = json['nama_cabang'];
    alamat = json['alamat'];
    noPolisi = json['no_polisi'];
    vinNumber = json['vin_number'];
    namaStatus = json['nama_status'];
    namaJenissvc = json['nama_jenissvc'];
    if (json['jasa'] != null) {
      jasa = <Jasa>[];
      json['jasa'].forEach((v) {
        jasa!.add(new Jasa.fromJson(v));
      });
    }
    message = json['message'];
    if (json['part'] != null) {
      part = <Part>[];
      json['part'].forEach((v) {
        part!.add(new Part.fromJson(v));
      });
    }
    mediaUrls = json['media_urls'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kode_booking'] = this.kodeBooking;
    data['type_order'] = this.typeOrder;
    data['nama_pelanggan'] = this.namaPelanggan;
    data['nama_cabang'] = this.namaCabang;
    data['alamat'] = this.alamat;
    data['no_polisi'] = this.noPolisi;
    data['vin_number'] = this.vinNumber;
    data['nama_status'] = this.namaStatus;
    data['nama_jenissvc'] = this.namaJenissvc;
    if (this.jasa != null) {
      data['jasa'] = this.jasa!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    if (this.part != null) {
      data['part'] = this.part!.map((v) => v.toJson()).toList();
    }
    data['media_urls'] = this.mediaUrls;
    return data;
  }
}

class Jasa {
  String? tgl;
  String? kodeJasa;
  String? namaJasa;
  int? qtyJasa;
  int? harga;

  Jasa({this.tgl, this.kodeJasa, this.namaJasa, this.qtyJasa, this.harga});

  Jasa.fromJson(Map<String, dynamic> json) {
    tgl = json['tgl'];
    kodeJasa = json['kode_jasa'];
    namaJasa = json['nama_jasa'];
    qtyJasa = json['qty_jasa'];
    harga = json['harga'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tgl'] = this.tgl;
    data['kode_jasa'] = this.kodeJasa;
    data['nama_jasa'] = this.namaJasa;
    data['qty_jasa'] = this.qtyJasa;
    data['harga'] = this.harga;
    return data;
  }
}

class Part {
  String? tgl;
  String? kodeSparepart;
  String? namaSparepart;
  int? qtySparepart;
  int? harga;

  Part(
      {this.tgl,
        this.kodeSparepart,
        this.namaSparepart,
        this.qtySparepart,
        this.harga});

  Part.fromJson(Map<String, dynamic> json) {
    tgl = json['tgl'];
    kodeSparepart = json['kode_sparepart'];
    namaSparepart = json['nama_sparepart'];
    qtySparepart = json['qty_sparepart'];
    harga = json['harga'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tgl'] = this.tgl;
    data['kode_sparepart'] = this.kodeSparepart;
    data['nama_sparepart'] = this.namaSparepart;
    data['qty_sparepart'] = this.qtySparepart;
    data['harga'] = this.harga;
    return data;
  }
}
