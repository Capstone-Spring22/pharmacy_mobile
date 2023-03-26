class ProductUnit {
  String? id;
  String? unitName;
  bool? isCountable;
  String? createdDate;
  bool? status;

  ProductUnit(
      {this.id,
      this.unitName,
      this.isCountable,
      this.createdDate,
      this.status});

  ProductUnit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitName = json['unitName'];
    isCountable = json['isCountable'];
    createdDate = json['createdDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unitName'] = unitName;
    data['isCountable'] = isCountable;
    data['createdDate'] = createdDate;
    data['status'] = status;
    return data;
  }
}
