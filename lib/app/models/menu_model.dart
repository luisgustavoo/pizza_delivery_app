import 'dart:convert';

import 'package:pizza_delivery_app/app/models/menu_item_model.dart';

class MenuModel {
  MenuModel({this.id, this.name, this.items});

  factory MenuModel.fromJson(String source) =>
      MenuModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return MenuModel(
      id: map['id'] as int,
      name: map['name'] as String,
      items: List<MenuItemModel>.from(map['items']
              ?.map((x) => MenuItemModel.fromMap(x as Map<String, dynamic>))
          as Iterable),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'items': items?.map((x) => x?.toMap())?.toList(),
    };
  }

  final int id;
  final String name;
  final List<MenuItemModel> items;

  String toJson() => json.encode(toMap());
}
