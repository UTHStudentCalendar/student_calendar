import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_calendar/src/pages/login_page.dart';
import 'package:student_calendar/src/provider/preferencias.dart';

class PerfilPage extends StatelessWidget {
  PerfilPage({Key key}) : super(key: key);

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final preferencias = PreferenciasUsuario();
  final String nombre = FirebaseAuth.instance.currentUser.displayName;
  final String foto = FirebaseAuth.instance.currentUser.photoURL != null
        ? FirebaseAuth.instance.currentUser.photoURL
        : 'assets/imgs/profile.png';

  @override
  Widget build(BuildContext context) {
     

    return Scaffold(
      appBar: AppBar(title: Text("Perfil")),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
                card(),
             FlatButton(
                child: Text('Cambiar nombre'),
                onPressed: () {
                  _mostrarAlertaNombre(context);
                },
              ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton(
                child: Text('Establecer foto de perfil'),
                onPressed: () {
                  _mostrarAlertaPerfil(context);
                },
              ),
            
            SizedBox(
              height: 10.0,
            ),
            FlatButton(
                child: Text('Cerrar sesión'),
                onPressed: () async {
                  await _logout();
                  preferencias.delete();
                  MaterialPageRoute route =
                      MaterialPageRoute(builder: (context) => LoginPage());
                  Navigator.pushReplacement(context, route);
                },
              ),
          ]),
    );
  }


  Widget card(){
    return  Stack(fit: StackFit.loose,
            alignment: AlignmentDirectional.bottomCenter,
              children: [Card(
                color: Colors.blue,
                child: Container(
                  width: double.infinity,
                  child: Column(children: [
                    SizedBox(height: 30),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(foto),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "$nombre",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ]),
                ),
              ),
            ]);
  }
  
  void _mostrarAlertaNombre(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Cambiar nombre"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(hintText: "Nombre"),
                ),
                SizedBox(height: 10.0),
                TextField(
                  decoration: InputDecoration(hintText: "Apellido"),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cambiar")),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  void _mostrarAlertaContrasena(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Cambiar contraseña"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(hintText: "Contraseña actual"),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(hintText: "Contraseña nueva"),
                ),
              ],
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cambiar")),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  void _mostrarAlertaPerfil(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Establecer foto de perfil"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Elegir foto")),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  _logout() async {
    await _googleSignIn.signOut();
  }
}
