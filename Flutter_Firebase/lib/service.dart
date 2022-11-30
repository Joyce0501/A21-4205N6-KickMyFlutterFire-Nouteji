
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'i18n/intl_localization.dart';


  Future<void> addTask(String nomtache,DateTime unedateDebut, DateTime unedateDefin, int percentageDone, String userid ) async{
    CollectionReference taskscollection = FirebaseFirestore.instance.collection("tasks");
    final db = FirebaseFirestore.instance;
    var results = await db.collection("tasks").where("name", isEqualTo: nomtache).where("userid", isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();
    if(results.docs.isNotEmpty)
      {
        print("nom existant");
      }
  //  bool verifiernom =  taskscollection.where("userid", isEqualTo: FirebaseAuth.instance.currentUser?.uid).where("name", isEqualTo: nomtache) as bool;
    else if(nomtache.trim().isEmpty || unedateDebut.isBefore(DateTime.now())){
      print("erreur");
    }


    else{
      await taskscollection.add({
        'name' : nomtache,
        'taskDateCreation' : unedateDebut,
        'taskDateFin' :  unedateDefin,
        'percentageDone' : percentageDone,
        'userid' : userid,
      });
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

  Future<Task> getCurrentTask(id) async {
    try{
      final db = FirebaseFirestore.instance;
     CollectionReference taskscollection = db.collection("tasks");
      var result = await taskscollection.doc(id).get();
      var doc = result;

      Task currenttask = new Task();
      currenttask.id = doc.id;
      currenttask.name = doc.get('name');
      currenttask.percentageDone = doc.get('percentageDone');

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
    // int? photoId = 0;
    // double percentageTimeSpent = 0;

     factory  Task.fromJson(Map<String, dynamic> json) => Task();
     Task toJson() => Task();

  }





