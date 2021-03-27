import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carrental/widgets/custom_dialog.dart';

class FirstView extends StatelessWidget {
  final primaryColor = const Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner : false,
      home: Scaffold(

        resizeToAvoidBottomPadding: false,
        body: Container(
          width: _width,
          height: _height,
          color: primaryColor,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(

                children: <Widget>[


                  Padding(
                    padding: const EdgeInsets.only(top:38.0),
                    child: Text(
                      "CARNIVERSE",
                      style: TextStyle(fontSize: 32, color: Colors.orange , fontWeight: FontWeight.w600, ),
                    ),
                  ),
                  SizedBox(height: _height * 0.06),
                  AutoSizeText(
                    "Welcome to Carniverse",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.orange,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Text("Your One-Stop Car Rental Provider " , style: TextStyle(color: Colors.grey, fontSize: 12),),
                  ),
                  SizedBox(height: _height * 0.15),
                  RaisedButton(
                    color: Colors.orange,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 12.0, bottom: 12.0, left: 30.0, right: 30.0),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed("/signUp");

                    },
                  ),
                  SizedBox(height: _height * 0.05),
                  RaisedButton(
                    color: Colors.orange,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 12.0, bottom: 12.0, left: 30.0, right: 30.0),
                      child: Text(
                        "Sign In",

                        style: TextStyle(
                        color: primaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                      ),
                    ),

                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/signIn');
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:248.0, left: 20),
                    child: Text("Contacts : +254 78955225", style: TextStyle(color: Colors.orange, ),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
