class MainCategory {
  String? id;
  String? categoryName;
  String? imageUrl;
  num? noOfProducts;

  MainCategory({this.id, this.categoryName, this.imageUrl, this.noOfProducts});

  MainCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    imageUrl = json['imageUrl'];
    noOfProducts = json['noOfProducts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['categoryName'] = categoryName;
    data['imageUrl'] = imageUrl;
    data['noOfProducts'] = noOfProducts;
    return data;
  }
}
