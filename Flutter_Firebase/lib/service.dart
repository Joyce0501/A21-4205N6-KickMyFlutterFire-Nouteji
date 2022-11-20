
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'i18n/intl_localization.dart';


// class EcranService extends StatefulWidget {
//
//   @override
//   _EcranServiceState createState() => _EcranServiceState();
// }


// class _EcranServiceState extends State<EcranService> {

  List<QueryDocumentSnapshot<Map<String, dynamic>>> taches = [];

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text(Locs.of(context).trans("Création de la tache en cours..."))),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  addTask(String nomtache,DateTime unedate, String userid) async{
    CollectionReference taskscollection = FirebaseFirestore.instance.collection("tasks");
    try{
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLoaderDialog(context);
      });
    }
    on DioError catch(e) {
      print(e);
    }
    if(nomtache.trim().isEmpty || unedate.isBefore(DateTime.now())){
      // showDialog<String>(
      //   context: context,
      //   builder: (BuildContext context) => AlertDialog(
      //     // title: const Text('AlertDialog Title'),
      //     content:  Text(Locs.of(context).trans("Erreur réseau")),
      //     actions: <Widget>[
      //       TextButton(
      //         onPressed: () => Navigator.pop(context, 'OK'),
      //         child: const Text('OK'),
      //       ),
      //     ],
      //   ),
      // );
      print("erreur");
    }
    else{
      taskscollection.add({
        'name' : nomtache,
        'taskDateCreation' : unedate,
        'userid' : userid
      });
    }
  }

  Future < List<QueryDocumentSnapshot<Map<String, dynamic>>> > getTask() async {
    try{
      final db = FirebaseFirestore.instance;
      CollectionReference taskscollection = db.collection("tasks");
      var results = await db.collection("tasks").where("userid", isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();
      var taskdocs = results.docs;
      taches = taskdocs;
    }
    catch (e){
      print (e);
    }
    return taches;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(Locs.of(context).trans('Creation')),
      ),
    );
  }
// }


