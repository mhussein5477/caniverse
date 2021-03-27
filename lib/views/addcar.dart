import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Addcar extends StatefulWidget {
  @override
  _AddcarState createState() => _AddcarState();
}

class _AddcarState extends State<Addcar> {

  String name, description , price;



  File _image;

  //choose in camera
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future gallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Widget _showImage(){
    return _image == null ? Text('No image selected.') : ClipRRect(child: Image.file(_image), borderRadius: BorderRadius.circular(0.0),);
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey ,
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 35.0 ,left: 10),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black,),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0,),
                  child: Text("Add car"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:53.0, right: 53, top: 20, bottom: 10),
                  child: Container(
                    child: _showImage(),
                    width: 200,),

                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.orange,
                      onPressed: getImage,
                      child: Icon(Icons.add_a_photo, color: Colors.white,),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: RaisedButton(
                        color: Colors.orange,
                        onPressed: gallery,
                        child: Icon(Icons.perm_media, color: Colors.white,),
                      ),
                    ),

                  ],
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 38, right: 38 , bottom: 8),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() =>   name = value.trim());
                    } ,
                    keyboardType: TextInputType.text ,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Car Name",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 38, right: 38 , bottom: 8),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() =>   description = value.trim());
                    } ,
                    keyboardType: TextInputType.text ,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Car description",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 38, right: 38 , bottom: 8),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() =>   price = value.trim());
                    } ,
                    keyboardType: TextInputType.text ,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Price per month",
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top:35.0, bottom: 200),
                  child: RaisedButton(
                    color: Colors.orange,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 13.0, bottom: 13.0, left: 23.0, right: 23.0),
                      child: Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onPressed:
                    name == null ? null : () async{
                      var  uid =  (await FirebaseAuth.instance.currentUser()).uid;
                      final DocumentReference documentReference = await Firestore.instance.collection('cars').add({
                        'carsid': "" ,
                      });

                      final String itemId= documentReference.documentID;
                      Firestore.instance.collection('cars').document(itemId).setData({
                        "name" :  name ,
                        "description" : description ,
                        "price": price,
                        "status" : "Available",
                        'itemId': itemId ,
                        "uid" : uid
                      });

                      final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(itemId);
                      final StorageUploadTask task = firebaseStorageRef.putFile(_image);
                      Navigator.of(context).pop();
                      successfullysent(context, name);

                    },
                  ),
                ),

              ],
            ),
          ) ,
        ) ,
      ),
    );
  }

  Future successfullysent(context, roadname){
    String name = roadname;
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            title: Text("Successfully added", style: TextStyle(color: Colors.black),),
            content: Text( name.toUpperCase() + " has been added" , style: TextStyle(fontSize: 13),),
          );
        }
    );
  }
}
