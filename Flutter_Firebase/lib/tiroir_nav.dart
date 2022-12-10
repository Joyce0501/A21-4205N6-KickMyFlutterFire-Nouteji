import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ecran_connexion.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'ecran_accueil.dart';
import 'ecran_creation.dart';
import 'i18n/intl_localization.dart';


class LeTiroir extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => LeTiroirState();
}

class LeTiroirState extends State<LeTiroir> {

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text( Locs.of(context).trans ("Deconnexion en cours..." ))),
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
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        MaterialPageRoute(
          builder: (context) => EcranConnexion(),
        );
      } else {
        print('User is signed in! ' + user.email!);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    String texte = FirebaseAuth.instance.currentUser == null ? "Aucun utilisateur connecté" :FirebaseAuth.instance.currentUser!.email.toString();

    var listView = ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(height: 100,),

        ListTile(
          dense: true,
          leading: Icon(Icons.person),
          title: Text(texte),
        ),

        ListTile(
          dense: true,
          leading: Icon(Icons.home),
          title: Text(Locs.of(context).trans('Accueil')),
          onTap: () {
            // TODO ferme le tiroir de navigation
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EcranAccueil(),
              ),
            );
            // Then close the drawer
          },
        ),
        //
        // TODO le tiroir de navigation ne peut pointer que vers des
        // ecran sans paramtre.
        ListTile(
          dense: true,
          leading: Icon(Icons.add_task),
          title: Text(Locs.of(context).trans('Ajout de taches')),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EcranCreation(),
              ),
            );
            // Then close the drawer
          },
        ),

        ListTile(
          dense: true,
          leading: Icon(Icons.logout),
          title: Text(Locs.of(context).trans('Deconnexion')),
          onTap:
            () async {
            await GoogleSignIn().signOut();
            await FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(context, '/ecranconnexion', (route) => false);
            setState(() {});
          },
        ),

      ],
    );

    return Drawer(
      child: new Container(
        color: const Color(0xFFFFFFFF),
        child: listView,
      ),
    );
  }
}
