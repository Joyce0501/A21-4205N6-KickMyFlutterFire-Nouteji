import 'package:cloud_firestore/cloud_firestore.dart';

 addTask(String nomtache,DateTime unedate) async{

  CollectionReference taskscollection = FirebaseFirestore.instance.collection("tasks");
  taskscollection.add({
    'name' : nomtache,
    'taskDateCreation' : unedate,
  });


  // final db = FirebaseFirestore.instance;
  // // Create a new user with a first and last name
  // final task = <String, dynamic>{
  //   "name": nomtache,
  //   "taskDateCreation": unedate,
  // };
  // db.collection("users").add(task).then((DocumentReference doc) =>
  //     print('DocumentSnapshot added with ID: ${doc.id}'));
}

 getTask() async {
  CollectionReference taskscollection = FirebaseFirestore.instance.collection("tasks");
  var results = await taskscollection.get();
  var taskdocs = results.docs;
}
