import 'package:carrental/views/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Carsingle extends StatefulWidget {
  final String name, description , price ,  imageid , status;

  const Carsingle({Key key, this.name, this.description, this.price, this.imageid, this.status}) : super(key: key);
  @override
  _CarsingleState createState() => _CarsingleState();
}

class _CarsingleState extends State<Carsingle> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(top:0.0),
                child: FutureBuilder(
                    future: _getImage(context, widget.imageid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done)
                        return Container(
                            height:250,
                            width:200,
                            child: FittedBox(
                              child: snapshot.data,
                              fit: BoxFit.fill,
                            )

                        );
                      if (snapshot.connectionState ==
                          ConnectionState.waiting)
                        return Padding(
                          padding: const EdgeInsets.only(left:130.0, right: 130, top: 70),
                          child: Container(
                              height: 100,
                              width: 100,
                              child: CircularProgressIndicator()),
                        );
                      return Container();
                    }
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20, left: 10),
                child: Text(widget.name[0].toUpperCase()+widget.name.substring(1),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500 ),),
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:18.0),
                    child: Text("Description : "),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 17, right: 17, bottom: 20),
                    child: Container(
                      width: 180,
                        child: Text(widget.description, style: TextStyle(fontSize: 15, color: Colors.grey),)),
                  ),
                ],
              ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:18.0),
                  child: Text("Price per month : "),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 17, right: 17, bottom: 20),
                  child: Container(child: Text(widget.price, style: TextStyle(fontSize: 15, color: Colors.grey),)),
                ),
              ],
            ),

              Padding(
                padding: EdgeInsets.only(top: 20, left: 17, right: 17, bottom: 20),
                child: Container(child: Text(widget.status, style: TextStyle(fontSize: 18, color: Colors.orange),)),
              ),

              Padding(
                padding: const EdgeInsets.only(top:35.0, bottom: 200, left: 20, right: 20),
                child: RaisedButton(
                  color: Colors.orange,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 13.0, bottom: 13.0, left: 23.0, right: 23.0),
                    child: Text(
                      "Book car",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onPressed: widget.status == "Notavailable" ? null : () async{
                    return showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            shape: RoundedRectangleBorder(

                            ),
                            title: Text("Book this car ?", style: TextStyle(fontSize: 17 , color: Colors.orange),),
                            content: Text('Are you sure you want to book the car',style: TextStyle(fontSize: 14),),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Cancel'),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text('OK'),
                                onPressed: () async{
                                  var  uid =  (await FirebaseAuth.instance.currentUser()).uid;
                                  Firestore.instance.collection("cars").document(widget.imageid).updateData({'status': 'Notavailable'});

                                  final DocumentReference documentReference = await Firestore.instance.collection('Booking').add({
                                  'bookingid': "" ,
                                  });

                                  final String itemId= documentReference.documentID;
                                  Firestore.instance.collection('Booking').document(itemId).setData({
                                  "name" :  widget.name ,
                                  "description" : widget.description ,
                                  "price": widget.price,
                                  "uid" : uid,
                                  "bookingid" : itemId
                                  });


                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Payment(
                                  userid : uid,
                                  bookingid : itemId,
                                  price: widget.price,
                                  carname : widget.name
                                  )),
                                  );
                                },
                              )
                            ],
                          );
                        });



                  },
                ),
              ),





            ],

          ),
        )
    );
  }



}

Future<Widget> _getImage(BuildContext context, String imageid) async {
  Image m;
  await FireStorageService.loadFromStorage(context, imageid).then((downloadUrl) {
    m = Image.network(
      downloadUrl.toString(),
      fit: BoxFit.scaleDown,
    );
  });
  return m;
}


class FireStorageService extends ChangeNotifier {
  FireStorageService();
  static Future<dynamic> loadFromStorage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}
