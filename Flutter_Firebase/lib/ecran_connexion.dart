import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ecran_accueil.dart';
import 'package:flutter_firebase/ecran_creation.dart';
import 'package:flutter_firebase/service.dart';
import 'package:flutter_firebase/tiroir_nav.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:kick_my_flutter/ecran_inscription.dart';
// import 'package:dio/dio.dart';
// import 'package:kick_my_flutter/transfer.dart';

// import 'ecran_accueil.dart';

import 'i18n/intl_localization.dart';
// import 'lib_http.dart';

class EcranConnexion extends StatefulWidget {

  @override
  _EcranConnexionState createState() => _EcranConnexionState();
}

class _EcranConnexionState extends State<EcranConnexion> {



  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in! ' + user.email!);
        userok();
      }
    });
    super.initState();
  }

  userok() async{
    await getTask();
    Navigator.pushNamedAndRemoveUntil(context, '/ecranaccueil', (route) => false);
  }

  String nomConnexion = "";
  String passwordConnexion = "";
  bool dialogVisible = false;

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text(Locs.of(context).trans ("Connexion en cours...") )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EcranAccueil(),
      ),
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(Locs.of(context).trans('Connexion')),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return buildPaysage();
          } else {
            return buildPortrait();
          }
        },
      ),
    );
  }

  Widget buildPortrait() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // TODO decommenter la ligne suivante
        drawer: LeTiroir(),
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(Locs.of(context).trans('Connexion')),
      // ),
      body:
    //  SingleChildScrollView(
      //  child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Text(Locs.of(context).trans('Connexion'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50)),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                MaterialButton(
                  child: Text(Locs.of(context).trans('Connexion')),
                  color: Colors.blue,
                  onPressed:
                  signInWithGoogle,
                ),
              ),
            ),
          ],
        ),
    //  ),
    );
  }

  Widget buildPaysage() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // TODO decommenter la ligne suivante
       drawer: LeTiroir(),
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(Locs.of(context).trans('Connexion')),
      // ),
      body:
        Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Text(Locs.of(context).trans('Connexion'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50)),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
              MaterialButton(
                child: Text(Locs.of(context).trans('Connexion')),
                color: Colors.blue,
                onPressed:
                signInWithGoogle,
              ),
            ),
          ),
        ],
      ),

    );
  }


}