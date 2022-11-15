import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<QueryDocumentSnapshot<Map<String, dynamic>>> taches = [];

 addTask(String nomtache,DateTime unedate, String userid) async{
  CollectionReference taskscollection = FirebaseFirestore.instance.collection("tasks");
  taskscollection.add({
    'name' : nomtache,
    'taskDateCreation' : unedate,
    'userid' : userid
  });
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
