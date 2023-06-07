class CategoryModel {
  String categoryName;
  int to_spend;
  int spent;

  CategoryModel({
    required this.categoryName,
    required this.to_spend,
    required this.spent
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'to_spend': to_spend,
      'spent': spent,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        categoryName: json["categoryName"],
        to_spend: json["to_spend"],
        spent: json["spent"]
    );
  }
}