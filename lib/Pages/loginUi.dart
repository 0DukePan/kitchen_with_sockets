import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:hungerz_kitchen/Components/colorButton.dart';
import 'package:hungerz_kitchen/Components/textfield.dart';
import 'package:hungerz_kitchen/Pages/home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FadedSlideAnimation(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    FadedScaleAnimation(
                      child: Container(
                        height: 180,
                        width: 180,
                        child: Image(image: AssetImage("Assets/appIcon.png")),
                      ),
                      fadeDuration: Duration(milliseconds: 200),
                      scaleDuration: Duration(milliseconds: 200),
                    ),
                    FadedScaleAnimation(
                      child: Text(
                        "",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.black, fontSize: 25),
                      ),
                      fadeDuration: Duration(milliseconds: 200),
                      scaleDuration: Duration(milliseconds: 200),
                    )
                  ],
                ),
                SizedBox(
                  width: 50,
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 250,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: EntryField("+91 ", 'Enter Mobile Number'),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                        child: ColorButton("Continue"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        beginOffset: Offset(0.0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
