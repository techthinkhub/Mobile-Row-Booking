class Jamistimasi {
  bool? status;
  List<Estimasi>? estimasi;

  Jamistimasi({this.status, this.estimasi});

  Jamistimasi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['estimasi'] != null) {
      estimasi = <Estimasi>[];
      json['estimasi'].forEach((v) {
        estimasi!.add(new Estimasi.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.estimasi != null) {
      data['estimasi'] = this.estimasi!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Estimasi {
  String? tglEstimasi;
  String? jamEstimasiSelesai;
  String? selesai;

  Estimasi({this.tglEstimasi, this.jamEstimasiSelesai, this.selesai});

  Estimasi.fromJson(Map<String, dynamic> json) {
    tglEstimasi = json['tgl_estimasi'];
    jamEstimasiSelesai = json['jam_estimasi_selesai'];
    selesai = json['selesai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tgl_estimasi'] = this.tglEstimasi;
    data['jam_estimasi_selesai'] = this.jamEstimasiSelesai;
    data['selesai'] = this.selesai;
    return data;
  }
}
