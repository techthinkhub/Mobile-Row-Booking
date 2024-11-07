class BookingCustomer {
  bool? status;
  String? message;
  Data? data;

  BookingCustomer({this.status, this.message, this.data});

  BookingCustomer.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? kodeBooking;
  int? idJenissvc;
  int? idTipe;
  int? idMerk;
  int? idCustomer;
  int? idKendaraan;
  int? idCabang;
  String? jamBooking;
  String? tglBooking;
  String? status;
  String? odometer;
  String? pic;
  String? hpPic;
  String? referensi;
  String? referensiTeman;
  String? keluhan;
  String? perintahKerja;
  String? createdBy;
  int? deleted;
  String? createdAt;
  String? updatedAt;
  String? pmOpt;
  String? berita;
  String? kode;
  String? typeOrder;
  String? location;
  String? locationName;
  String? datetimeApprove;
  String? jamApprove;
  String? jamOtw;
  String? jamTiba;
  String? photoStnk;
  JenisService? jenisService;
  Cabang? cabang;
  Kendaraan? kendaraan;
  List<Null>? bookingMedia;

  Data(
      {this.id,
        this.kodeBooking,
        this.idJenissvc,
        this.idTipe,
        this.idMerk,
        this.idCustomer,
        this.idKendaraan,
        this.idCabang,
        this.jamBooking,
        this.tglBooking,
        this.status,
        this.odometer,
        this.pic,
        this.hpPic,
        this.referensi,
        this.referensiTeman,
        this.keluhan,
        this.perintahKerja,
        this.createdBy,
        this.deleted,
        this.createdAt,
        this.updatedAt,
        this.pmOpt,
        this.berita,
        this.kode,
        this.typeOrder,
        this.location,
        this.locationName,
        this.datetimeApprove,
        this.jamApprove,
        this.jamOtw,
        this.jamTiba,
        this.photoStnk,
        this.jenisService,
        this.cabang,
        this.kendaraan,
        this.bookingMedia});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kodeBooking = json['kode_booking'];
    idJenissvc = json['id_jenissvc'];
    idTipe = json['id_tipe'];
    idMerk = json['id_merk'];
    idCustomer = json['id_customer'];
    idKendaraan = json['id_kendaraan'];
    idCabang = json['id_cabang'];
    jamBooking = json['jam_booking'];
    tglBooking = json['tgl_booking'];
    status = json['status'];
    odometer = json['odometer'];
    pic = json['pic'];
    hpPic = json['hp_pic'];
    referensi = json['referensi'];
    referensiTeman = json['referensi_teman'];
    keluhan = json['keluhan'];
    perintahKerja = json['perintah_kerja'];
    createdBy = json['created_by'];
    deleted = json['deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pmOpt = json['pm_opt'];
    berita = json['berita'];
    kode = json['kode'];
    typeOrder = json['type_order'];
    location = json['location'];
    locationName = json['location_name'];
    datetimeApprove = json['datetime_approve'];
    jamApprove = json['jam_approve'];
    jamOtw = json['jam_otw'];
    jamTiba = json['jam_tiba'];
    photoStnk = json['photo_stnk'];
    jenisService = json['jenis_service'] != null
        ? new JenisService.fromJson(json['jenis_service'])
        : null;
    cabang =
    json['cabang'] != null ? new Cabang.fromJson(json['cabang']) : null;
    kendaraan = json['kendaraan'] != null
        ? new Kendaraan.fromJson(json['kendaraan'])
        : null;
    if (json['booking_media'] != null) {
      bookingMedia = <Null>[];
      json['booking_media'].forEach((v) {
        bookingMedia!.add((v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kode_booking'] = this.kodeBooking;
    data['id_jenissvc'] = this.idJenissvc;
    data['id_tipe'] = this.idTipe;
    data['id_merk'] = this.idMerk;
    data['id_customer'] = this.idCustomer;
    data['id_kendaraan'] = this.idKendaraan;
    data['id_cabang'] = this.idCabang;
    data['jam_booking'] = this.jamBooking;
    data['tgl_booking'] = this.tglBooking;
    data['status'] = this.status;
    data['odometer'] = this.odometer;
    data['pic'] = this.pic;
    data['hp_pic'] = this.hpPic;
    data['referensi'] = this.referensi;
    data['referensi_teman'] = this.referensiTeman;
    data['keluhan'] = this.keluhan;
    data['perintah_kerja'] = this.perintahKerja;
    data['created_by'] = this.createdBy;
    data['deleted'] = this.deleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['pm_opt'] = this.pmOpt;
    data['berita'] = this.berita;
    data['kode'] = this.kode;
    data['type_order'] = this.typeOrder;
    data['location'] = this.location;
    data['location_name'] = this.locationName;
    data['datetime_approve'] = this.datetimeApprove;
    data['jam_approve'] = this.jamApprove;
    data['jam_otw'] = this.jamOtw;
    data['jam_tiba'] = this.jamTiba;
    data['photo_stnk'] = this.photoStnk;
    if (this.jenisService != null) {
      data['jenis_service'] = this.jenisService!.toJson();
    }
    if (this.cabang != null) {
      data['cabang'] = this.cabang!.toJson();
    }
    if (this.kendaraan != null) {
      data['kendaraan'] = this.kendaraan!.toJson();
    }
    if (this.bookingMedia != null) {
      data['booking_media'] =
          this.bookingMedia!.map((v) => ()).toList();
    }
    return data;
  }
}

class JenisService {
  int? id;
  String? namaJenissvc;

  JenisService({this.id, this.namaJenissvc});

  JenisService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaJenissvc = json['nama_jenissvc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_jenissvc'] = this.namaJenissvc;
    return data;
  }
}

class Cabang {
  int? id;
  String? nama;
  String? alamat;
  String? telp;
  String? fasilitas;
  String? jamOperasional;
  String? latitude;
  String? longitude;
  int? idCompany;
  String? keterangan;
  Company? company;

  Cabang(
      {this.id,
        this.nama,
        this.alamat,
        this.telp,
        this.fasilitas,
        this.jamOperasional,
        this.latitude,
        this.longitude,
        this.idCompany,
        this.keterangan,
        this.company});

  Cabang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    alamat = json['alamat'];
    telp = json['telp'];
    fasilitas = json['fasilitas'];
    jamOperasional = json['jam_operasional'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    idCompany = json['id_company'];
    keterangan = json['keterangan'];
    company =
    json['company'] != null ? new Company.fromJson(json['company']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama'] = this.nama;
    data['alamat'] = this.alamat;
    data['telp'] = this.telp;
    data['fasilitas'] = this.fasilitas;
    data['jam_operasional'] = this.jamOperasional;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['id_company'] = this.idCompany;
    data['keterangan'] = this.keterangan;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    return data;
  }
}

class Company {
  int? id;
  String? nama;

  Company({this.id, this.nama});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama'] = this.nama;
    return data;
  }
}

class Kendaraan {
  int? id;
  String? noPolisi;
  String? warna;
  String? tahun;
  String? transmisi;
  String? noRangka;
  String? vinNumber;
  String? noMesin;
  String? modelKaroseri;
  String? drivingMode;
  String? power;
  String? kategoriKendaraan;
  String? jenisKontrak;
  int? idTipe;
  int? idMerk;
  String? kodePelanggan;
  List<Tipes>? tipes;
  Merks? merks;
  Pelanggan? pelanggan;

  Kendaraan(
      {this.id,
        this.noPolisi,
        this.warna,
        this.tahun,
        this.transmisi,
        this.noRangka,
        this.vinNumber,
        this.noMesin,
        this.modelKaroseri,
        this.drivingMode,
        this.power,
        this.kategoriKendaraan,
        this.jenisKontrak,
        this.idTipe,
        this.idMerk,
        this.kodePelanggan,
        this.tipes,
        this.merks,
        this.pelanggan});

  Kendaraan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noPolisi = json['no_polisi'];
    warna = json['warna'];
    tahun = json['tahun'];
    transmisi = json['transmisi'];
    noRangka = json['no_rangka'];
    vinNumber = json['vin_number'];
    noMesin = json['no_mesin'];
    modelKaroseri = json['model_karoseri'];
    drivingMode = json['driving_mode'];
    power = json['power'];
    kategoriKendaraan = json['kategori_kendaraan'];
    jenisKontrak = json['jenis_kontrak'];
    idTipe = json['id_tipe'];
    idMerk = json['id_merk'];
    kodePelanggan = json['kode_pelanggan'];
    if (json['tipes'] != null) {
      tipes = <Tipes>[];
      json['tipes'].forEach((v) {
        tipes!.add(new Tipes.fromJson(v));
      });
    }
    merks = json['merks'] != null ? new Merks.fromJson(json['merks']) : null;
    pelanggan = json['pelanggan'] != null
        ? new Pelanggan.fromJson(json['pelanggan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['no_polisi'] = this.noPolisi;
    data['warna'] = this.warna;
    data['tahun'] = this.tahun;
    data['transmisi'] = this.transmisi;
    data['no_rangka'] = this.noRangka;
    data['vin_number'] = this.vinNumber;
    data['no_mesin'] = this.noMesin;
    data['model_karoseri'] = this.modelKaroseri;
    data['driving_mode'] = this.drivingMode;
    data['power'] = this.power;
    data['kategori_kendaraan'] = this.kategoriKendaraan;
    data['jenis_kontrak'] = this.jenisKontrak;
    data['id_tipe'] = this.idTipe;
    data['id_merk'] = this.idMerk;
    data['kode_pelanggan'] = this.kodePelanggan;
    if (this.tipes != null) {
      data['tipes'] = this.tipes!.map((v) => v.toJson()).toList();
    }
    if (this.merks != null) {
      data['merks'] = this.merks!.toJson();
    }
    if (this.pelanggan != null) {
      data['pelanggan'] = this.pelanggan!.toJson();
    }
    return data;
  }
}

class Tipes {
  int? id;
  String? namaTipe;
  int? idMerk;

  Tipes({this.id, this.namaTipe, this.idMerk});

  Tipes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaTipe = json['nama_tipe'];
    idMerk = json['id_merk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_tipe'] = this.namaTipe;
    data['id_merk'] = this.idMerk;
    return data;
  }
}

class Merks {
  int? id;
  String? namaMerk;

  Merks({this.id, this.namaMerk});

  Merks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaMerk = json['nama_merk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_merk'] = this.namaMerk;
    return data;
  }
}

class Pelanggan {
  String? kode;
  int? id;
  String? nama;

  Pelanggan({this.kode, this.id, this.nama});

  Pelanggan.fromJson(Map<String, dynamic> json) {
    kode = json['kode'];
    id = json['id'];
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kode'] = this.kode;
    data['id'] = this.id;
    data['nama'] = this.nama;
    return data;
  }
}
