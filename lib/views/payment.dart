import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Payment extends StatefulWidget {
  final String bookingid , userid , price , carname;

  const Payment({Key key, this.bookingid, this.userid, this.price, this.carname}) : super(key: key);
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String  tnumber;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:78.0),
                child: Text("Payments", style: TextStyle( fontSize: 19, fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: const EdgeInsets.only(top:15.0),
                child: Container(
                  child: Image.asset("assets/images/mpesa.png" , width: 120,),
                ),
              ),
              Text("Lipa na M-PESA" , style: TextStyle(color: Colors.grey, fontSize: 17),),
              Text("Pay Bill", style: TextStyle(color: Colors.grey, fontSize: 17)),
              Text("Business no - 8544752", style: TextStyle(color: Colors.grey, fontSize: 17)),
              Text("Account Number ( Your Name )", style: TextStyle(color: Colors.grey, fontSize: 17)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Amount : ", style: TextStyle(color: Colors.grey, fontSize: 17)),
                  Text(widget.price, style: TextStyle(color: Colors.grey, fontSize: 17)),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top:18.0),
                child: Text(widget.carname , style: TextStyle( fontWeight: FontWeight.w500),),
              ),


              Padding(
                padding: const EdgeInsets.only(left:48.0),
                child: Container(
                  height: 100,
                  child: StreamBuilder(
                      stream: Firestore.instance.collection('users').where('uid' , isEqualTo : widget.userid).snapshots(),
                      builder: (BuildContext context, snapshot) {
                        if(!snapshot.hasData) return Text(" ");
                        return new ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) =>
                                name(context, snapshot.data.documents[index]));}),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 38, right: 38 , bottom: 8),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    setState(() =>   tnumber = value.trim());
                  } ,
                  keyboardType: TextInputType.text ,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "Transaction number",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:35.0, bottom: 0, left: 20, right: 20),
                child: RaisedButton(
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 13.0, bottom: 13.0, left: 23.0, right: 23.0),
                    child: Text(
                      "Confirm Booking",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onPressed: () async{

                    Firestore.instance.collection('payments').add({
                      "uid" :   widget.userid,
                      "tnumber" : tnumber ,
                      "price": widget.price,
                      "status" : "pending",
                      'carname': widget.carname ,
                      "bookingid" : widget.bookingid
                    });
                    Navigator.of(context).pushReplacementNamed('/home');
                    successfullysent(context, tnumber);


                  },
                ),
              ),

            ],
          ),
        ),
      ) ,
    );
  }
  Future successfullysent(context, tnumber){
    String name = tnumber;
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            content: Text( "Wait for " + name.toUpperCase() + " to be confirmed , check your notifications" , style: TextStyle(fontSize: 13),),
          );
        }
    );
  }
}

Widget name(BuildContext context , DocumentSnapshot name){
  return  Padding(
    padding: const EdgeInsets.only(top : 10.0,  left: 10, right: 10),
    child:Text(name['name']),
  );
}
