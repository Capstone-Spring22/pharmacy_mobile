class Order {
  String? orderId;
  num? orderTypeId;
  String? siteId;
  String? pharmacistId;
  num? subTotalPrice;
  num? discountPrice;
  num? shippingPrice;
  num? totalPrice;
  num? usedPoint;
  num? payType;
  bool? isPaid;
  String? note;
  List<Vouchers>? vouchers;
  List<Products>? products;
  ReveicerInformation? reveicerInformation;
  VnpayInformation? vnpayInformation;
  OrderPickUp? orderPickUp;

  Order(
      {this.orderId,
      this.orderTypeId,
      this.siteId,
      this.pharmacistId,
      this.subTotalPrice,
      this.discountPrice,
      this.shippingPrice,
      this.totalPrice,
      this.usedPoint,
      this.payType,
      this.isPaid,
      this.note,
      this.vouchers,
      this.products,
      this.reveicerInformation,
      this.vnpayInformation,
      this.orderPickUp});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderTypeId = json['orderTypeId'];
    siteId = json['siteId'];
    pharmacistId = json['pharmacistId'];
    subTotalPrice = json['subTotalPrice'];
    discountPrice = json['discountPrice'];
    shippingPrice = json['shippingPrice'];
    totalPrice = json['totalPrice'];
    usedPoint = json['usedPoint'];
    payType = json['payType'];
    isPaid = json['isPaid'];
    note = json['note'];
    if (json['vouchers'] != null) {
      vouchers = <Vouchers>[];
      json['vouchers'].forEach((v) {
        vouchers!.add(Vouchers.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    reveicerInformation = json['reveicerInformation'] != null
        ? ReveicerInformation.fromJson(json['reveicerInformation'])
        : null;
    vnpayInformation = json['vnpayInformation'] != null
        ? VnpayInformation.fromJson(json['vnpayInformation'])
        : null;
    orderPickUp = json['orderPickUp'] != null
        ? OrderPickUp.fromJson(json['orderPickUp'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderId'] = orderId;
    data['orderTypeId'] = orderTypeId;
    data['siteId'] = siteId;
    data['pharmacistId'] = pharmacistId;
    data['subTotalPrice'] = subTotalPrice;
    data['discountPrice'] = discountPrice;
    data['shippingPrice'] = shippingPrice;
    data['totalPrice'] = totalPrice;
    data['usedPoint'] = usedPoint;
    data['payType'] = payType;
    data['isPaid'] = isPaid;
    data['note'] = note;
    if (vouchers != null) {
      data['vouchers'] = vouchers!.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (reveicerInformation != null) {
      data['reveicerInformation'] = reveicerInformation!.toJson();
    }
    if (vnpayInformation != null) {
      data['vnpayInformation'] = vnpayInformation!.toJson();
    }
    if (orderPickUp != null) {
      data['orderPickUp'] = orderPickUp!.toJson();
    }
    return data;
  }
}

class Vouchers {
  String? voucherId;

  Vouchers({this.voucherId});

  Vouchers.fromJson(Map<String, dynamic> json) {
    voucherId = json['voucherId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['voucherId'] = voucherId;
    return data;
  }
}

class Products {
  String? productId;
  num? quantity;
  num? originalPrice;
  num? discountPrice;

  Products(
      {this.productId, this.quantity, this.originalPrice, this.discountPrice});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    quantity = json['quantity'];
    originalPrice = json['originalPrice'];
    discountPrice = json['discountPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['quantity'] = quantity;
    data['originalPrice'] = originalPrice;
    data['discountPrice'] = discountPrice;
    return data;
  }
}

class ReveicerInformation {
  String? fullname;
  String? phoneNumber;
  String? email;
  bool? gender;
  String? cityId;
  String? districtId;
  String? wardId;
  String? homeAddress;

  ReveicerInformation(
      {this.fullname,
      this.phoneNumber,
      this.email,
      this.gender,
      this.cityId,
      this.districtId,
      this.wardId,
      this.homeAddress});

  ReveicerInformation.fromJson(Map<String, dynamic> json) {
    fullname = json['fullname'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    gender = json['gender'];
    cityId = json['cityId'];
    districtId = json['districtId'];
    wardId = json['wardId'];
    homeAddress = json['homeAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullname'] = fullname;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['gender'] = gender;
    data['cityId'] = cityId;
    data['districtId'] = districtId;
    data['wardId'] = wardId;
    data['homeAddress'] = homeAddress;
    return data;
  }
}

class VnpayInformation {
  String? vnpTransactionNo;
  String? vnpPayDate;

  VnpayInformation({this.vnpTransactionNo, this.vnpPayDate});

  VnpayInformation.fromJson(Map<String, dynamic> json) {
    vnpTransactionNo = json['vnp_TransactionNo'];
    vnpPayDate = json['vnp_PayDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vnp_TransactionNo'] = vnpTransactionNo;
    data['vnp_PayDate'] = vnpPayDate;
    return data;
  }
}

class OrderPickUp {
  String? datePickUp;
  String? timePickUp;

  OrderPickUp({this.datePickUp, this.timePickUp});

  OrderPickUp.fromJson(Map<String, dynamic> json) {
    datePickUp = json['datePickUp'];
    timePickUp = json['timePickUp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['datePickUp'] = datePickUp;
    data['timePickUp'] = timePickUp;
    return data;
  }
}
