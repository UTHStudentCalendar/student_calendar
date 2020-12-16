import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_calendar/src/controller/controller.dart';
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
  final user = FirebaseAuth.instance.currentUser;
  final controller = Get.put<PerfilController>(PerfilController());

  @override
  Widget build(BuildContext context) {
       controller.nombre = user.displayName;
    controller.foto =  user.photoURL != null
        ? user.photoURL
        : 'assets/imgs/profile.png';
    return Scaffold(
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
              Container(padding: EdgeInsets.all(10),child: Text("Agregar Eventos", style: TextStyle(fontWeight: FontWeight.bold)),),
              ListTile(
                title: Container(
                  alignment: AlignmentDirectional.topStart,
                  child: FlatButton(
                    child: Text("Agregar Asignatura", style: TextStyle(fontSize: 15),),
                    onPressed: () {
                      Navigator.pushNamed(context, "agregarAsignatura");
                    },
                  ),
                ),
                leading: Icon(Icons.book, color: Colors.blue,),
              ),
              ListTile(
                title: Container(
                  alignment: AlignmentDirectional.topStart,
                  child: FlatButton(
                    child: Text("Agregar Examen", style: TextStyle(fontSize: 15),),
                    onPressed: () {
                      Navigator.pushNamed(context, "agregar");
                    },
                  ),
                ),
                leading: Icon(Icons.ballot, color: Colors.blue,),
              ),
              ListTile(
                title: Container(
                  alignment: AlignmentDirectional.topStart,
                  child: FlatButton(
                    child: Text("Agregar Tarea", style: TextStyle(fontSize: 15),),
                    onPressed: () {
                      Navigator.pushNamed(context, "agregarTarea");
                    },
                  ),
                ),
                leading: Icon(Icons.assignment, color: Colors.blue,),
              ),
              ListTile(
                title: Container(
                  alignment: AlignmentDirectional.topStart,
                  child: FlatButton(
                    child: Text("Agregar Calificación", style: TextStyle(fontSize: 15),),
                    onPressed: () {
                      Navigator.pushNamed(context, "agregarCalificacion");
                    },
                  ),
                ),
                leading: Icon(Icons.beenhere_rounded, color: Colors.blue,),
              ),
               ListTile(
                title: Container(
                  alignment: AlignmentDirectional.topStart,
                  child: FlatButton(
                    child: Text("Agregar Horario", style: TextStyle(fontSize: 15),),
                    onPressed: () {
                      Navigator.pushNamed(context, "agregarHorario");
                    },
                  ),
                ),
                leading: Icon(Icons.event, color: Colors.blue,),
              ),
              Container(padding: EdgeInsets.all(10),child: Text("Configuración", style: TextStyle(fontWeight: FontWeight.bold),)),

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
                leading: Icon(Icons.person, color: Colors.blue,),
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
                leading: Icon(Icons.outbox, color:Colors.blue),
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
          )
    );
  }

  Widget card(){
    return  Obx (() => Card(
                color: Colors.blue,
                child: Container(
                  height: 140,
                  width: double.infinity,
                  child: Column(children: [
                    SizedBox(height: 20),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(controller.foto),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Column(
                      children: [
                        Text(
                          "${controller.nombre}",
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                       Text(
                          "${user.email}",
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ]),
                ),
     ) );
  }
  _logout() async {
    PreferenciasUsuario preferenciasUsuario = PreferenciasUsuario();
     final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    
    preferenciasUsuario.delete();

  }
}
