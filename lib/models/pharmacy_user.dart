// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PharmacyUser {
  num? phone;
  PharmacyUser({
    this.phone,
  });

  PharmacyUser copyWith({
    num? phone,
  }) {
    return PharmacyUser(
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phone': phone,
    };
  }

  factory PharmacyUser.fromMap(Map<String, dynamic> map) {
    return PharmacyUser(
      phone: map['phone'] != null ? map['phone'] as num : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PharmacyUser.fromJson(String source) =>
      PharmacyUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PharmacyUser(phone: $phone)';

  @override
  bool operator ==(covariant PharmacyUser other) {
    if (identical(this, other)) return true;

    return other.phone == phone;
  }

  @override
  int get hashCode => phone.hashCode;
}
