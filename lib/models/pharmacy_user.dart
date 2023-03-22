import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PharmacyUser {
  String? id;
  String? name;
  String? email;
  num? status;
  String? roleName;
  String? token;
  String? imageURL;
  String? phoneNo;
  PharmacyUser({
    this.id,
    this.name,
    this.email,
    this.status,
    this.roleName,
    this.token,
    this.imageURL,
    this.phoneNo,
  });

  PharmacyUser copyWith({
    String? id,
    String? name,
    String? email,
    num? status,
    String? roleName,
    String? token,
    String? imageURL,
    String? phoneNo,
  }) {
    return PharmacyUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      status: status ?? this.status,
      roleName: roleName ?? this.roleName,
      token: token ?? this.token,
      imageURL: imageURL ?? this.imageURL,
      phoneNo: phoneNo ?? this.phoneNo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'status': status,
      'roleName': roleName,
      'token': token,
      'imageURL': imageURL,
      'phoneNo': phoneNo,
    };
  }

  factory PharmacyUser.fromMap(Map<String, dynamic> map) {
    return PharmacyUser(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      status: map['status'] != null ? map['status'] as num : null,
      roleName: map['roleName'] != null ? map['roleName'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      imageURL: map['imageURL'] != null ? map['imageURL'] as String : null,
      phoneNo: map['phoneNo'] != null ? map['phoneNo'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PharmacyUser.fromJson(String source) =>
      PharmacyUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PharmacyUser(id: $id, name: $name, email: $email, status: $status, roleName: $roleName, token: $token, imageURL: $imageURL, phoneNo: $phoneNo)';
  }

  @override
  bool operator ==(covariant PharmacyUser other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.status == status &&
        other.roleName == roleName &&
        other.token == token &&
        other.imageURL == imageURL &&
        other.phoneNo == phoneNo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        status.hashCode ^
        roleName.hashCode ^
        token.hashCode ^
        imageURL.hashCode ^
        phoneNo.hashCode;
  }
}
