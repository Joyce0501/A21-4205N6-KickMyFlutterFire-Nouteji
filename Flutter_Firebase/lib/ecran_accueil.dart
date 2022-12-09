
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/service.dart';
import 'package:flutter_firebase/tiroir_nav.dart';
// import 'package:kick_my_flutter/ecran_consultation.dart';
// import 'package:kick_my_flutter/ecran_creation.dart';
// import 'package:kick_my_flutter/lib_http.dart';
// import 'package:kick_my_flutter/transfer.dart';
// import 'package:kick_my_flutter/tiroir_nav.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'ecran_consultation.dart';
import 'ecran_creation.dart';
import 'i18n/intl_localization.dart';


class EcranAccueil extends StatefulWidget {

  @override
  _EcranAccueilState createState() => _EcranAccueilState();
}

class _EcranAccueilState extends State<EcranAccueil> {

  // HomeItemResponse homeitemresponse = HomeItemResponse();
  //
  // List<> taches = [];

  List<QueryDocumentSnapshot<Map<String, dynamic>>> taches = [];

  bool dialogVisible = false;

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text(Locs.of(context).trans("Chargement en cours..."))),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        dialogVisible = true;
        return alert;
      },
    );
  }

  @override
  void initState() {
    loadData();
    initializeDateFormatting("fr-FR", null);
  }

  void loadData() async {
    taches = await getTask();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: LeTiroir(),
      resizeToAvoidBottomInset: false,
      // TODO decommenter la ligne suivante
      //  drawer: LeTiroir(),
      //  drawer: LeTiroir(),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(Locs.of(context).trans('Accueil')),
      ),

      body:
        ListView.builder(
          itemCount: taches.length,
          scrollDirection: Axis.vertical,
          prototypeItem: ListTile(
            title: Text("hello"),
          ),
          itemBuilder: (context, index) {
            return Row(
              children: [
               Expanded(
                  child:

                  (taches[index].data()['photourl'] == null)  ?

            ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EcranConsultation(le_parametre:taches[index].id),
                ),
              );
            },
              title: Text(Locs.of(context).trans("Aucune image"),
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )

              :
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EcranConsultation(le_parametre:taches[index].id),
                        ),
                      );
                    },
                    title:

         //   (taches[index].data()['photourl']!='') ?Image.network(taches[index].data()['photourl']):Text("pas encore de photo")

                 //   CircleAvatar(
                      // TODO : mettre une width par la suite
                  //    backgroundImage:
                      CachedNetworkImage(
                        imageUrl: taches[index].data()['photourl'],
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                  //    NetworkImage('http://10.0.2.2:8080/file/' + this.taches[index].photoId.toString() +"?width=70"),
                  //  ),
                  ),
               ),

                Expanded(
                  child:
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EcranConsultation(le_parametre: (taches[index].id)),
                        ),
                      );
                    },
                    // leading: CircleAvatar(
                    //   backgroundImage: NetworkImage('http://10.0.2.2:8080/file/' + this.taches[index].photoId.toString()),
                    //   ),
                    title: Text(taches[index].data()['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                  //      color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),

                 Expanded(
                   child:
                   ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EcranConsultation(le_parametre:this.taches[index].id),
                        ),
                      );
                    },
                //
                //     // leading: Icon(Icons.percent),
                    title: Text(taches[index].data()['percentageDone'].toString(),
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        //    color: Colors.red,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EcranConsultation(le_parametre:this.taches[index].id),
                        ),
                      );
                    },
                  //  leading: Icon(Icons.done_all_sharp),
                    title: Text( taches[index].data()['percentageSpent'].toString(),
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                ),
                Expanded(
                  child:
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EcranConsultation(le_parametre:this.taches[index].id),
                        ),
                      );
                    },
                    title: Text(DateFormat.yMd("fr_FR").format(taches[index].data()['taskDateCreation'].toDate()).toString(),
                      style: TextStyle(
                      //  fontSize: 10.0,
                          fontWeight: FontWeight.w500,
                          //  color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      // Column(
      //
      // ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EcranCreation(),
            ),
          );
        },
      child: const Icon(Icons.add_task),
    ),

    );
  }
}