import 'package:untitled/model/product_dto.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/vendor_registration_screen_v1.dart';

import 'customer.dart';

class OfferDTO {
  int? id;
  String? offerName;
  String? offerCreatedDate;
  String? offerExpiryDate;
  String? offerCouponCode;
  double? offerDiscountAmount;
  ProductDTO? product;
  CustomerDTO? customer;

  OfferDTO({
    this.id,
    this.offerName,
    this.offerCreatedDate,
    this.offerExpiryDate,
    this.offerCouponCode,
    this.offerDiscountAmount,
    this.product,
    this.customer
  });

  Map toJson() => {
    "id": id,
    "offerName": offerName,
    "offerCreatedDate": offerCreatedDate,
    "offerExpiryDate": offerExpiryDate,
    "offerCouponCode": offerCouponCode,
    "offerDiscountAmount": offerDiscountAmount,
    "product": product,
    "customer": customer
  };

  factory OfferDTO.fromJson(Map<String, dynamic> json) {
    return OfferDTO(
        id: json["id"],
        offerName: json["offerName"],
        offerCreatedDate: json["offerCreatedDate"],
        offerExpiryDate: json["offerExpiryDate"],
        offerCouponCode: json["offerCouponCode"],
        offerDiscountAmount: json["offerDiscountAmount"],
        product: json["product"] == null ? null : ProductDTO.fromJson(json["product"]),
        customer: json["customer"] == null ? null : CustomerDTO.fromJson(json["customer"])
    );
  }
}