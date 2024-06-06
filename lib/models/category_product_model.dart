class CategoryProductModel {
  List<Results>? results;

  CategoryProductModel({this.results});

  CategoryProductModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
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

class Results {
  int? id;
  String? name;
  String? image;
  List<Productss>? products;

  Results({this.id, this.name, this.image, this.products});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    if (json['products'] != null) {
      products = <Productss>[];
      json['products'].forEach((v) {
        products!.add(new Productss.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Productss {
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

  Productss(
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
        this.productImages});

  Productss.fromJson(Map<String, dynamic> json) {
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
