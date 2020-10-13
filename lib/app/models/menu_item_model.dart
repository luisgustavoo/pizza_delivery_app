import 'dart:convert';

class MenuItemModel {
  MenuItemModel({this.id, this.name, this.price});

  factory MenuItemModel.fromMap(Map<String, dynamic> map) {
    if (map != null) {
      return null;
    }

    return MenuItemModel(
      id: map['id'] as int,
      name: map['name'] as String,
      price: map['price'] as double,
    );
  }

  factory MenuItemModel.fromJson(String source) =>
      MenuItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final int id;
  final String name;
  final double price;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) {
      return true;
    }

    return o is MenuItemModel &&
        o.id == id &&
        o.name == name &&
        o.price == price;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ price.hashCode;
}
