class PmOpt {
  bool? status;
  String? message;
  List<GetPmOptOptions>? getPmOptOptions;

  PmOpt({this.status, this.message, this.getPmOptOptions});

  PmOpt.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['getPmOptOptions'] != null) {
      getPmOptOptions = <GetPmOptOptions>[];
      json['getPmOptOptions'].forEach((v) {
        getPmOptOptions!.add(new GetPmOptOptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.getPmOptOptions != null) {
      data['getPmOptOptions'] =
          this.getPmOptOptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetPmOptOptions {
  String? value;
  String? label;

  GetPmOptOptions({this.value, this.label});

  GetPmOptOptions.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['label'] = this.label;
    return data;
  }
}
