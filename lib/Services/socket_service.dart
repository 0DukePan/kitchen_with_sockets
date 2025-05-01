import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart'; // For kDebugMode and debugPrint
import 'package:hungerz_kitchen/Models/order_model.dart'; // Corrected import path

class SocketService with ChangeNotifier {
  IO.Socket? _socket;
  // TODO: Replace with your actual backend URL
  final String _socketUrl = 'http://10.170.72.202:5000'; // Use PC's network IP and correct port
  List<Order> _orders = []; // Changed to List<Order>

  List<Order> get orders => _orders; // Changed return type

  // Expose the socket instance for potential direct use (optional)
  IO.Socket? get socket => _socket;

  SocketService() {
    _initializeSocket();
  }

  void _initializeSocket() {
    try {
      _socket = IO.io(_socketUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false, // Connect manually after setup
      });

      _socket!.connect();

      _socket!.onConnect((_) {
        debugPrint('Kitchen connected to socket server: ${_socket?.id}');
        _registerKitchen(); // Register this client as the kitchen
      });

      _socket!.on('new_kitchen_order', (data) {
        debugPrint('New kitchen order received: $data');
        _handleNewOrder(data);
      });

      // Optional: Handle event from backend confirming registration
      _socket!.on('kitchen_registered', (data) {
         debugPrint('Kitchen registration confirmed by server.');
         // You could potentially receive initial pending orders here
         // if (data is Map && data['activeOrders'] is List) { ... }
      });

      _socket!.onDisconnect((_) {
        debugPrint('Kitchen disconnected from socket server');
        // TODO: Implement reconnection logic if needed
      });

      _socket!.onError((error) {
        debugPrint('Socket Error: $error');
        // TODO: Handle connection errors more robustly
      });

      _socket!.onConnectError((error) {
        debugPrint('Socket Connection Error: $error');
         // TODO: Handle connection errors more robustly (e.g., retry logic)
      });

    } catch (e) {
      debugPrint('Error initializing socket: $e');
    }
  }

  void _registerKitchen() {
    if (_socket != null && _socket!.connected) {
      // Using a simple static ID here. In a real app, this might be
      // dynamically assigned or stored.
      const String kitchenId = 'main_kitchen_1';
      debugPrint('Registering kitchen with ID: $kitchenId');
      _socket!.emit('register_kitchen', {'kitchenId': kitchenId});
    } else {
       debugPrint('Cannot register kitchen: Socket not connected.');
    }
  }

  void _handleNewOrder(dynamic orderData) {
    // Assuming orderData is the complete order object (Map<String, dynamic>).
    // You should ideally parse this into a structured Order model.
    try {
      if (orderData is Map<String, dynamic>) {
        final newOrder = Order.fromJson(orderData);
        _orders.insert(0, newOrder); // Add new Order object to the top
        // Notify listeners (like the KitchenScreen) that the orders list has changed
        notifyListeners();
      } else {
         debugPrint('Received order data is not in expected format (Map<String, dynamic>).');
      }
    } catch (e) {
      debugPrint('Error parsing new order: $e');
      debugPrint('Received data: $orderData');
    }
  }

  // Method to clear all orders (e.g., for testing or specific UI actions)
  void clearOrders() {
    _orders = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _socket?.dispose();
    super.dispose();
  }
} 