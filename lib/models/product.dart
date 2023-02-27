// ignore_for_file: public_member_api_docs, sort_constructors_first
class PharmacyProduct {
  String? id;
  String? name;
  String? nameWithUnit;
  String? totalUnitOnly;
  String? subCategoryId;
  String? manufacturerId;
  bool? isPrescription;
  bool? isBatches;
  String? unitId;
  num? unitLevel;
  num? quantitative;
  num? sellQuantity;
  num? price;
  num? priceAfterDiscount;
  bool? isSell;
  String? barCode;
  ImageModel? imageModel;
  DiscountModel? discountModel;

  PharmacyProduct(
      {this.id,
      this.name,
      this.nameWithUnit,
      this.totalUnitOnly,
      this.subCategoryId,
      this.manufacturerId,
      this.isPrescription,
      this.isBatches,
      this.unitId,
      this.unitLevel,
      this.quantitative,
      this.sellQuantity,
      this.price,
      this.priceAfterDiscount,
      this.isSell,
      this.barCode,
      this.imageModel,
      this.discountModel});

  PharmacyProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameWithUnit = json['nameWithUnit'];
    totalUnitOnly = json['totalUnitOnly'];
    subCategoryId = json['subCategoryId'];
    manufacturerId = json['manufacturerId'];
    isPrescription = json['isPrescription'];
    isBatches = json['isBatches'];
    unitId = json['unitId'];
    unitLevel = json['unitLevel'];
    quantitative = json['quantitative'];
    sellQuantity = json['sellQuantity'];
    price = json['price'];
    priceAfterDiscount = json['priceAfterDiscount'];
    isSell = json['isSell'];
    barCode = json['barCode'];
    imageModel = json['imageModel'] != null
        ? ImageModel.fromJson(json['imageModel'])
        : null;
    discountModel = json['discountModel'] != null
        ? DiscountModel.fromJson(json['discountModel'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['nameWithUnit'] = nameWithUnit;
    data['totalUnitOnly'] = totalUnitOnly;
    data['subCategoryId'] = subCategoryId;
    data['manufacturerId'] = manufacturerId;
    data['isPrescription'] = isPrescription;
    data['isBatches'] = isBatches;
    data['unitId'] = unitId;
    data['unitLevel'] = unitLevel;
    data['quantitative'] = quantitative;
    data['sellQuantity'] = sellQuantity;
    data['price'] = price;
    data['priceAfterDiscount'] = priceAfterDiscount;
    data['isSell'] = isSell;
    data['barCode'] = barCode;
    if (imageModel != null) {
      data['imageModel'] = imageModel!.toJson();
    }
    if (discountModel != null) {
      data['discountModel'] = discountModel!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'PharmacyProduct(id: $id, name: $name, nameWithUnit: $nameWithUnit, totalUnitOnly: $totalUnitOnly, subCategoryId: $subCategoryId, manufacturerId: $manufacturerId, isPrescription: $isPrescription, isBatches: $isBatches, unitId: $unitId, unitLevel: $unitLevel, quantitative: $quantitative, sellQuantity: $sellQuantity, price: $price, priceAfterDiscount: $priceAfterDiscount, isSell: $isSell, barCode: $barCode, imageModel: $imageModel, discountModel: $discountModel)';
  }
}

class ImageModel {
  String? id;
  String? imageURL;

  ImageModel({this.id, this.imageURL});

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageURL = json['imageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['imageURL'] = imageURL;
    return data;
  }

  @override
  String toString() => 'ImageModel(id: $id, imageURL: $imageURL)';
}

class DiscountModel {
  String? title;
  String? reason;
  num? discountPercent;
  num? discountMoney;

  DiscountModel(
      {this.title, this.reason, this.discountPercent, this.discountMoney});

  DiscountModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    reason = json['reason'];
    discountPercent = json['discountPercent'];
    discountMoney = json['discountMoney'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['reason'] = reason;
    data['discountPercent'] = discountPercent;
    data['discountMoney'] = discountMoney;
    return data;
  }

  @override
  String toString() {
    return 'DiscountModel(title: $title, reason: $reason, discountPercent: $discountPercent, discountMoney: $discountMoney)';
  }
}
