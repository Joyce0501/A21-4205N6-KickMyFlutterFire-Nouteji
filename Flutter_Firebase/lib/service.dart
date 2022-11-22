
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'i18n/intl_localization.dart';

  Future<void> addTask(String nomtache,DateTime unedateDebut, DateTime unedateDefin, int percentageDone, String userid ) async{
    CollectionReference taskscollection = FirebaseFirestore.instance.collection("tasks");
    final db = FirebaseFirestore.instance;
    if(nomtache.trim().isEmpty || unedateDebut.isBefore(DateTime.now())){
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


