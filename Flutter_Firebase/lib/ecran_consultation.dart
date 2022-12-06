
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

 // late final DocumentSnapshot<Task> taskDoc;

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

  // int nouveaupourcentage = POURCENT_NON_MODIFIE;

  late int nouveaupourcentage ;

 //  TaskDetailResponse taskdetailresponse = TaskDetailResponse();

  // showLoaderDialog(BuildContext context){
  //   AlertDialog alert=AlertDialog(
  //     content: new Row(
  //       children: [
  //         CircularProgressIndicator(),
  //         Container(margin: EdgeInsets.only(left: 7),child:Text( Locs.of(context).trans ("Changement en cours..." ))),
  //       ],),
  //   );
  //   showDialog(barrierDismissible: false,
  //     context:context,
  //     builder:(BuildContext context){
  //       return alert;
  //     },
  //   );
  // }
  //
  // showLoaderDialogConsultation(BuildContext context){
  //   AlertDialog alert=AlertDialog(
  //     content: new Row(
  //       children: [
  //         CircularProgressIndicator(),
  //         Container(margin: EdgeInsets.only(left: 7),child:Text( Locs.of(context).trans ("Chargement des détails..." ))),
  //       ],),
  //   );
  //   showDialog(barrierDismissible: false,
  //     context:context,
  //     builder:(BuildContext context){
  //       return alert;
  //     },
  //   );
  // }
  //
  // void getHttpdetailTache(int iddoc) async {
  //   try{
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       showLoaderDialogConsultation(context);
  //     });
  //     this.taskdetailresponse = await taskdetail(idtache);
  //     Navigator.pop(context);
  //     setState(() {});
  //   } catch (e) {
  //     print(e);
  //     Navigator.of(context).pop();
  //     showDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) => AlertDialog(
  //         // title: const Text('AlertDialog Title'),
  //         content:  Text(Locs.of(context).trans("Erreur réseau")),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () => Navigator.pop(context, 'OK'),
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }
  //
  // void changepercentage(String idtache, int percentage) async{
  //
  //   if(nouveaupourcentage == POURCENT_NON_MODIFIE)
  //   {
  //     nouveaupourcentage == task.percentageDone;
  //   }
  //   else if(nouveaupourcentage > 100){
  //     print ("pourcentage eleve");
  //     // showDialog<String>(
  //     //   context: context,
  //     //   builder: (BuildContext context) => AlertDialog(
  //     //     // title: const Text('AlertDialog Title'),
  //     //     content:  Text(Locs.of(context).trans('Pourcentage doit etre inferieur ou egal a 100')),
  //     //     actions: <Widget>[
  //     //       TextButton(
  //     //         onPressed: () => Navigator.pop(context, 'OK'),
  //     //         child: const Text('OK'),
  //     //       ),
  //     //     ],
  //     //   ),
  //     // );
  //   }
  //
  //   else{
  //     try{
  //       // WidgetsBinding.instance.addPostFrameCallback((_) {
  //       //   showLoaderDialog(context);
  //       // });
  //       var reponse = await taskpercentage(idtache, percentage);
  //       task.percentageDone = nouveaupourcentage;
  //
  //       task.percentageDone = taskpercentage(idtache, percentage) ;
  //
  //       print(reponse);
  //       Navigator.pop(context);
  //       setState(() {});
  //
  //     } catch (e) {
  //       print(e);
  //       Navigator.of(context).pop();
  //       showDialog<String>(
  //         context: context,
  //         builder: (BuildContext context) => AlertDialog(
  //           // title: const Text('AlertDialog Title'),
  //           content:  Text(Locs.of(context).trans("Erreur réseau")),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () => Navigator.pop(context, 'OK'),
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //   }
  // }

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
                      // Expanded(
                      //   flex: 2,
                      //   child:
                      //   Text(Locs.of(context).trans('Pourcentage de temps ecoule') + " : " + taskdetailresponse.percentageTimeSpent.toString()),
                      // ),

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

            // Row(
            //   children: [
            //     Expanded(
            //       child:
            //       //TODO au lieu de mettre directement le widget Image.network, on l'encapsule (on le wrap)
            //       (taskdetailresponse.photoId == 0 ) ?
            //       Text(Locs.of(context).trans('Aucune image pour cette tache'))
            //           :
            //       // dans un LayoutBuilder. Le LayoutBuilder nous permet d'avoir un nouveau build context
            //       // uniquement pour le widget.
            //       LayoutBuilder(
            //           builder: (BuildContext context, BoxConstraints constraints) {
            //
            //             //TODO La MediaQuery permet de connaitre la taille disponible dans le build context,
            //             // ici build context est uniquement pour le widget Image.network, c'est donc la taille disponible
            //             // pour l'image
            //             var size = MediaQuery.of(context).size;
            //
            //             //TODO la taille est en double, il sera important de convertir la taille en int
            //             // pour que le serveur prenne notre requête (ex: 390 au lieu de 390.0)
            //             String width = size.width.toInt().toString();
            //
            //             //TODO Une fois la taille connue, il suffit de la spécifier dans l'URL
            //             return
            //               CachedNetworkImage(
            //                 imageUrl: 'http://10.0.2.2:8080/file/' + taskdetailresponse.photoId.toString() +"?width=" +width, width: size.width,
            //                 placeholder: (context, url) => CircularProgressIndicator(),
            //                 errorWidget: (context, url, error) => Icon(Icons.error),
            //               );
            //             // Image.network("https://exercices-web.herokuapp.com/exos/image?&width="+width, width: size.width,);
            //           }
            //       ),
            //     ),
            //   ],
            // ),


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
                   // Image.network('http://10.0.2.2:8080/file/' + taskdetailresponse.photoId.toString().toString())
                ),
                //   ElevatedButton(onPressed:sendPicture(this.taskdetailresponse.id,File(imageNetworkPath.path)), child: Text("Envoyer image su serveur")),
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
                        task.percentageDone = nouveaupourcentage;
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


