import 'package:flutter/material.dart';

class Order {
  final String id;
  final String tableId;
  final List<OrderItem> items;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String orderNumber;
  final String orderType;
  final String? status;

  Order({
    required this.id,
    required this.tableId,
    required this.items,
    required this.createdAt,
    this.updatedAt,
    required this.orderNumber,
    required this.orderType,
    this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsFromJson = json['items'] as List? ?? [];
    List<OrderItem> itemsList = itemsFromJson.map((itemJson) => OrderItem.fromJson(itemJson)).toList();

    DateTime? _parseDateTime(String? dateString) {
      if (dateString == null) return null;
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return null;
      }
    }

    return Order(
      id: json['id']?.toString() ?? json['orderId']?.toString() ?? json['_id']?.toString() ?? 'Unknown ID',
      orderNumber: json['orderNumber']?.toString() ?? 'N/A',
      tableId: json['tableId']?.toString() ?? 'Unknown Table',
      items: itemsList,
      createdAt: _parseDateTime(json['createdAt']?.toString()) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updatedAt']?.toString()),
      orderType: json['orderType']?.toString() ?? 'N/A',
      status: json['status']?.toString(),
    );
  }
}

class OrderItem {
  final String productId;
  final String name;
  final int quantity;
  final List<String> addons;
  final String? category;
  final String specialInstructions;
  bool isDelivered;

  OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    this.addons = const [],
    this.category,
    required this.specialInstructions,
    this.isDelivered = false,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    final String parsedProductId = json['productId']?.toString() ?? 'prod_${json['name'] ?? 'unknown'}';
    var addonsFromJson = json['addons'] as List? ?? [];
    List<String> addonsList = addonsFromJson.map((addon) => addon.toString()).toList();

    return OrderItem(
      productId: parsedProductId,
      name: json['name']?.toString() ?? 'Unknown Item',
      quantity: json['quantity'] as int? ?? 0,
      addons: addonsList,
      category: json['category']?.toString(),
      specialInstructions: json['specialInstructions']?.toString() ?? '',
      isDelivered: false,
    );
  }
} 