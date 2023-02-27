// ignore_for_file: public_member_api_docs, sort_constructors_first

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
