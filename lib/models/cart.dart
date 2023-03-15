// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String pid;
  final num quantity;
  final num price;
  const CartItem({
    required this.pid,
    required this.quantity,
    required this.price,
  });

  CartItem copyWith({
    String? pid,
    num? quantity,
    num? price,
  }) {
    return CartItem(
      pid: pid ?? this.pid,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pid': pid,
      'quantity': quantity,
      'price': price,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      pid: map['pid'] as String,
      quantity: map['quantity'] as num,
      price: map['price'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [pid, quantity, price];
}
