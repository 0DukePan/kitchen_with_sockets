import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:hungerz_kitchen/Models/order_model.dart';

class ApiService {
  // TODO: Replace with your actual backend URL (same as SocketService)
  final String _baseUrl = 'http://10.170.72.202:5000/api'; // Base URL for API endpoints

  // Fetch completed orders for the "Past Orders" screen
  Future<List<Order>> fetchCompletedOrders({int limit = 50}) async {
    final Uri uri = Uri.parse('$_baseUrl/orders/kitchen/completed?limit=$limit');
    log('Fetching completed orders from: $uri');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          // TODO: Add authentication headers if needed (e.g., Authorization: Bearer token)
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('orders') && responseData['orders'] is List) {
          final List<dynamic> ordersJson = responseData['orders'];
          final List<Order> orders = ordersJson
              .map((jsonItem) {
                try {
                  // Adapt the Order.fromJson if the API payload structure differs slightly
                  // Ensure all necessary fields (id, orderNumber, items, orderType, status, createdAt, updatedAt)
                  // are present in the JSON and parsed correctly.
                  return Order.fromJson(jsonItem as Map<String, dynamic>);
                } catch (e) {
                  log('Error parsing completed order item: $e\nJSON: $jsonItem');
                  return null; // Skip orders that fail parsing
                }
              })
              .whereType<Order>() // Filter out nulls
              .toList();
          log('Successfully fetched and parsed ${orders.length} completed orders.');
          return orders;
        } else {
          log('Error: Completed orders response missing "orders" list or is not a list.');
          throw Exception('Invalid response format for completed orders');
        }
      } else {
        log('Error fetching completed orders: Status code ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to load completed orders (Status code: ${response.statusCode})');
      }
    } catch (e) {
      log('Network or parsing error fetching completed orders: $e');
      // Rethrow the exception to be handled by the FutureBuilder
      throw Exception('Failed to load completed orders: $e');
    }
  }

  // TODO: Add other API methods if needed (e.g., update order status)
} 