class ProductDTO {
  int? id;
  String? productName;
  String? productDescription;
  double? price;

  ProductDTO({
    this.id,
    this.productName,
    this.productDescription,
    this.price
  });

  Map toJson() => {
    "id": id,
    "productName": productName,
    "productDescription": productDescription,
    "price": price
  };

  factory ProductDTO.fromJson(Map<String, dynamic> json) {
    return ProductDTO(
      id: json["id"],
      productName: json["productName"],
      productDescription: json["productDescription"],
      price: json["price"]
    );
  }
}
