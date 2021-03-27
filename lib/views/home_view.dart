
import 'package:carrental/widgets/card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: getitems(context),
          builder: (BuildContext context, snapshot) {
            if(!snapshot.hasData) return Padding( padding:EdgeInsets.only(top: 20, left: 20 , right: 20 , bottom: 20), child: Text(" "),);
            return new ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildCard(context, snapshot.data.documents[index]));
          }
      ),
    );
  }

  Stream<QuerySnapshot>  getitems(BuildContext context) async* {

    yield* Firestore.instance.collection('cars').snapshots();
  }



}