// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:pharmacy_mobile/models/product.dart';

class CartItem extends Equatable {
  final PharmacyProduct product;
  final num quantity;
  final num price;
  const CartItem({
    required this.product,
    required this.quantity,
    required this.price,
  });

  CartItem copyWith({
    PharmacyProduct? product,
    num? quantity,
    num? price,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': product.toMap(),
      'quantity': quantity,
      'price': price,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: PharmacyProduct.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as num,
      price: map['price'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CartItem(product: $product, quantity: $quantity, price: $price)';

  @override
  bool operator ==(covariant CartItem other) {
    if (identical(this, other)) return true;

    return other.product == product &&
        other.quantity == quantity &&
        other.price == price;
  }

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode ^ price.hashCode;

  @override
  List<Object> get props => [product, quantity, price];
}
