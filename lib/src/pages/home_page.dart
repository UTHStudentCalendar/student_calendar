import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_calendar/src/controller/menu_controller.dart';
import 'package:student_calendar/src/pages/perfil_page.dart';
import 'package:student_calendar/src/provider/preferencias.dart';
import 'package:student_calendar/src/widget/pageview_menu.dart';
import 'package:student_calendar/src/widget/pageview_paginas.dart';

import 'login_page.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  final paginaController = Get.put<MenuController>(MenuController());
  final String nombre = FirebaseAuth.instance.currentUser.displayName;
  final String foto = FirebaseAuth.instance.currentUser.photoURL != null
        ? FirebaseAuth.instance.currentUser.photoURL
        : 'assets/imgs/profile.png';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
          appBar: AppBar(
            title: Obx(() => Text('${paginaController.pagina}')),
          ),
          drawer: Drawer(
            child: ListView(children: [
              Center(
                  child: Text(
                "Student Calendar",
                style: TextStyle(fontSize: 22, color: Colors.blue, fontWeight: FontWeight.bold),
              )),
              card(),
              ListTile(
                title: Container(
                  alignment: AlignmentDirectional.topStart,
                  child: FlatButton(
                    child: Text("Perfil", style: TextStyle(fontSize: 15),),
                    onPressed: () {
                      MaterialPageRoute route =
                          MaterialPageRoute(builder: (context) => PerfilPage());
                      Navigator.push(context, route);
                    },
                  ),
                ),
                leading: Icon(Icons.person),
              ),
              ListTile(
                title: Container(
                  alignment: AlignmentDirectional.topStart,
                  child: FlatButton(
                    child: Text("Cerrar sesión", style: TextStyle(fontSize: 15),),
                    onPressed: () {
                      _logout();
                      MaterialPageRoute route =
                      MaterialPageRoute(builder: (context) => LoginPage());
                  Navigator.pushReplacement(context, route);
                    },
                  ),
                ),
                leading: Icon(Icons.outbox),
              )
            ]),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  PageViewMenu(),
                  PageViewPagina(),
                ],
              ),
            ),
          )),
    );
  }

  Widget card(){
    return  Card(
                color: Colors.blue,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  child: Column(children: [
                    SizedBox(height: 20),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(foto),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "$nombre",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ]),
                ),
            );
  }
  _logout() async {
    PreferenciasUsuario preferenciasUsuario = PreferenciasUsuario();
     final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    
    preferenciasUsuario.delete();

  }
}
