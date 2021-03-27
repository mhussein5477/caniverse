import 'package:carrental/views/carsingle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Widget buildCard(BuildContext context, DocumentSnapshot cardetail) {
  String imageid = cardetail['itemId'];

  return new Container(

    child: Card(

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: FlatButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Carsingle(
                name: cardetail['name'],
                  description : cardetail['description'],
                  price : cardetail['price'],
                  imageid : cardetail['itemId'],
                status : cardetail['status'],

              )),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(top : 6.0 , bottom: 6, ),
            child: Row(
              children: [
                FutureBuilder(
                    future: _getImage(context, imageid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done)
                        return Container(
                            height:90,
                            width:120,
                            child: FittedBox(
                              child: snapshot.data,
                              fit: BoxFit.fill,
                            )
                        );
                      if (snapshot.connectionState ==
                          ConnectionState.waiting)
                        return Container(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator());

                      return Container();
                    }
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Container(
                        width: 170,
                        child: Text(
                          cardetail['name'].toUpperCase(),
                          style:TextStyle(fontSize: 14 , fontWeight: FontWeight.w600, color: Colors.black) ,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Container(
                        width: 170,
                        child: Text(
                          cardetail['price'],
                          style:TextStyle(fontSize: 14 ,  color: Colors.orange) ,),
                      ),
                    ),
                  ],
                )


              ],
            ),
          ),
        ),
      ),
    ),
  );
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


