// ignore_for_file: public_member_api_docs, sort_constructors_first

class CartItem {
  String? productId;
  num? quantity;
  String? productName;
  String? productImageUrl;
  num? price;
  num? priceAfterDiscount;
  num? priceTotal;

  CartItem(
      {this.productId,
      this.quantity,
      this.productName,
      this.productImageUrl,
      this.price,
      this.priceAfterDiscount,
      this.priceTotal});

  CartItem.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    quantity = json['quantity'];
    productName = json['productName'];
    productImageUrl = json['productImageUrl'];
    price = json['price'];
    priceAfterDiscount = json['priceAfterDiscount'];
    priceTotal = json['priceTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['quantity'] = quantity;
    data['productName'] = productName;
    data['productImageUrl'] = productImageUrl;
    data['price'] = price;
    data['priceAfterDiscount'] = priceAfterDiscount;
    data['priceTotal'] = priceTotal;
    return data;
  }

  @override
  bool operator ==(covariant CartItem other) {
    if (identical(this, other)) return true;

    return other.productId == productId &&
        other.quantity == quantity &&
        other.productName == productName &&
        other.productImageUrl == productImageUrl &&
        other.price == price &&
        other.priceAfterDiscount == priceAfterDiscount &&
        other.priceTotal == priceTotal;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        quantity.hashCode ^
        productName.hashCode ^
        productImageUrl.hashCode ^
        price.hashCode ^
        priceAfterDiscount.hashCode ^
        priceTotal.hashCode;
  }
}
