import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_calendar/src/pages/home_page.dart';
import 'package:student_calendar/src/pages/login_page.dart';
import 'package:student_calendar/src/provider/preferencias.dart';
import 'package:toast/toast.dart';

class RegistroPage extends StatelessWidget {
  RegistroPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text(""),
              backgroundColor: Colors.blue[600],
              elevation: 0.0,
            ),
            body: Page()));
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
  String _nombre = '';
  String _contra = '';
  String _correo = '';

  TextEditingController _nombreController = new TextEditingController();
  TextEditingController _correoController = new TextEditingController();
  TextEditingController _contraController = new TextEditingController();

  PreferenciasUsuario preferencias = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        color: Colors.blue[600],
        padding: EdgeInsets.all(7.0),
        child: Column(children: [
          SizedBox(height: 20),
          FadeInImage(
            placeholder: AssetImage('assets/imgs/loader.gif'),
            image: AssetImage('assets/imgs/logo.png'),
            fit: BoxFit.cover,
            height: 60.0,
          ),
          SizedBox(height: 20),
          Text(
            "Student Calendar",
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10.0)),
            child: TextField(
              controller: _nombreController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                hintText: "Ingrese su nombre",
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10.0)),
            child: TextField(
              controller: _correoController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                hintText: "Ingrese su correo",
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10.0)),
            child: TextField(
              obscureText: true,
              controller: _contraController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                hintText: "Ingrese su contraseña",
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 250,
            child: RaisedButton(
              onPressed: () async {
                setState(() {
                  _correo = _correoController.text;
                  _contra = _contraController.text;
                  _nombre = _nombreController.text;
                  print(_nombre);
                });
                await _registro(context);
                //preferencias.nombre = _nombre;
               
              },
              child: Text(
                "Registrarse",
                style: TextStyle(color: Colors.blue),
              ),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          FlatButton(
              onPressed: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => LoginPage());
                Navigator.push(context, route);
              },
              child: Text(
                "Iniciar sesión",
                style: TextStyle(color: Colors.white),
              )),
        ]),
      ),
    );
  }

  _registro(context) async {
    if(_correo !='' && _contra !='' && _nombre!=''){
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _correo, password: _contra);
          userCredential.user.updateProfile(displayName: _nombre);
      Toast.show('Registro correcto', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
           setState(() {
                  _nombreController.text="";
                  _correoController.text="";
                  _contraController.text="";
                });
                //  MaterialPageRoute route =
                //     MaterialPageRoute(builder: (context) => LoginPage());
                // Navigator.push(context, route);



        UserCredential firebaseCredencial = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _correo, password: _contra);
        preferencias.usuario = firebaseCredencial.user.uid;
        MaterialPageRoute route =
            MaterialPageRoute(builder: (context) => HomePage());
        Navigator.pushReplacement(context, route);

    } on FirebaseAuthException catch (e) {

      if (e.code == 'weak-password') {
        Toast.show('Contraseña debil', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } 
      else if (e.code == 'email-already-in-use') {
        Toast.show('Ya existe una cuenta con este correo', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } 
      else if (e.code == 'invalid-email') {
        Toast.show('Correo no válido. Asegúrese de que no exista ningún espacio despues del correo.', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }
  }
  
  else{
 Toast.show('Llene todos los campos', context,duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }
  }
}
