import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_calendar/src/controller/menu_controller.dart';
import 'package:student_calendar/src/provider/preferencias.dart';
import 'package:toast/toast.dart';

class AgregarCalificacionPage extends StatefulWidget {
  AgregarCalificacionPage({Key key}) : super(key: key);

  @override
  _AgregarCalificacionPageState createState() => _AgregarCalificacionPageState();
}

class _AgregarCalificacionPageState extends State<AgregarCalificacionPage> {
  final paginaController = MenuController();
  TextEditingController _nombreController = new TextEditingController();
  TextEditingController _descripcionController = new TextEditingController();
  TextEditingController _calificacionController  = new TextEditingController();
  int i = 0;

  String _nombre = '';
  String  _descripcion ='';
  String _calificacion = '';
   Map<String, dynamic> item ;

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot data = ModalRoute.of(context).settings.arguments;
    if(data !=null && i==0){
     item = data.data() ;
    _nombre =  item['nombre'] ;
    _descripcion = item['descripcion'] ;
    _calificacion = item['calificacion'] ;
    
      _nombreController.text = _nombre;
      _descripcionController.text = _descripcion;
      _calificacionController.text = _calificacion;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Calificacion"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Asignatura",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    labelText: "Asignatura",
                    prefixIcon: Icon(Icons.text_format_sharp,color: Colors.blue,)),
                controller: _nombreController,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Descripcion",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    labelText: "Descripcion",
                    prefixIcon: Icon(Icons.text_format,color: Colors.blue,)),
                controller: _descripcionController,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Calificacion",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    labelText: "Calificacion",
                    prefixIcon: Icon(Icons.format_list_numbered, color: Colors.blue,)),
                controller: _calificacionController,
              ),
            ),
                       
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                 setState(() {
                  i++;
                  _nombre = _nombreController.text;
                  _descripcion = _descripcionController.text;
                  _calificacion = _calificacionController.text;
                });
                
                if (_nombre != '' && _descripcion != '' && _calificacion != '') {
                  if (data != null) {
                    FirebaseFirestore.instance
                        .collection("student_calendar")
                        .doc(data.id)
                        .update({
                      "nombre": _nombre,
                      "descripcion": _descripcion,
                      "calificacion": _calificacion,
                    }).then((value) => Toast.show('Actualizado', context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM));
                  } else {
                    FirebaseFirestore.instance.collection("student_calendar").add({
                      "nombre": _nombre,
                      "descripcion": _descripcion,
                      "calificacion": _calificacion,
                      "categoria": 'Calificacion',
                      'id_usuario' : PreferenciasUsuario().usuario
                    }).then((value) {
                      Toast.show('Agregado', context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                      _descripcionController.text = '';
                      _nombreController.text = '';
                      _calificacionController.text = "";
                    });
                  }
                  
                   Navigator.pop(context);
                   paginaController.index = 6 ;
                   paginaController.pagina = 'Calificaciones' ;
                     for (int i = 0; i < 8; i++) {
                  if (i == 2)
                    paginaController.selections[i] = true;
                  else
                    paginaController.selections[i] = false;
                  }
                }
              },
              child: Text(data != null ? "Actualizar" : "Agregar", style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ),
    );
  }

}
