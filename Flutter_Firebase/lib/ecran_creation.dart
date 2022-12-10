import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ecran_accueil.dart';
import 'package:flutter_firebase/service.dart';
import 'package:intl/intl.dart';
// import 'package:kick_my_flutter/ecran_accueil.dart';
// import 'package:kick_my_flutter/lib_http.dart';
// import 'package:kick_my_flutter/tiroir_nav.dart';
// import 'package:kick_my_flutter/transfer.dart';

import 'i18n/intl_localization.dart';

class EcranCreation extends StatefulWidget {

  @override
  _EcranCreationState createState() => _EcranCreationState();
}

class _EcranCreationState extends State<EcranCreation> {

  TextEditingController dateinput = TextEditingController();
  TextEditingController dateinput1 = TextEditingController();
  String nomtache = "";
  DateTime unedateDebut = DateTime.now();
  DateTime unedateFin = DateTime.now();
  late int percentageDone = task.percentageDone;
  late double percentageSpent = 0;
  String photourl = "";
  Task task = new Task();


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


  @override
  void initState() {
      super.initState();
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
      body:
      OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return buildPaysage();
          } else {
            return buildPortrait();
          }
        },
      )
    );
  }

  @override
  Widget buildPortrait() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // TODO decommenter la ligne suivante
      //  drawer: LeTiroir(),
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(Locs.of(context).trans('Creation')),
      // ),
      body: SingleChildScrollView(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(Locs.of(context).trans('Creation de tache'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),

                Padding(
                  padding: const EdgeInsets.all(50),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: Locs.of(context).trans('Nom de la tache'),
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey
                          ),
                        )),
                    onChanged: (nom) {
                      nomtache = nom;
                    }
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(50),
                  child: TextFormField(

                    controller: dateinput, //editing controller of this TextField
                    decoration: InputDecoration(
                        //icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: Locs.of(context).trans('Entrer une date de debut') ,//label text of field
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.grey
                        ),
                      )
                    ),
                    readOnly: true,  //set it true, so that user will not able to edit text
                    onTap: () async {

                      DateTime? pickedDate = await showDatePicker(
                          context: context, initialDate: DateTime.now(),
                          firstDate: DateTime(1900), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101),
                      );

                      unedateDebut = pickedDate!;


                      if(pickedDate != null ){
                        print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          dateinput.text = formattedDate; //set output date to TextField value.
                        });
                      }else{
                        print("Date is not selected");
                      }
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(50),
                  child: TextFormField(
                    controller: dateinput1, //editing controller of this TextField
                    decoration: InputDecoration(
                      //icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: Locs.of(context).trans('Entrer une date de fin') ,//label text of field
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey
                          ),
                        )
                    ),
                    readOnly: true,  //set it true, so that user will not able to edit text
                    onTap: () async {

                      DateTime? pickedDate1 = await showDatePicker(
                        context: context, initialDate: DateTime.now(),
                        firstDate: DateTime(1900), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101),
                      );

                      unedateFin = pickedDate1!;


                      if(pickedDate1 != null ){
                        print(pickedDate1);  //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate1);
                        print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          dateinput1.text = formattedDate; //set output date to TextField value.
                        });
                      }else{
                        print("Date is not selected");
                      }
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: MaterialButton(
                      onPressed: () async {
                         try{
                           print("a");
                           //showLoaderDialog(context);
                           await addTask(nomtache,unedateDebut,unedateFin,percentageDone,percentageSpent,(FirebaseAuth.instance.currentUser?.uid).toString(),photourl);
                           print("b");

                           print("c");
                           if(ok == true){
                             Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (context) => EcranAccueil(),
                               ),
                             );
                           }

                         }
                         catch(e){
                           print("z");
                           print(e);
                           Navigator.of(context).pop();
                         }
                      },
                      child: Text(Locs.of(context).trans('Accueil')),
                      color: Colors.blue,
                   ),
                  ),
               ),
              ]
        ),
      ),
    );
  }

  Widget buildPaysage() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // TODO decommenter la ligne suivante,
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(Locs.of(context).trans('Creation de tache'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),

              Padding(
                padding: const EdgeInsets.all(50),
                child: TextFormField(
                    decoration: InputDecoration(labelText: Locs.of(context).trans('Nom de la tache'),
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey
                          ),
                        )),
                    onChanged: (nom) {
                      nomtache = nom;
                    }
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(50),
                child: TextFormField(

                  controller: dateinput, //editing controller of this TextField
                  decoration: InputDecoration(
                    //icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: Locs.of(context).trans('Entrer une date de debut') ,//label text of field
                      labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.grey
                        ),
                      )
                  ),
                  readOnly: true,  //set it true, so that user will not able to edit text
                  onTap: () async {

                    DateTime? pickedDate = await showDatePicker(
                      context: context, initialDate: DateTime.now(),
                      firstDate: DateTime(1900), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101),
                    );

                    unedateDebut = pickedDate!;


                    if(pickedDate != null ){
                      print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                        dateinput.text = formattedDate; //set output date to TextField value.
                      });
                    }else{
                      print("Date is not selected");
                    }
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(50),
                child: TextFormField(
                  controller: dateinput1, //editing controller of this TextField
                  decoration: InputDecoration(
                    //icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: Locs.of(context).trans('Entrer une date de fin') ,//label text of field
                      labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.grey
                        ),
                      )
                  ),
                  readOnly: true,  //set it true, so that user will not able to edit text
                  onTap: () async {

                    DateTime? pickedDate1 = await showDatePicker(
                      context: context, initialDate: DateTime.now(),
                      firstDate: DateTime(1900), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101),
                    );

                    unedateFin = pickedDate1!;


                    if(pickedDate1 != null ){
                      print(pickedDate1);  //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate1);
                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                        dateinput1.text = formattedDate; //set output date to TextField value.
                      });
                    }else{
                      print("Date is not selected");
                    }
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: MaterialButton(
                    onPressed: () async {
                      try{
                        print("a");
                        await addTask(nomtache,unedateDebut,unedateFin,percentageDone,percentageSpent,(FirebaseAuth.instance.currentUser?.uid).toString(),photourl);
                        print("b");

                        print("c");
                        if(ok == true){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EcranAccueil(),
                            ),
                          );
                        }
                      }
                      catch(e){
                        print("z");
                        print(e);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(Locs.of(context).trans('Accueil')),
                    color: Colors.blue,
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }
}