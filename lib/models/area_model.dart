class AreaModel {
  List<Areas>? results;

  AreaModel({this.results});

  AreaModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Areas>[];
      json['results'].forEach((v) {
        results!.add(new Areas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Areas {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Areas({this.id, this.name, this.createdAt, this.updatedAt});

  Areas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
