import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      }
    });
    super.initState();
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

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // connexion() async {
  //   if(nomConnexion == "" || passwordConnexion == ""){
  //     showDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) => AlertDialog(
  //         // title: const Text('AlertDialog Title'),
  //         content:  Text(Locs.of(context).trans("Veuillez saisir des informations")),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () => Navigator.pop(context, 'OK'),
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //   else{
  //     try {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         showLoaderDialog(context);
  //       });
  //       SigninRequest req = SigninRequest();
  //       req.username = nomConnexion;
  //       req.password = passwordConnexion;
  //       var reponse = await signin(req);
  //       print(reponse);
  //       Navigator.pop(context);
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => EcranAccueil(),
  //         ),
  //       );
  //
  //     } on DioError catch(e) {
  //       print(e);
  //       Navigator.of(context).pop();
  //       if(e.response == null)
  //       {
  //         showDialog<String>(
  //           context: context,
  //           builder: (BuildContext context) => AlertDialog(
  //             // title: const Text('AlertDialog Title'),
  //             content:  Text(Locs.of(context).trans("Erreur réseau")),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context, 'OK'),
  //                 child: const Text('OK'),
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //       else{
  //         String message = e.response!.data;
  //         if (message == "BadCredentialsException") {
  //           showDialog<String>(
  //             context: context,
  //             builder: (BuildContext context) => AlertDialog(
  //               // title: const Text('AlertDialog Title'),
  //               content:  Text(Locs.of(context).trans("Compte introuvable")),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () => Navigator.pop(context, 'OK'),
  //                   child: const Text('OK'),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }
  //         else if(message == "InternalAuthenticationServiceException")
  //         {
  //           showDialog<String>(
  //             context: context,
  //             builder: (BuildContext context) => AlertDialog(
  //               // title: const Text('AlertDialog Title'),
  //               content:  Text(Locs.of(context).trans("Compte introuvable")),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () => Navigator.pop(context, 'OK'),
  //                   child: const Text('OK'),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }
  //         else {
  //           print('autre erreurs');
  //           ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                   content: Text('Erreur authentification')
  //               )
  //           );
  //         }
  //
  //       }
  //
  //     }
  //
  //   }
  //
  // }

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
      //  drawer: LeTiroir(),
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(Locs.of(context).trans('Connexion')),
      // ),
      body:
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Text(Locs.of(context).trans('Connexion'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
              MaterialButton(
                child: Text(Locs.of(context).trans('Connexion')),
                color: Colors.blue,
                onPressed:
                signInWithGoogle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaysage() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // TODO decommenter la ligne suivante
      //  drawer: LeTiroir(),
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(Locs.of(context).trans('Connexion')),
      // ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(Locs.of(context).trans('Connexion'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50)),
            Padding(
              padding: const EdgeInsets.all(50),
              child: TextFormField(
                  decoration: InputDecoration(labelText: Locs.of(context).trans('Nom'),
                      labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.grey
                        ),
                      )),
                  onChanged: (nom) {
                    nomConnexion = nom;
                  }
              ),
            ),
            // const Text(
            //   'Mot de passe',
            // ),
            Padding(
              padding: const EdgeInsets.all(50),
              child: TextFormField(
                  decoration: InputDecoration(labelText: Locs.of(context).trans('Mot de passe'),
                      labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.grey
                        ),
                      )),
                  obscureText: true,
                  onChanged: (password) {
                    passwordConnexion = password;
                  }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: MaterialButton(
                //     child: Text(Locs.of(context).trans('Connexion')),
                //     color: Colors.blue,
                //     onPressed:
                //     connexion,
                //   ),
                // ),

                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: MaterialButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => EcranInscription(),
                //         ),
                //       );
                //     },
                //     child: Text(Locs.of(context).trans('Inscription')),
                //     color: Colors.blue,
                //   ),
                // ),
              ],
            ),

          ],
        ),
      ),
    );
  }


}