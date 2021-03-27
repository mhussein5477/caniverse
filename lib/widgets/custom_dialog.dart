import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomDialog extends StatelessWidget {
  final primaryColor = Colors.green[400];
  final grayColor = const Color(0xFF939393);

  final String title,
      description,
      primaryButtonText,
      primaryButtonRoute;

  CustomDialog(
      {@required this.title,
      @required this.description,
      @required this.primaryButtonText,
      @required this.primaryButtonRoute,
   });

  static const double padding = 20.0;

  @override
  Widget build(BuildContext context) {
    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(padding),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey,
                    blurRadius: 5.0,
                    offset: const Offset(0.0, 5.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 24.0),
                AutoSizeText(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 21.0,
                  ),
                ),

                //description
                SizedBox(height: 24.0),
                AutoSizeText(
                  description,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: grayColor,
                    fontSize: 15.0,
                  ),
                ),


                SizedBox(height: 24.0),
                RaisedButton(
                  color: primaryColor,

                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: AutoSizeText(
                      primaryButtonText,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();

                  },
                ),

                SizedBox(height: 10.0),

              ],
            ),
          )
        ],
      ),
    );
  }


}
