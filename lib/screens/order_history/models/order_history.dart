// ignore_for_file: public_member_api_docs, sort_constructors_first
class OrderHistory {
  String? id;
  String? pharmacistId;
  num? orderTypeId;
  String? orderTypeName;
  String? siteId;
  String? orderStatus;
  num? totalPrice;
  num? usedPoint;
  num? paymentMethodId;
  String? paymentMethod;
  bool? isPaid;
  String? note;
  String? createdDate;
  bool? needAcceptance;

  OrderHistory(
      {this.id,
      this.pharmacistId,
      this.orderTypeId,
      this.orderTypeName,
      this.siteId,
      this.orderStatus,
      this.totalPrice,
      this.usedPoint,
      this.paymentMethodId,
      this.paymentMethod,
      this.isPaid,
      this.note,
      this.createdDate,
      this.needAcceptance});

  OrderHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pharmacistId = json['pharmacistId'];
    orderTypeId = json['orderTypeId'];
    orderTypeName = json['orderTypeName'];
    siteId = json['siteId'];
    orderStatus = json['orderStatus'];
    totalPrice = json['totalPrice'];
    usedPoint = json['usedPoint'];
    paymentMethodId = json['paymentMethodId'];
    paymentMethod = json['paymentMethod'];
    isPaid = json['isPaid'];
    note = json['note'];
    createdDate = json['createdDate'];
    needAcceptance = json['needAcceptance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pharmacistId'] = pharmacistId;
    data['orderTypeId'] = orderTypeId;
    data['orderTypeName'] = orderTypeName;
    data['siteId'] = siteId;
    data['orderStatus'] = orderStatus;
    data['totalPrice'] = totalPrice;
    data['usedPoint'] = usedPoint;
    data['paymentMethodId'] = paymentMethodId;
    data['paymentMethod'] = paymentMethod;
    data['isPaid'] = isPaid;
    data['note'] = note;
    data['createdDate'] = createdDate;
    data['needAcceptance'] = needAcceptance;
    return data;
  }

  @override
  String toString() {
    return 'OrderHistory(id: $id, pharmacistId: $pharmacistId, orderTypeId: $orderTypeId, orderTypeName: $orderTypeName, siteId: $siteId, orderStatus: $orderStatus, totalPrice: $totalPrice, usedPoint: $usedPoint, paymentMethodId: $paymentMethodId, paymentMethod: $paymentMethod, isPaid: $isPaid, note: $note, createdDate: $createdDate, needAcceptance: $needAcceptance)';
  }
}
