class VendorModel {
  int? count;
  List<Vendors>? results;

  VendorModel({this.count, this.results});

  VendorModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['results'] != null) {
      results = <Vendors>[];
      json['results'].forEach((v) {
        results!.add(new Vendors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vendors {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? status;
  String? fcm;
  String? role;
  String? description;
  String? direction;
  String? distance;
  String? deliveryTime;
  String? freeDeliveryLimit;
  String? image;
  String? cover;
  List<Areas>? areas;

  Vendors(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.address,
        this.status,
        this.fcm,
        this.role,
        this.description,
        this.direction,
        this.distance,
        this.deliveryTime,
        this.freeDeliveryLimit,
        this.image,
        this.cover,
        this.areas});

  Vendors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    status = json['status'];
    fcm = json['fcm'];
    role = json['role'];
    description = json['description'];
    direction = json['direction'];
    distance = json['distance'];
    deliveryTime = json['delivery_time'];
    freeDeliveryLimit = json['free_delivery_limit'];
    image = json['image'];
    cover = json['cover'];
    if (json['areas'] != null) {
      areas = <Areas>[];
      json['areas'].forEach((v) {
        areas!.add(new Areas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['status'] = this.status;
    data['fcm'] = this.fcm;
    data['role'] = this.role;
    data['description'] = this.description;
    data['direction'] = this.direction;
    data['distance'] = this.distance;
    data['delivery_time'] = this.deliveryTime;
    data['free_delivery_limit'] = this.freeDeliveryLimit;
    data['image'] = this.image;
    data['cover'] = this.cover;
    if (this.areas != null) {
      data['areas'] = this.areas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Areas {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  DeliveryCost? deliveryCost;

  Areas(
      {this.id, this.name, this.createdAt, this.updatedAt, this.deliveryCost});

  Areas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deliveryCost = json['delivery_cost'] != null
        ? new DeliveryCost.fromJson(json['delivery_cost'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.deliveryCost != null) {
      data['delivery_cost'] = this.deliveryCost!.toJson();
    }
    return data;
  }
}

class DeliveryCost {
  int? id;
  String? cost;
  String? createdAt;
  String? updatedAt;
  int? userId;
  int? areaId;

  DeliveryCost(
      {this.id,
        this.cost,
        this.createdAt,
        this.updatedAt,
        this.userId,
        this.areaId});

  DeliveryCost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cost = json['cost'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    areaId = json['areaId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cost'] = this.cost;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    data['areaId'] = this.areaId;
    return data;
  }
}
