class CartModel {
  String? message;
  Cart? cart;

  CartModel({this.message, this.cart});

  CartModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    cart = json['cart'] != null ? new Cart.fromJson(json['cart']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.cart != null) {
      data['cart'] = this.cart!.toJson();
    }
    return data;
  }
}

class Cart {
  int? id;
  int? totalQuantity;
  String? total;
  String? createdAt;
  String? updatedAt;
  int? userId;
  List<CartProducts>? cartProducts;

  Cart(
      {this.id,
        this.totalQuantity,
        this.total,
        this.createdAt,
        this.updatedAt,
        this.userId,
        this.cartProducts});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalQuantity = json['total_quantity'];
    total = json['total'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    if (json['cart_products'] != null) {
      cartProducts = <CartProducts>[];
      json['cart_products'].forEach((v) {
        cartProducts!.add(new CartProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['total_quantity'] = this.totalQuantity;
    data['total'] = this.total;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    if (this.cartProducts != null) {
      data['cart_products'] =
          this.cartProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartProducts {
  int? id;
  int? quantity;
  String? notes;
  var subtotal;
  var total;
  bool? ordered;
  String? createdAt;
  String? updatedAt;
  int? cartId;
  int? orderId;
  int? productId;
  Product? product;
  List<Options>? options;

  CartProducts(
      {this.id,
        this.quantity,
        this.notes,
        this.subtotal,
        this.total,
        this.ordered,
        this.createdAt,
        this.updatedAt,
        this.cartId,
        this.orderId,
        this.productId,
        this.product,
        this.options});

  CartProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    notes = json['notes'];
    subtotal = json['subtotal'];
    total = json['total'];
    ordered = json['ordered'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    cartId = json['cartId'];
    orderId = json['orderId'];
    productId = json['productId'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
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
    data['quantity'] = this.quantity;
    data['notes'] = this.notes;
    data['subtotal'] = this.subtotal;
    data['total'] = this.total;
    data['ordered'] = this.ordered;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['cartId'] = this.cartId;
    data['orderId'] = this.orderId;
    data['productId'] = this.productId;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int? id;
  String? title;
  String? description;
  var price;
  bool? available;
  bool? featured;
  int? orders;
  String? createdAt;
  String? updatedAt;
  int? vendorId;
  int? categoryId;
  List<ProductImages>? productImages;

  Product(
      {this.id,
        this.title,
        this.description,
        this.price,
        this.available,
        this.featured,
        this.orders,
        this.createdAt,
        this.updatedAt,
        this.vendorId,
        this.categoryId,
        this.productImages});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
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

class Options {
  int? id;
  String? name;
  var value;
  String? createdAt;
  String? updatedAt;
  int? optionsGroupId;
  CartProductOption? cartProductOption;

  Options(
      {this.id,
        this.name,
        this.value,
        this.createdAt,
        this.updatedAt,
        this.optionsGroupId,
        this.cartProductOption});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    optionsGroupId = json['optionsGroupId'];
    cartProductOption = json['cart_product_option'] != null
        ? new CartProductOption.fromJson(json['cart_product_option'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['optionsGroupId'] = this.optionsGroupId;
    if (this.cartProductOption != null) {
      data['cart_product_option'] = this.cartProductOption!.toJson();
    }
    return data;
  }
}

class CartProductOption {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? cartProductId;
  int? optionId;

  CartProductOption(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.cartProductId,
        this.optionId});

  CartProductOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    cartProductId = json['cartProductId'];
    optionId = json['optionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['cartProductId'] = this.cartProductId;
    data['optionId'] = this.optionId;
    return data;
  }
}
