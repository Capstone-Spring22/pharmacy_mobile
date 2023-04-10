class SubCategory {
  String? id;
  String? subCategoryName;
  String? mainCategoryId;
  String? mainCategoryName;
  String? imageUrl;

  SubCategory(
      {this.id,
      this.subCategoryName,
      this.mainCategoryId,
      this.mainCategoryName,
      this.imageUrl});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subCategoryName = json['subCategoryName'];
    mainCategoryId = json['mainCategoryId'];
    mainCategoryName = json['mainCategoryName'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subCategoryName'] = subCategoryName;
    data['mainCategoryId'] = mainCategoryId;
    data['mainCategoryName'] = mainCategoryName;
    data['imageUrl'] = imageUrl;
    return data;
  }
}
