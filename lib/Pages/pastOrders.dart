import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hungerz_kitchen/Components/custom_circular_button.dart';
import 'package:hungerz_kitchen/Models/order_model.dart';
import 'package:hungerz_kitchen/Services/api_service.dart';
import 'package:hungerz_kitchen/Theme/colors.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

class PastOrders extends StatefulWidget {
  const PastOrders({super.key});

  @override
  State<PastOrders> createState() => _PastOrdersState();
}

class _PastOrdersState extends State<PastOrders> {
  late final ApiService _apiService;
  late Future<List<Order>> _completedOrdersFuture;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _fetchOrders();
  }

  void _fetchOrders() {
    setState(() {
      _completedOrdersFuture = _apiService.fetchCompletedOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color bodyTextColor = textColor;
    final Color? itemStrikeThroughColor = strikeThroughColor;
    final Color appBarTitleColor = Theme.of(context).textTheme.titleMedium?.color ?? Colors.black;
    final Color headerCompletedColor = Colors.grey.shade600;
    final Color headerSubTextColor = Colors.white.withOpacity(0.85);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        titleSpacing: 12.0,
          title: FadedScaleAnimation(
            child: RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: '',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                    .copyWith(
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: appBarTitleColor)
                ),
              TextSpan(
                  text: 'KITCHEN',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).primaryColor,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold)),
            ])),
          fadeDuration: const Duration(milliseconds: 400),
          scaleDuration: const Duration(milliseconds: 400),
          ),
          actions: [
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: FadedScaleAnimation(
                child: CustomButton(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                  leading: const Icon(Icons.close, color: Colors.white, size: 16),
                    title: Text(
                    'Close',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    onTap: () {
                    Navigator.pop(context);
                    }),
              fadeDuration: const Duration(milliseconds: 400),
              scaleDuration: const Duration(milliseconds: 400),
              ),
            )
          ],
        ),
        body: FadedSlideAnimation(
          beginOffset: const Offset(0.0, 0.3),
          endOffset: Offset.zero,
          slideCurve: Curves.linearToEaseOut,
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: FutureBuilder<List<Order>>(
              future: _completedOrdersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  log("Error fetching past orders: ${snapshot.error}");
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text('Error loading past orders: ${snapshot.error}', textAlign: TextAlign.center),
                         const SizedBox(height: 10),
                         ElevatedButton(onPressed: _fetchOrders, child: const Text('Retry'))
                      ],
                    )
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No past orders found.'));
                } else {
                  final List<Order> completedOrders = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(10.0),
              child: StaggeredGrid.count(
                crossAxisCount: 4,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                children: List.generate(
                        completedOrders.length,
                        (int index) {
                          final order = completedOrders[index];
                          return _buildPastOrderCard(
                              context,
                              order,
                              bodyTextColor,
                              itemStrikeThroughColor ?? Colors.grey,
                              headerCompletedColor,
                              headerSubTextColor
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          )
      )
    );
  }

  Widget _buildPastOrderCard(
      BuildContext context,
      Order order,
      Color bodyTextColor,
      Color itemStrikeThroughColor,
      Color headerBackgroundColor,
      Color headerSubTextColor
    ) {

    final String completionTimeFormatted = order.updatedAt != null
        ? DateFormat('dd MMM, hh:mm a').format(order.updatedAt!.toLocal())
        : 'N/A';

    final headerTextStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold);
    final headerSubTextStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: headerSubTextColor, fontSize: 10);
    final itemTextStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          decoration: TextDecoration.lineThrough,
          color: itemStrikeThroughColor,
        );
    final itemQuantityStyle = itemTextStyle.copyWith(fontWeight: FontWeight.bold);
    final instructionTextStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: itemStrikeThroughColor.withOpacity(0.8),
          fontWeight: FontWeight.w300,
          fontSize: 12,
          decoration: TextDecoration.lineThrough,
        );

                    return ClipPath(
                      clipper: CustomClipPath(),
                      child: FadedScaleAnimation(
                        child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: headerBackgroundColor,
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            order.orderType,
                                            style: headerTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            order.orderNumber,
                                            style: headerSubTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        completionTimeFormatted,
                                        style: headerSubTextStyle.copyWith(fontSize: 12),
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  itemCount: order.items.length,
                  itemBuilder: (context, itemIndex) {
                    if (itemIndex >= order.items.length) return const SizedBox.shrink();
                    final item = order.items[itemIndex];

                                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                              Text('${item.quantity} ', style: itemQuantityStyle),
                              Expanded(child: Text(item.name, style: itemTextStyle)),
                            ],
                          ),
                          if (item.specialInstructions.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, top: 4.0),
                              child: Text(
                                'Note: ${item.specialInstructions}',
                                style: instructionTextStyle.copyWith(fontStyle: FontStyle.italic),
                              ),
                            ),
                        ],
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
