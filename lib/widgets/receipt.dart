import 'package:carrental/views/carsingle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Widget receipt(BuildContext context, DocumentSnapshot receipt, bool typecheck) {


  return new Container(

    child: Card(

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),

        ),
        child: FlatButton(
          onPressed: (){

          },
          child: Padding(
            padding: const EdgeInsets.only(top : 6.0 , bottom: 6, ),
            child: Row(
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Container(
                        width: 170,
                        child: Text(
                          receipt['tnumber'],
                          style:TextStyle(fontSize: 20 , fontWeight: FontWeight.w600, color: Colors.grey) ,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Container(
                        width: 170,
                        child: Text(
                          receipt['price'],
                          style:TextStyle(fontSize: 14 ,) ,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Container(
                        width: 170,
                        child: Text(
                          receipt['carname'],
                          style:TextStyle(fontSize: 14 ,) ,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Container(
                        width: 170,
                        child: Text(
                          receipt['status'],
                          style:TextStyle(fontSize: 14 , color: Colors.orange) ,),
                      ),
                    ),
                    receipt['status'] == "Accepted" ? Padding(
                      padding: const EdgeInsets.only(top:8.0, left: 8.0),
                      child: Text("Come pick up your car at the dealer"),
                    ) : Text(" "),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Visibility(
                        visible: typecheck,
                          child: Row(
                            children: [
                              RaisedButton(
                                color: Colors.green,
                                onPressed: (){
                                  Firestore.instance.collection("payments").document(receipt.documentID).updateData({'status': 'Accepted'});
                                  Navigator.of(context).pushReplacementNamed('/home');
                                  successfullysent(context);
                                },
                                child: Text("Confirm" , style: TextStyle(color: Colors.white),),),

                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: RaisedButton(
                                  color: Colors.red,
                                  onPressed: (){
                                    Firestore.instance.collection("payments").document(receipt.documentID).updateData({'status': 'Canceled'});
                                    Navigator.of(context).pushReplacementNamed('/home');
                                    denaid(context);
                                  },
                                  child: Text("Deny", style: TextStyle(color: Colors.white)),),
                              ),



                            ],
                          )),
                    )
                  ],
                ),




              ],
            ),
          ),
        ),
      ),
    ),
  );


}

Future successfullysent(context){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          title: Text("Successfully Accepted Payment", style: TextStyle(color: Colors.black),),
        );
      }
  );
}
Future denaid(context){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          title: Text("Payment has been canceled", style: TextStyle(color: Colors.black),),
        );
      }
  );
}

