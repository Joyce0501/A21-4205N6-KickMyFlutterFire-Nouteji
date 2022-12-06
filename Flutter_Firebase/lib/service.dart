
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'ecran_accueil.dart';
import 'i18n/intl_localization.dart';


const snackBar = SnackBar(
  content: Text('Yay! A SnackBar!'),
);
  bool ok = false;
  Future<void> addTask(String nomtache,DateTime unedateDebut, DateTime unedateDefin, int percentageDone, String userid ) async{
    CollectionReference taskscollection = FirebaseFirestore.instance.collection("tasks");
    final db = FirebaseFirestore.instance;
    var results = await db.collection("tasks").where("name", isEqualTo: nomtache).where("userid", isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();
    ok = false;
    if(results.docs.isNotEmpty)
      {
        Fluttertoast.showToast(
            msg: "Impossible de creer cette tache,ce nom de tache existe deja",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    else if(nomtache.trim().isEmpty){
      Fluttertoast.showToast(
          msg: "Impossible de creer cette tache,le nom d'une tache ne doit pas comporter des espaces vides",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    else if(unedateDebut.isBefore(DateTime.now())){
      Fluttertoast.showToast(
          msg: "Impossible de creer cette tache,la date de creation doit etre au minimum apres la date du jour ou egal a celle-ci",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    else{
      await taskscollection.add({
        'name' : nomtache,
        'taskDateCreation' : unedateDebut,
        'taskDateFin' :  unedateDefin,
        'percentageDone' : percentageDone,
        'userid' : userid,
      });
      ok = true;
      return;
    }
  }

  Future < List<QueryDocumentSnapshot<Map<String, dynamic>>> > getTask() async {
    try{
      final db = FirebaseFirestore.instance;
      //CollectionReference taskscollection = db.collection("tasks");
      var results = await db.collection("tasks").where("userid", isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();
      var taskdocs = results.docs;
      return taskdocs;
    }
    catch (e){
      print (e);
      throw(e);
    }
  }

 Future taskpercentage(String idtache, int percentage) async {
  try {
  //  final db = FirebaseFirestore.instance;
  //  var result = await db.collection("tasks").doc(idtache).get();
  //  var doc = result;
  //  var update = doc.data()?.update("percentageDone", (value) => percentage);

    FirebaseFirestore.instance.collection('tasks').doc(idtache).update({'percentageDone': percentage});
   // return update;
  }
  catch (e) {
    print(e);
    throw(e);
  }
 }

  Future<Task> getCurrentTask(String id) async {
    try{
      final db = FirebaseFirestore.instance;
      CollectionReference taskscollection = db.collection("tasks");
      var result = await taskscollection.doc(id).get();
      var doc = result;

      Task currenttask = new Task();
      currenttask.id = doc.id;
      currenttask.name = doc.get('name');
      currenttask.percentageDone = doc.get('percentageDone');
      Timestamp letemps = doc.get('taskDateFin');
      DateTime date = letemps.toDate();
      currenttask.deadline = date;
    //  currenttask.deadline = doc.get('taskDateFin');


      // currenttask.percentageTimeSpent = doc.data()['percentageTimeSpent'];
      // currenttask.percentageTimeSpent = doc.data()['percentageTimeSpent'];

      return currenttask;
    }
    catch (e){
      print (e);
      throw(e);
    }
  }


  // CollectionReference<Task> getTaskCollection() {
  //   return FirebaseFirestore.instance
  //
  //       .collection("users")
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //
  //       .collection("tasks")
  //
  //       .withConverter<Task>(
  //         fromFirestore: (doc, _) => Task.fromJson(doc.data()!),
  //         toFirestore: (task, _) => task.toJson()
  //       );
  // }

  // Future<DocumentSnapshot<Task>> getCurrentTask(String id) async{
  //   try{
  //     final db = FirebaseFirestore.instance;
  //     DocumentSnapshot<Task> taskDoc = await getTaskCollection().doc(id).get();
  //
  //     // String id = taskDoc.id;
  //     // Task task = taskDoc.data()!;
  //
  //     //var doc = result;
  //     return taskDoc;
  //   }
  //   catch (e){
  //     print (e);
  //     throw(e);
  //   }
  // }

//  Future<DocumentSnapshot<Task>> getCurrentTask(String id) async{
//   try{
//     final db = FirebaseFirestore.instance;
//     DocumentSnapshot<Task> taskDoc = await getTaskCollection().doc(id).get();
//
//     // String id = taskDoc.id;
//     // Task task = taskDoc.data()!;
//
//     //var doc = result;
//     return taskDoc;
//   }
//   catch (e){
//     print (e);
//     throw(e);
//   }
// }
//
//
  class Task {

    Task() { }

    String id = "";
    String name = "";
    int percentageDone = 0;

    // @JsonKey(fromJson: _fromJson, toJson: _toJson)
     DateTime deadline = DateTime.now();

     int? photoId = 0;
     double percentageTimeSpent = 0;

     factory  Task.fromJson(Map<String, dynamic> json) => Task();
     Task toJson() => Task();

  }

  // final _dateFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
  // DateTime _fromJson(String date) => _dateFormatter.parse(date);
  // String _toJson(DateTime date) => _dateFormatter.format(date);





