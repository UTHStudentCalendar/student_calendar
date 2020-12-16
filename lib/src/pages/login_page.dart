import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_calendar/src/pages/home_page.dart';
import 'package:student_calendar/src/pages/registro_page.dart';
import 'package:student_calendar/src/provider/preferencias.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Text(""),
              backgroundColor: Colors.blue[600],
              elevation: 0.0,
            ),
            body: Page()
            
            );
  }
}

class Page extends StatefulWidget {
  Page({
    Key key,
  }) : super(key: key);
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  String _contra = '';
  String _correo = '';

  TextEditingController _correoController = new TextEditingController();
  TextEditingController _contraController = new TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final preferencias = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        color: Colors.blue[600],
        padding: EdgeInsets.all(7.0),
        child: Column(children: [
          SizedBox(height: 30),
          FadeInImage(
            placeholder: AssetImage("assets/imgs/loader.gif"),
            image: AssetImage("assets/imgs/logo.jpg"),
            height: 80,
          ),
          SizedBox(height: 30),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
              controller: _correoController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Ingrese su correo",
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.white,
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
              style: TextStyle(color: Colors.white),
              obscureText: true,
              controller: _contraController,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Ingrese su contraseña",
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  )),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: 260,
            height: 45,
            child: RaisedButton(
              onPressed: () async {
                setState(() {
                  _correo = _correoController.text;
                  _contra = _contraController.text;
                });
                await _loginFirebase();
              },
              child: Text(
                "Iniciar sesión",
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Column(
            children: [
              Container(
                width: 260,
                child: RaisedButton(
                  onPressed: () async {
                    await _login();
                    MaterialPageRoute route =
                        MaterialPageRoute(builder: (context) => HomePage());
                    Navigator.pushReplacement(context, route);
                  },
                  child: ListTile(
                    dense: true,
                    trailing: Image(
                      image: AssetImage("assets/imgs/logoGoogle.png"),
                      width: 20,
                    ),
                    title: Text(
                      "Iniciar sesión con Google",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          FlatButton(
              onPressed: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => RegistroPage());
                Navigator.pushReplacement(context, route);
              },
              child: Text(
                "Registrarse",
                style: TextStyle(color: Colors.white),
              )),
        ]),
      ),
    );
  }

  _login() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential firebaseCredencial =
        await FirebaseAuth.instance.signInWithCredential(credential);

    preferencias.usuario = firebaseCredencial.user.uid;

    return firebaseCredencial;
  }

  _loginFirebase() async {
    if (_correo != '' && _contra != '') {
      try {
        UserCredential firebaseCredencial = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _correo, password: _contra);
        preferencias.usuario = firebaseCredencial.user.uid;
        Navigator.pushReplacementNamed(context, 'inicio');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Toast.show('Usuario no encontrado', context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        } else if (e.code == 'wrong-password') {
          Toast.show('Contraseña incorrecta', context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        } else if (e.code == 'invalid-email') {
          Toast.show(
              'Correo no válido. Asegúrese de que no exista ningún espacio despues del correo.',
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.CENTER);
        }
      }
    } else {
      Toast.show('Llene todos los campos', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
