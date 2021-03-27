import 'package:carrental/widgets/receipt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Receipt extends StatefulWidget {
  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  bool typecheck = false ;

  @override
  void initState() {
    checktype().then((value){
      print('Async done');
    });
    super.initState();
  }

  checktype() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    final userid = user.uid;
    Firestore.instance.collection('users').where('uid', isEqualTo: userid).getDocuments().then((docs){
      if(docs.documents[0].exists){
        if(docs.documents[0].data['type'] == 'admin'){
          setState(() {
            typecheck = true;
          });
        }else{
          setState(() {
            typecheck = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  StreamBuilder(
          stream: getitems(context , typecheck),
          builder: (BuildContext context, snapshot) {
            if(!snapshot.hasData) return Padding( padding:EdgeInsets.only(top: 20, left: 20 , right: 20 , bottom: 20), child: Text(" "),);
            return new ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) =>
                    receipt(context, snapshot.data.documents[index], typecheck));
          }
      ),
    );
  }

  Stream<QuerySnapshot>  getitems(BuildContext context , typecheck) async* {
    var  uid =  (await FirebaseAuth.instance.currentUser()).uid;
    if(typecheck == true){
      yield*   Firestore.instance.collection('payments').snapshots();
    }else{
      yield* Firestore.instance.collection('payments').where('uid', isEqualTo : uid ).snapshots();
    }

  }
}
