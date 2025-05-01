import 'package:flutter/material.dart';
import 'Routes/routes.dart';
import 'Theme/style.dart';
import 'package:flutter/services.dart';
import 'package:hungerz_kitchen/Screens/kitchen_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(HungerzKitchen());
}

class HungerzKitchen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
          return MaterialApp(
      debugShowCheckedModeBanner: false,
            theme: appTheme,
      home: const KitchenScreen(),
            routes: PageRoutes().routes(),
    );
  }
}
