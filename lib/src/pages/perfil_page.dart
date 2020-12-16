
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_calendar/src/controller/controller.dart';

class PerfilPage extends StatelessWidget {
  PerfilPage({Key key}) : super(key: key);

  
final _googleSignIn = GoogleSignIn();
  int i=0;
  TextEditingController _nombreController = new TextEditingController();
  TextEditingController _apellidoController = new TextEditingController();
final controller = Get.find<PerfilController>();
final user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    controller.nombre = user.displayName;
    controller.foto =  user.photoURL != null
        ? user.photoURL
        : 'assets/imgs/profile.png';
    return Scaffold(
      appBar: AppBar(title: Text("Perfil")),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
                Obx(()=> card() ),
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
            // FlatButton(
            //     child: Text('Cerrar sesión'),
            //     onPressed: () async {
            //       await _logout();
            //       //preferencias.delete();
            //       MaterialPageRoute route =
            //           MaterialPageRoute(builder: (context) => LoginPage());
            //       Navigator.pushReplacement(context, route);
            //     },
            //   ),
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
                      backgroundImage: NetworkImage(controller.foto),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Column(
                      children: [
                        Text('${controller.nombre}',
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text('${user.email}',
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
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
                  controller: _nombreController,
                  decoration: InputDecoration(hintText: "Nombre"),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: _apellidoController,
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
                    controller.nombre = '${_nombreController.text} ${_apellidoController.text}';
                   print(controller.nombre);
                   FirebaseAuth.instance.currentUser.updateProfile(displayName: controller.nombre );
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
                  onPressed: () async {
                  FilePickerResult result = await FilePicker.platform.pickFiles();

                        if(result != null) {
                         File file = File(result.files.single.path); 
                         print(file.path);
                         uploadFile(file);
                         
                          Navigator.of(context).pop();
                        } else {
                          // User canceled the picker
                        }
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

  Future uploadFile(File _image) async {
   i++;
   
 await FirebaseStorage.instance    
       .ref('image/${_image.path}')
       .putFile(_image);    
   String downloadURL = await FirebaseStorage.instance
      .ref('image/${_image.path}')
      .getDownloadURL();   
      controller.foto=downloadURL;
      FirebaseAuth.instance.currentUser.updateProfile(photoURL: downloadURL );
 
}

  _logout() async {
    await _googleSignIn.signOut();
  }
}
