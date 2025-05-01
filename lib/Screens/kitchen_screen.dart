import 'package:flutter/material.dart';
import 'package:hungerz_kitchen/Services/socket_service.dart';
import 'package:hungerz_kitchen/Models/order_model.dart'; // Import Order model
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // Import StaggeredGrid
// import 'package:intl/intl.dart'; // No longer needed for HH:mm formatting
import 'package:animation_wrappers/animation_wrappers.dart'; // Import animations used in home.dart
import 'dart:developer'; // For log
import 'dart:async'; // Import async library for Timer
import 'package:hungerz_kitchen/Theme/colors.dart' as theme_colors; // Import colors with prefix
import 'package:hungerz_kitchen/Components/custom_circular_button.dart'; // Import CustomButton
import 'package:hungerz_kitchen/Routes/routes.dart'; // Import PageRoutes

// Custom Clipper from home.dart (assuming it's needed for the card shape)
class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    var curXPos = 0.0;
    var curYPos = size.height;
    var increment = size.width / 20;
    while (curXPos < size.width) {
      curXPos += increment;
      curYPos = curYPos == size.height ? size.height - 8 : size.height;
      path.lineTo(curXPos, curYPos);
    }
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}


class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  late final SocketService _socketService;
  Map<String, int> _deliveredItemsCount = {};
  Timer? _timer; // Add a Timer variable

  // --- Timer and Color Configuration ---
  // Define time thresholds (adjust these values based on kitchen needs)
  static const Duration yellowThreshold = Duration(minutes: 5);
  static const Duration redThreshold = Duration(minutes: 10);

  // Define colors directly within the state for reliable access
  static const Color _orderGreen = theme_colors.orderGreen; // Use prefix
  static const Color _orderYellow = theme_colors.orderYellow; // Use prefix
  static const Color _orderRed = theme_colors.orderRed; // Use prefix

  // Colors are now imported from Theme/colors.dart:
  // orderGreen, orderYellow, orderRed
  // --------------------------------------

  @override
  void initState() {
    super.initState();
    // Consider using a Provider or GetIt for service access if needed elsewhere
    _socketService = SocketService();
    _socketService.addListener(_onOrdersChanged);
    _initializeDeliveredCounts();
    _startTimer();
    log("KitchenScreen initState completed. Timer started.");
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      } else {
        timer.cancel();
      }
    });
  }

  void _initializeDeliveredCounts() {
     // Initialize based on current state of orders from service
    _deliveredItemsCount = {
      for (var order in _socketService.orders) order.id: _countDelivered(order.items)
    };
  }

  int _countDelivered(List<OrderItem> items) {
    return items.where((item) => item.isDelivered).length;
  }

  void _onOrdersChanged() {
    if (mounted) {
      setState(() {
        // Re-initialize counts when orders list changes (new order added)
        _initializeDeliveredCounts();
        log('Orders updated via SocketService, rebuilding UI. Count: ${_socketService.orders.length}');
      });
    }
  }

  @override
  void dispose() {
    log("Disposing KitchenScreen. Cancelling timer.");
    _timer?.cancel(); // IMPORTANT: Cancel the timer
    _socketService.removeListener(_onOrdersChanged);
    // Decide whether to dispose the service here or manage it globally
    // _socketService.dispose();
    super.dispose();
  }

 void _markItemDelivered(String orderId, String productId, int itemIndex) {
    final orderIndex = _socketService.orders.indexWhere((o) => o.id == orderId);
    if (orderIndex != -1) {
      // Ensure bounds check for itemIndex
      if (itemIndex >= 0 && itemIndex < _socketService.orders[orderIndex].items.length) {
        final item = _socketService.orders[orderIndex].items[itemIndex];
        // Check productId for extra safety, though index should be correct
        if (item.productId == productId && !item.isDelivered) {
          setState(() {
            item.isDelivered = true;
            _deliveredItemsCount[orderId] = (_deliveredItemsCount[orderId] ?? 0) + 1;

            // Check if all items in this order are delivered
            if (_deliveredItemsCount[orderId] == _socketService.orders[orderIndex].items.length) {
              log('Order $orderId completed.');
              // Add a slight delay before removing the card for visual feedback
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                   setState(() {
                     // Remove order safely by index
                     if (orderIndex < _socketService.orders.length && _socketService.orders[orderIndex].id == orderId) {
                        _socketService.orders.removeAt(orderIndex);
                        _deliveredItemsCount.remove(orderId);
                        log('Order $orderId removed from UI.');
                     } else {
                        log('Error removing order $orderId: index mismatch or order already removed.');
                        // Handle potential race condition by re-checking or just logging
                        _onOrdersChanged(); // Force refresh from service state if needed
                     }
                   });
                }
              });
              // TODO: Optionally notify backend that order is ready?
              // _socketService.socket?.emit('order_ready', { 'orderId': orderId });
            }
          });
        }
      } else {
         log('Error marking item delivered: Invalid itemIndex $itemIndex for order $orderId');
      }
    } else {
      log('Error marking item delivered: Order ID $orderId not found');
    }
 }

  // Helper function to format duration as MM:SS
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    // Handle negative durations if createdAt is somehow in the future
    final totalSeconds = duration.inSeconds.abs();
    final minutes = twoDigits((totalSeconds ~/ 60) % 60); // Modulo 60 for minutes part
    final seconds = twoDigits(totalSeconds % 60);
    // For durations longer than an hour, you might want HH:MM:SS
    // if (totalSeconds >= 3600) {
    //    final hours = twoDigits(totalSeconds ~/ 3600);
    //    return "$hours:$minutes:$seconds";
    // }
    return "$minutes:$seconds";
  }

  // Helper function to get header color based on elapsed time
  Color _getHeaderColorForElapsedTime(Duration elapsed) {
    if (elapsed.isNegative) return _orderGreen;
    if (elapsed >= redThreshold) return _orderRed;
    if (elapsed >= yellowThreshold) return _orderYellow;
    return _orderGreen;
  }


  @override
  Widget build(BuildContext context) {
    // Define text colors used within the build method for clarity
    const Color headerTextColor = Colors.white; // Text on colored headers is white
    final Color? itemStrikeThroughColor = theme_colors.strikeThroughColor; // From colors.dart
    final Color itemBodyTextColor = theme_colors.textColor; // From colors.dart (dark grey for content)
    final Color appBarTitleColor = Theme.of(context).textTheme.titleMedium?.color ?? Colors.black; // Use theme or fallback

    // Get theme colors here to pass them down
    const Color currentOrderGreen = _orderGreen;   // from colors.dart
    const Color currentOrderYellow = _orderYellow; // from colors.dart
    const Color currentOrderRed = _orderRed;     // from colors.dart

    return Scaffold(
      appBar: AppBar(
         automaticallyImplyLeading: false,
         backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Match background
         elevation: 0, // Remove shadow to match image
         titleSpacing: 12.0, // Adjust spacing if needed
         title: FadedScaleAnimation(
           child: RichText(
               text: TextSpan(children: <TextSpan>[
             TextSpan(
                 text: 'chaway za3im rghaya', // Hardcoded name, consider using AppConfig
                 style: Theme.of(context)
                     .textTheme
                     .titleMedium! // Use theme's titleMedium
                     .copyWith(
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: appBarTitleColor // Ensure contrast
                      )
                 ),
             TextSpan(
                 text: 'KITCHEN',
                 style: Theme.of(context).textTheme.titleMedium!.copyWith(
                     color: Theme.of(context).primaryColor, // Use primary color for accent
                     letterSpacing: 1,
                     fontWeight: FontWeight.bold)),
           ])),
           fadeDuration: const Duration(milliseconds: 400),
           scaleDuration: const Duration(milliseconds: 400),
         ),
         actions: [
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Adjust padding
             child: FadedScaleAnimation(
               // Use CustomButton for the "Past Orders" action
               child: CustomButton(
                   padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10), // Adjust padding for button size
                   leading: Icon(
                     Icons.history,
                     color: Colors.white, // Icon color on red button
                     size: 16,
                   ),
                   // Ensure title is a Text widget for styling
                   title: Text(
                     'Past Orders', // Use space if needed '  Past Orders'
                     style: Theme.of(context)
                         .textTheme
                         .bodyLarge! // bodyLarge is white text per theme
                         .copyWith(fontWeight: FontWeight.bold, fontSize: 14), // Adjust font size
                   ),
                   onTap: () {
                       try {
                           // Use named route defined in routes.dart
                           Navigator.pushNamed(context, PageRoutes.pastOrders);
                       } catch (e) {
                          log('Error navigating to Past Orders: $e. Ensure route "${PageRoutes.pastOrders}" is set up.');
                       }
                   }),
               fadeDuration: const Duration(milliseconds: 400),
               scaleDuration: const Duration(milliseconds: 400),
             ),
           ),
         ],
      ),
      body: FadedSlideAnimation(
        beginOffset: const Offset(0.0, 0.3),
        endOffset: Offset.zero,
        slideCurve: Curves.linearToEaseOut,
         child: Container(
           // Use theme surface color for the grid background
           color: Theme.of(context).colorScheme.surface, // Typically a light grey (0xffF8F9FD)
           child: _socketService.orders.isEmpty
               ? Center(
                   child: FadedScaleAnimation(
                       child: Text('No Active Orders', style: TextStyle(color: itemBodyTextColor)),
                       fadeDuration: const Duration(milliseconds: 400),
                       scaleDuration: const Duration(milliseconds: 400),
                       ))
               : SingleChildScrollView( // Make grid scrollable if content overflows
                 padding: const EdgeInsets.all(10.0), // Padding around the grid
                 child: StaggeredGrid.count(
                     crossAxisCount: 4, // 4 columns as per image
                     mainAxisSpacing: 10.0, // Vertical spacing
                     crossAxisSpacing: 10.0, // Horizontal spacing
                     children: List.generate(_socketService.orders.length, (int index) {
                       // Check index bounds before accessing order
                       if (index < _socketService.orders.length) {
                          final order = _socketService.orders[index];
                          return _buildOrderCard(context, order, itemStrikeThroughColor, itemBodyTextColor, headerTextColor);
                       } else {
                          // Handle potential index out of bounds during rebuilds
                          log("Error: Attempted to build card for index $index, but orders length is ${_socketService.orders.length}");
                          return const SizedBox.shrink(); // Return empty widget
                       }
                     }),
                   ),
               ),
         ),
      ),
    );
  }

  // Updated buildOrderCard to include timer logic, refined UI, and removed addons
  Widget _buildOrderCard(BuildContext context, Order order, Color? strikeThroughColor, Color bodyTextColor, Color headerTextColor) {

    // --- Calculate time and color ---
    // Ensure createdAt is in local time for accurate difference calculation
    final Duration elapsed = DateTime.now().difference(order.createdAt.toLocal());
    final String elapsedTimeString = _formatDuration(elapsed);
    final Color currentHeaderColor = _getHeaderColorForElapsedTime(elapsed);
    // -----------------------------

    // Text Styles defined locally for clarity
    final headerTextStyle = Theme.of(context).textTheme.bodyLarge!.copyWith( // bodyLarge is white
                            color: headerTextColor, // Explicitly set white
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          );
    final headerSubTextStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: headerTextColor.withOpacity(0.85), // Slightly dimmed white
                            fontSize: 10,
                          );
     final headerTimeStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: headerTextColor, // Explicitly set white
                            fontSize: 16, // Larger font for time
                            fontWeight: FontWeight.bold,
                          );
     final itemTextStyle = Theme.of(context).textTheme.titleMedium!.copyWith( // titleMedium is black/bold
                          fontWeight: FontWeight.normal, // Make item name normal weight like image
                          fontSize: 14, // Adjust font size
                          color: bodyTextColor, // Use dark text color
                         );
     final itemQuantityStyle = itemTextStyle.copyWith(fontWeight: FontWeight.bold); // Bold quantity
     final instructionTextStyle = Theme.of(context).textTheme.bodyMedium!.copyWith( // Default bodyMedium
                          color: bodyTextColor.withOpacity(0.8), // Slightly dimmed body text
                          fontWeight: FontWeight.w300, // Lighter weight for instructions
                          fontSize: 12 // Smaller font for instructions
                        );

    return ClipPath(
      clipper: CustomClipPath(), // Use the jagged edge clipper
      child: FadedScaleAnimation(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor, // White background for the main card content
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Card Header ---
              Container(
                color: currentHeaderColor, // Apply time-based background color
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Consistent padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text( order.orderType, style: headerTextStyle, ),
                        const SizedBox(height: 4),
                        Text( order.orderNumber, style: headerSubTextStyle, )
                      ],
                    ),
                    Text( elapsedTimeString, style: headerTimeStyle, ),
                  ],
                ),
              ),
              // --- Card Body (Item List) ---
               ListView.builder(
                  physics: const NeverScrollableScrollPhysics(), // Disable nested scrolling
                  shrinkWrap: true, // Fit content
                  padding: const EdgeInsets.symmetric(vertical: 4.0), // Padding for the list
                  itemCount: order.items.length,
                  itemBuilder: (context, itemIndex) {
                    // Check item index bounds
                    if (itemIndex >= order.items.length) return const SizedBox.shrink();
                    final item = order.items[itemIndex];

                    // Determine text color and decoration based on delivery status
                    final currentItemTextStyle = itemTextStyle.copyWith(
                       color: item.isDelivered ? strikeThroughColor : bodyTextColor,
                       decoration: item.isDelivered ? TextDecoration.lineThrough : TextDecoration.none
                    );
                     final currentItemQuantityStyle = itemQuantityStyle.copyWith(
                       color: item.isDelivered ? strikeThroughColor : bodyTextColor,
                       decoration: item.isDelivered ? TextDecoration.lineThrough : TextDecoration.none
                    );
                     final currentInstructionTextStyle = instructionTextStyle.copyWith(
                       color: item.isDelivered ? strikeThroughColor : instructionTextStyle.color,
                       decoration: item.isDelivered ? TextDecoration.lineThrough : TextDecoration.none
                    );

                    return InkWell( // Make item row tappable
                       onTap: () {
                          if (!item.isDelivered) { // Only allow marking undelivered items
                             _markItemDelivered(order.id, item.productId, itemIndex);
                          }
                       },
                       child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                                Row(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                      Text('${item.quantity} ', style: currentItemQuantityStyle),
                                      Expanded(child: Text(item.name, style: currentItemTextStyle)),
                                   ],
                                ),
                                // --- REMOVED ADDONS DISPLAY ---

                                // Display special instructions if they exist
                                if (item.specialInstructions.isNotEmpty)
                                   Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 4.0), // Indent instructions
                                      child: Text(
                                         'Note: ${item.specialInstructions}',
                                         style: currentInstructionTextStyle.copyWith(fontStyle: FontStyle.italic),
                                      ),
                                   ),
                             ],
                          ),
                       ),
                    );
                  }),
            ],
          ),
        ),
        fadeDuration: const Duration(milliseconds: 400),
        scaleDuration: const Duration(milliseconds: 400),
      ),
    );
  }
} 