
import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/service.dart';
import 'package:flutter_firebase/tiroir_nav.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'package:kick_my_flutter/lib_http.dart';
// import 'package:kick_my_flutter/tiroir_nav.dart';
// import 'package:kick_my_flutter/transfer.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'i18n/intl_localization.dart';


class EcranConsultation extends StatefulWidget {

  final String le_parametre;

  const EcranConsultation({Key? key, required this.le_parametre}) : super(key: key);


  @override
  _EcranConsultationState createState() => _EcranConsultationState();
}

 const int POURCENT_NON_MODIFIE = -1;

class _EcranConsultationState extends State<EcranConsultation> {

  String imagePath = "";
  String imageNetworkPath = "";
  XFile? pickedImage;
  List<XFile>? pickedImages;


  Task task = new Task();

  final picker = ImagePicker();

  // on met le fichier dans l'etat pour l'afficher dans la page
  var _imageFile = null;



  Future getImage() async {
    print("ouverture du selecteur d'image");
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print("l'image a ete choisie " + pickedFile.path.toString());
      _imageFile = File(pickedFile.path);
      setState(() {});
      // TODO envoi au server
      print("debut de l'envoi , pensez a indiquer a l'utilisateur que ca charge " + DateTime.now().toString() );
      sendPicture(widget.le_parametre, _imageFile).then(
              (res) {
            setState(() {
              print("fin de l'envoi , pensez a indiquer a l'utilisateur que ca charge " + DateTime.now().toString() );

              // TODO mettre a jour interface graphique
              this.gettask();
            });
          }
      ).catchError(
              (err) {
            // TODO afficher un message a l'utilisateur pas marche
            print(err);
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                // title: const Text('AlertDialog Title'),
                content:  Text(Locs.of(context).trans("Erreur réseau")),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
      );
    }
    else {
      print('Pas de choix effectue.');
    }
  }

  late int nouveaupourcentage ;


  @override
  void initState()  {
    gettask();
    getpercentage();
    initializeDateFormatting("fr-FR", null);
  }

  gettask() async{
    task = await getCurrentTask(widget.le_parametre);
    setState(() {});
  }
  getpercentage() async{
    task.percentageDone =  nouveaupourcentage ;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // TODO decommenter la ligne suivante
      drawer: LeTiroir(),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(Locs.of(context).trans('Consultation')),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Text(widget.le_parametre.toString())

            Container(
              margin: EdgeInsets.all(5),
              width: double.infinity,
              height: 200,
              child:  Expanded(
                child:
                Column(

                    children:[
                      Expanded(
                        flex: 2,
                        child:
                       // latache.data()['name']
                        Text(Locs.of(context).trans('Nom de la tache') + " : " + task.name),
                      ),

                      Expanded(
                        flex: 2,
                        child:
                        Text(Locs.of(context).trans('Date decheance de la tache') + " : " + DateFormat.yMd("fr_FR").format(task.deadline)),
                      ),
                      //
                      Expanded(
                        flex: 2,
                        child:
                        Text(Locs.of(context).trans('Pourcentage davancement') + " : " + task.percentageDone.toString()),
                      ),
                      //
                      Expanded(
                        flex: 2,
                        child:
                        Text(Locs.of(context).trans('Pourcentage de temps ecoule') + " : " + task.percentageTimeSpent.toString()),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextFormField(
                            decoration: InputDecoration(labelText: Locs.of(context).trans('Entrer le nouveau pourcentage'),
                                labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                  ),
                                )),
                            onChanged: (pourcentage) {
                              try {
                                nouveaupourcentage = int.parse(pourcentage);
                              }
                              catch(e) {
                                nouveaupourcentage = POURCENT_NON_MODIFIE;
                              }
                            }
                        ),
                      ),
                    ]
                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                    child:
                    (task.photourl == "" ) ?
                    Text(Locs.of(context).trans('Aucune image pour cette tache'))
                        :
                    CachedNetworkImage(
                      imageUrl: task.photourl.toString(),
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      child: Text(Locs.of(context).trans('Enregistrement du nouveau pourcentage')),
                      color: Colors.blue,
                      onPressed: () async{
                        await taskpercentage(widget.le_parametre, nouveaupourcentage);
                        if(ok == true){
                          task.percentageDone = nouveaupourcentage;
                        }
                        else{
                          task.percentageDone = task.percentageDone;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      child: Text(Locs.of(context).trans('Selectionnes une image')),
                      color: Colors.blue,
                      onPressed: getImage,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


