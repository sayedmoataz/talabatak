class ProductModel {
  int? count;
  int? pages;
  List<Products>? results;

  ProductModel({this.count, this.pages, this.results});

  ProductModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    pages = json['pages'];
    if (json['results'] != null) {
      results = <Products>[];
      json['results'].forEach((v) {
        results!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['pages'] = this.pages;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  String? title;
  String? description;
  String? price;
  bool? showPrice;
  bool? available;
  bool? featured;
  int? orders;
  String? createdAt;
  String? updatedAt;
  int? vendorId;
  int? categoryId;
  List<ProductImages>? productImages;
  List<OptionsGroups>? optionsGroups;
  User? user;
  Category? category;

  Products(
      {this.id,
        this.title,
        this.description,
        this.price,
        this.showPrice,
        this.available,
        this.featured,
        this.orders,
        this.createdAt,
        this.updatedAt,
        this.vendorId,
        this.categoryId,
        this.productImages,
        this.optionsGroups,
        this.user,
        this.category});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    showPrice = json['show_price'];
    available = json['available'];
    featured = json['featured'];
    orders = json['orders'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    vendorId = json['vendorId'];
    categoryId = json['categoryId'];
    if (json['productImages'] != null) {
      productImages = <ProductImages>[];
      json['productImages'].forEach((v) {
        productImages!.add(new ProductImages.fromJson(v));
      });
    }
    if (json['options_groups'] != null) {
      optionsGroups = <OptionsGroups>[];
      json['options_groups'].forEach((v) {
        optionsGroups!.add(new OptionsGroups.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    data['show_price'] = this.showPrice;
    data['available'] = this.available;
    data['featured'] = this.featured;
    data['orders'] = this.orders;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['vendorId'] = this.vendorId;
    data['categoryId'] = this.categoryId;
    if (this.productImages != null) {
      data['productImages'] =
          this.productImages!.map((v) => v.toJson()).toList();
    }
    if (this.optionsGroups != null) {
      data['options_groups'] =
          this.optionsGroups!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class ProductImages {
  int? id;
  String? image;

  ProductImages({this.id, this.image});

  ProductImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}

class OptionsGroups {
  int? id;
  String? name;
  String? type;
  List<Options>? options;

  OptionsGroups({this.id, this.name, this.type, this.options});

  OptionsGroups.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  int? id;
  String? name;
  String? value;

  Options({this.id, this.name, this.value});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  Vendor? vendor;

  User({this.id, this.name, this.email, this.phone, this.image, this.vendor});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    vendor =
    json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['image'] = this.image;
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
    }
    return data;
  }
}

class Vendor {
  int? id;
  String? status;
  String? description;
  String? cover;
  String? deliveryTime;
  String? direction;
  String? freeDeliveryLimit;
  String? distance;
  String? createdAt;
  String? updatedAt;
  int? userId;

  Vendor(
      {this.id,
        this.status,
        this.description,
        this.cover,
        this.deliveryTime,
        this.direction,
        this.freeDeliveryLimit,
        this.distance,
        this.createdAt,
        this.updatedAt,
        this.userId});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    description = json['description'];
    cover = json['cover'];
    deliveryTime = json['delivery_time'];
    direction = json['direction'];
    freeDeliveryLimit = json['free_delivery_limit'];
    distance = json['distance'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['description'] = this.description;
    data['cover'] = this.cover;
    data['delivery_time'] = this.deliveryTime;
    data['direction'] = this.direction;
    data['free_delivery_limit'] = this.freeDeliveryLimit;
    data['distance'] = this.distance;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? image;

  Category({this.id, this.name, this.image});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
