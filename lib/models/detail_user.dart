// ignore_for_file: public_member_api_docs, sort_constructors_first
class DetailUser {
  String? customerId;
  String? fullName;
  String? email;
  String? phoneNo;
  String? dob;
  int? gender;
  String? imageUrl;
  List<CustomerAddressList>? customerAddressList;

  DetailUser(
      {this.customerId,
      this.fullName,
      this.email,
      this.phoneNo,
      this.dob,
      this.gender,
      this.imageUrl,
      this.customerAddressList});

  DetailUser.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    fullName = json['fullName'];
    email = json['email'];
    phoneNo = json['phoneNo'];
    dob = json['dob'];
    gender = json['gender'];
    imageUrl = json['imageUrl'];
    if (json['customerAddressList'] != null) {
      customerAddressList = <CustomerAddressList>[];
      json['customerAddressList'].forEach((v) {
        customerAddressList!.add(CustomerAddressList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['fullName'] = fullName;
    data['email'] = email;
    data['phoneNo'] = phoneNo;
    data['dob'] = dob;
    data['gender'] = gender;
    data['imageUrl'] = imageUrl;
    if (customerAddressList != null) {
      data['customerAddressList'] =
          customerAddressList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'DetailUser(customerId: $customerId, fullName: $fullName, email: $email, phoneNo: $phoneNo, dob: $dob, gender: $gender, imageUrl: $imageUrl, customerAddressList: $customerAddressList)';
  }
}

class CustomerAddressList {
  String? id;
  String? addressId;
  String? cityId;
  String? districtId;
  String? wardId;
  String? homeAddress;
  String? fullyAddress;
  bool? isMainAddress;

  CustomerAddressList(
      {this.id,
      this.addressId,
      this.cityId,
      this.districtId,
      this.wardId,
      this.homeAddress,
      this.fullyAddress,
      this.isMainAddress});

  CustomerAddressList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressId = json['addressId'];
    cityId = json['cityId'];
    districtId = json['districtId'];
    wardId = json['wardId'];
    homeAddress = json['homeAddress'];
    fullyAddress = json['fullyAddress'];
    isMainAddress = json['isMainAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['addressId'] = addressId;
    data['cityId'] = cityId;
    data['districtId'] = districtId;
    data['wardId'] = wardId;
    data['homeAddress'] = homeAddress;
    data['fullyAddress'] = fullyAddress;
    data['isMainAddress'] = isMainAddress;
    return data;
  }

  @override
  String toString() {
    return 'CustomerAddressList(id: $id, addressId: $addressId, cityId: $cityId, districtId: $districtId, wardId: $wardId, homeAddress: $homeAddress, fullyAddress: $fullyAddress, isMainAddress: $isMainAddress)';
  }
}
