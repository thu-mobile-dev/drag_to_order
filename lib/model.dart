import "package:flutter/material.dart";

@immutable
class Item {
  const Item({
    required this.price,
    required this.name,
    required this.image,
  });
  final int price; // ¥ 1 == 100
  final String name;
  final ImageProvider image;
  String get priceString => "¥ ${(price / 100.0).toStringAsFixed(1)}";
}

class Customer {
  Customer({
    required this.name,
    required this.image,
    List<Item>? items,
  }) : items = items ?? [];

  final String name;
  final ImageProvider image;
  final List<Item> items;

  String get totalPriceString {
    final price = items.fold<int>(0, (prev, item) => prev + item.price);
    return "¥ ${(price / 100.0).toStringAsFixed(1)}";
  }
}

// ignore: constant_identifier_names
const List<Item> test_items = [
  Item(
    name: "蒙德烤鱼",
    price: 990,
    image: AssetImage("assets/items/蒙德烤鱼.png"),
  ),
  Item(
    name: "野菇鸡肉串",
    price: 990,
    image: AssetImage("assets/items/野菇鸡肉串.png"),
  ),
  Item(
    name: "薄荷果冻",
    price: 990,
    image: AssetImage("assets/items/薄荷果冻.png"),
  ),
  Item(
    name: "炸萝卜丸子",
    price: 1990,
    image: AssetImage("assets/items/炸萝卜丸子.png"),
  ),
  Item(
    name: "满足沙拉",
    price: 1990,
    image: AssetImage("assets/items/满足沙拉.png"),
  ),
  Item(
    name: "庄园烤松饼",
    price: 1990,
    image: AssetImage("assets/items/庄园烤松饼.png"),
  ),
  Item(
    name: "蒙德土豆饼",
    price: 2990,
    image: AssetImage("assets/items/蒙德土豆饼.png"),
  ),
  Item(
    name: "假日果酿",
    price: 2990,
    image: AssetImage("assets/items/假日果酿.png"),
  ),
];

// ignore: non_constant_identifier_names
final List<Customer> test_customers = [
  Customer(
    name: "空",
    image: const AssetImage("assets/customers/空.jpg"),
  ),
  Customer(
    name: "荧",
    image: const AssetImage("assets/customers/荧.jpg"),
  ),
  Customer(
    name: "派蒙",
    image: const AssetImage("assets/customers/派蒙.jpg"),
  ),
];
