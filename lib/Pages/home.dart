import 'package:animation_wrappers/animation_wrappers.dart';

// import 'package:buy_this_app/buy_this_app.dart';
import 'package:flutter/material.dart';
import 'package:hungerz_kitchen/Pages/loginUi.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hungerz_kitchen/Components/custom_circular_button.dart';
import 'package:hungerz_kitchen/Routes/routes.dart';
import 'package:hungerz_kitchen/Theme/colors.dart';


class HomePage extends StatefulWidget {
  final int tableOrdersDelivered = 0;

  @override
  _HomePageState createState() => _HomePageState();
}

class OrderInfo {
  String quantity;
  String item;
  bool isDelivered;
  List<String> addOns;

  OrderInfo(
    this.quantity,
    this.item,
    this.isDelivered,
    this.addOns,
  );
}

class AllOrder {
  String orderType;
  String id;
  String time;
  Color color;
  List<OrderInfo> orders;
  int deliveredItems;

  AllOrder(this.orderType, this.id, this.time, this.color, this.orders,
      this.deliveredItems);
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _checkForBuyNow();
  }

  List<AllOrder> order1 = [
    AllOrder(
        'Dine-in',
        'AB00121',
        '08:49',
        buttonColor,
        [
          OrderInfo('1', 'Chat Masala', false, []),
          OrderInfo('1', 'Veg Cheese Pizza', false, ['Extra Cheese']),
          OrderInfo('1', 'Fried Chicken', false, []),
          OrderInfo('1', 'Mushroom Pizza', false, []),
        ],
        0),
    AllOrder(
        'Delivery',
        'AB00125',
        '05:12',
        primaryColor,
        [
          OrderInfo('2', 'Vanilla Ice Cream', false, []),
          OrderInfo('1', 'Egg Faritta', false, ['Extra Cheese', 'Extra Egg']),
          OrderInfo('1', 'Roasted Chicken', false, ['Extra Spice']),
          OrderInfo('1', 'Farm Ville Pizza', false, []),
        ],
        0),
    AllOrder(
        'Dine-in',
        'AB00129',
        '01:33',
        newOrderColor,
        [
          OrderInfo('1', 'Chat Masala', false, []),
          OrderInfo('1', 'Veg Cheese Pizza', false, ['Extra Cheese']),
          OrderInfo('1', 'Fried Chicken', false, []),
          OrderInfo('1', 'Mushroom Pizza', false, []),
          OrderInfo('2', 'Vanilla Ice Cream', false, []),
          OrderInfo('1', 'Egg Faritta', false, ['Extra Cheese', 'Extra Egg']),
          OrderInfo('1', 'Roasted Chicken', false, ['Extra Egg']),
          OrderInfo('1', 'Farm Ville Pizza', false, ['Extra Cheese']),
        ],
        0),
    AllOrder(
        'Dine-in',
        'AB00122',
        '00:33',
        newOrderColor,
        [
          OrderInfo('1', 'Cheese Lasagne', false, []),
          OrderInfo('1', 'Veg Cheese Pizza', false, ['Extra Cheese']),
          OrderInfo('1', 'Ice Cream', false, []),
        ],
        0),
    AllOrder(
        'Delivery',
        'AB00129',
        '01:20',
        primaryColor,
        [
          OrderInfo('1', 'Cheese Lasagne', false, []),
          OrderInfo('1', 'Veg Cheese Pizza', false, ['Extra Cheese']),
          OrderInfo('1', 'Ice Cream', false, []),
        ],
        0),
    AllOrder(
        'Take away',
        'AB00128',
        '02:37',
        newOrderColor,
        [
          OrderInfo('1', 'Cheese Lasagne', false, []),
          OrderInfo('1', 'Veg Cheese Pizza', false, ['Extra Cheese']),
          OrderInfo('1', 'Ice Cream', false, []),
        ],
        0),
    AllOrder(
        'Dine-in',
        'AB00127',
        '02:37',
        newOrderColor,
        [
          OrderInfo('1', 'Cheese Lasagne', false, []),
          OrderInfo('1', 'Veg Cheese Pizza', false, ['Extra Cheese']),
          OrderInfo('1', 'Ice Cream', false, []),
        ],
        0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onDoubleTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
          },
          child: FadedScaleAnimation(
            child: RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: '',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(letterSpacing: 1, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: 'KITCHEN',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).primaryColor,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold)),
            ])),
            fadeDuration: Duration(milliseconds: 400),
            scaleDuration: Duration(milliseconds: 400),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: FadedScaleAnimation(
              child: CustomButton(
                  padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
                  leading: Icon(
                    Icons.history,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    size: 16,
                  ),
                  title: Text(
                    '  ' + 'Past Orders',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, PageRoutes.pastOrders);
                  }),
              fadeDuration: Duration(milliseconds: 400),
              scaleDuration: Duration(milliseconds: 400),
            ),
          )
        ],
      ),
      body: FadedSlideAnimation(
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: order1.length == 0
              ? Center(
                  child: FadedScaleAnimation(
                  child: Text('No Data To Show'),
                  fadeDuration: Duration(milliseconds: 400),
                  scaleDuration: Duration(milliseconds: 400),
                ))
              : SingleChildScrollView(
                  child: StaggeredGrid.count(
                    crossAxisCount: 4,
                    children: List.generate(order1.length, (int stagIndex) {
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
                                  color: order1[stagIndex].color,
                                  child: ListTile(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order1[stagIndex].orderType,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          order1[stagIndex].id,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  fontSize: 10,
                                                  color: Colors.grey.shade300),
                                        )
                                      ],
                                    ),
                                    trailing: Text(order1[stagIndex].time,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: order1[stagIndex].orders.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0, horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  order1[stagIndex]
                                                      .orders[index]
                                                      .isDelivered = true;
                                                  order1[stagIndex]
                                                      .deliveredItems++;
                                                  if (order1[stagIndex]
                                                          .deliveredItems ==
                                                      order1[stagIndex]
                                                          .orders
                                                          .length) {
                                                    order1.removeAt(stagIndex);
                                                  }
                                                });
                                                print(order1.length);
                                              },
                                              child: Text(
                                                order1[stagIndex]
                                                        .orders[index]
                                                        .quantity +
                                                    '\t\t\t' +
                                                    order1[stagIndex]
                                                        .orders[index]
                                                        .item,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: order1[stagIndex]
                                                                .orders[index]
                                                                .isDelivered
                                                            ? strikeThroughColor
                                                            : textColor,
                                                        decoration: order1[
                                                                    stagIndex]
                                                                .orders[index]
                                                                .isDelivered
                                                            ? TextDecoration
                                                                .lineThrough
                                                            : TextDecoration
                                                                .none),
                                              ),
                                            ),
                                            ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: order1[stagIndex]
                                                  .orders[index]
                                                  .addOns
                                                  .length,
                                              itemBuilder:
                                                  (context, addOnIndex) {
                                                return RichText(
                                                  text: TextSpan(
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                            color: order1[
                                                                        stagIndex]
                                                                    .orders[
                                                                        index]
                                                                    .isDelivered
                                                                ? strikeThroughColor
                                                                : textColor),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: '\t\t\t\t\t'),
                                                      TextSpan(
                                                          text: order1[
                                                                      stagIndex]
                                                                  .orders[index]
                                                                  .addOns[
                                                              addOnIndex],
                                                          style: TextStyle(
                                                              decoration: order1[
                                                                          stagIndex]
                                                                      .orders[
                                                                          index]
                                                                      .isDelivered
                                                                  ? TextDecoration
                                                                      .lineThrough
                                                                  : TextDecoration
                                                                      .none,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 14)),
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    })
                              ],
                            ),
                          ),
                          fadeDuration: Duration(milliseconds: 400),
                          scaleDuration: Duration(milliseconds: 400),
                        ),
                      );
                    }),
                    // staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 10.0,
                  ),
                ),
        ),
        beginOffset: Offset(0.0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
      // floatingActionButton: AppConfig.isDemoMode
      //     ? BuyThisApp.button(
      //         AppConfig.appName,
      //         'https://dashboard.vtlabs.dev/projects/envato-referral-buy-link?project_slug=hungerz_flutter',
      //       )
      //     : null,
      // bottomNavigationBar: AppConfig.isDemoMode
      //     ? Container(
      //         padding: const EdgeInsets.all(8),
      //         child:
      //             // BuyThisApp.developerRowOpusDark(
      //             //     Colors.transparent, Theme.of(context).primaryColorLight)
      //             BuyThisApp.developerRowOpus(
      //                 Colors.transparent, Theme.of(context).primaryColor),
      //       )
      //     : const SizedBox.shrink(),
    );
  }

  Padding buildFoodItem(
      BuildContext context, String quantity, String item, bool delivered) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6),
      child: FadedScaleAnimation(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              quantity.padRight(20) + item,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: delivered ? strikeThroughColor : blackColor,
                  decoration: delivered
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, addOnIndex) {
                  return Text(
                    item,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: delivered ? strikeThroughColor : blackColor,
                        decoration: delivered
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontWeight: FontWeight.w300),
                  );
                })
          ],
        ),
        fadeDuration: Duration(milliseconds: 300),
        scaleDuration: Duration(milliseconds: 300),
      ),
    );
  }

  void _checkForBuyNow() async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // if (!sharedPreferences.containsKey("key_buy_this_shown") &&
    //     AppConfig.isDemoMode) {
    //   Future.delayed(Duration(seconds: 10), () async {
    //     if (mounted) {
    //       BuyThisApp.showSubscribeDialog(context);
    //       sharedPreferences.setBool("key_buy_this_shown", true);
    //     }
    //   });
    // }
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
