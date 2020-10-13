import 'dart:convert';

import 'package:pizza_delivery_app/app/models/order_item_model.dart';

class OrderModel {
  OrderModel({
    this.id,
    this.paymentType,
    this.address,
    this.items,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return OrderModel(
      id: map['id'] as int,
      paymentType: map['paymentType'] as String,
      address: map['address'] as String,
      items: List<OrderItemModel>.from(
          map['items']?.map((x) => OrderItemModel.fromMap(x as Map<String, dynamic>)) as Iterable),
    );
  }

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final int id;
  final String paymentType;
  final String address;
  final List<OrderItemModel> items;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paymentType': paymentType,
      'address': address,
      'items': items?.map((x) => x?.toMap())?.toList(),
    };
  }


  String toJson() => json.encode(toMap());


}
