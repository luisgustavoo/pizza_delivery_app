import 'dart:convert';

class CheckoutInputModel {
  CheckoutInputModel({
    this.userId,
    this.address,
    this.paymentType,
    this.itemsId,
  });

  factory CheckoutInputModel.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return CheckoutInputModel(
      userId: map['userId'] as int,
      address: map['address'] as String,
      paymentType: map['paymentType'] as String,
      itemsId: List<int>.from(map['itemsId'] as Iterable),
    );
  }

  factory CheckoutInputModel.fromJson(String source) =>
      CheckoutInputModel.fromMap(json.decode(source) as Map<String, dynamic>);

  int userId;
  String address;
  String paymentType;
  List<int> itemsId;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'address': address,
      'paymentType': paymentType,
      'itemsId': itemsId,
    };
  }

  String toJson() => json.encode(toMap());
}
