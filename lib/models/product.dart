// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class PharmacyProduct extends Equatable {
  final String id;
  final String name;
  final String img;
  final num price;
  const PharmacyProduct({
    required this.id,
    required this.name,
    required this.img,
    required this.price,
  });

  PharmacyProduct copyWith({
    String? id,
    String? name,
    String? img,
    num? price,
  }) {
    return PharmacyProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      img: img ?? this.img,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'img': img,
      'price': price,
    };
  }

  factory PharmacyProduct.fromMap(Map<String, dynamic> map) {
    return PharmacyProduct(
      id: map['id'] as String,
      name: map['name'] as String,
      img: map['img'] as String,
      price: map['price'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory PharmacyProduct.fromJson(String source) =>
      PharmacyProduct.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, img: $img, price: $price)';
  }

  @override
  bool operator ==(covariant PharmacyProduct other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.img == img &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ img.hashCode ^ price.hashCode;
  }

  @override
  List<Object> get props => [id, name, img, price];
}

List<PharmacyProduct> listProducts = [
  PharmacyProduct(
    id: "01",
    name:
        "Bột nước mát Datino giúp thanh nhiệt, giải độc, mát gan hộp 10 gói x 8g",
    img:
        "https://cdn.tgdd.vn/Products/Images/7027/286705/bot-nuoc-mat-datino-thanh-nhiet-giai-doc-mat-gan-hop-10-goi-x-8g-mac-dinh-2.jpg",
    price: 42000,
  ),
  PharmacyProduct(
    id: "02",
    name: "Bao cao su Dolphi classic vừa khít, thoải mái 52mm hộp 3 cái",
    img:
        "https://cdn.tgdd.vn/Products/Images/2519/260137/dolphi-classic-size-52mm-hop-3-cai-1.jpg",
    price: 18500,
  ),
  PharmacyProduct(
    id: "03",
    name: "Hauora Velvet Power hỗ trợ tăng cường sinh lý nam hộp 8 viên",
    img:
        "https://cdn.tgdd.vn/Products/Images/7013/246530/haurora-velvet-power-hop-8vien-mac-dinh-2.jpg",
    price: 285000,
  ),
  PharmacyProduct(
    id: "04",
    name: "Mặt nạ Dermal collagen dưa leo dưỡng ẩm, da mịn màng miếng 23g",
    img:
        "https://cdn.tgdd.vn/Products/Images/6653/199841/mat-na-cap-am-lam-diu-phuc-hoi-da-dermal-dua-leo-mac-dinh-2.jpg",
    price: 7600,
  ),
];
