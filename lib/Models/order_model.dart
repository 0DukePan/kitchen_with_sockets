import 'package:flutter/material.dart';

class Order {
  final String id;
  final String tableId;
  final List<OrderItem> items;
  final DateTime createdAt;
  final String orderNumber;
  final String orderType;

  Order({
    required this.id,
    required this.tableId,
    required this.items,
    required this.createdAt,
    required this.orderNumber,
    required this.orderType,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsFromJson = json['items'] as List? ?? [];
    List<OrderItem> itemsList = itemsFromJson.map((itemJson) => OrderItem.fromJson(itemJson)).toList();

    return Order(
      id: json['orderId']?.toString() ?? json['_id']?.toString() ?? 'Unknown ID',
      orderNumber: json['orderNumber']?.toString() ?? 'N/A',
      tableId: json['tableId']?.toString() ?? 'Unknown Table',
      items: itemsList,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      orderType: json['orderType']?.toString() ?? 'N/A',
    );
  }
}

class OrderItem {
  final String productId;
  final String name;
  final int quantity;
  final List<String> addons;
  final String category;
  final String specialInstructions;
  bool isDelivered;

  OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.addons,
    required this.category,
    required this.specialInstructions,
    this.isDelivered = false,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    var addonsFromJson = json['addons'] as List? ?? [];
    List<String> addonsList = addonsFromJson.map((addon) => addon.toString()).toList();

    return OrderItem(
      productId: 'prod_${json['name'] ?? 'unknown'}',
      name: json['name']?.toString() ?? 'Unknown Item',
      quantity: json['quantity'] ?? 0,
      addons: addonsList,
      category: json['category']?.toString() ?? 'N/A',
      specialInstructions: json['specialInstructions']?.toString() ?? '',
      isDelivered: false,
    );
  }
} 