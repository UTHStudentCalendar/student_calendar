import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_calendar/src/controller/menu_controller.dart';
import 'package:student_calendar/src/provider/preferencias.dart';
import 'package:toast/toast.dart';

class AgregarAsignaturaPage extends StatefulWidget {
  AgregarAsignaturaPage({Key key}) : super(key: key);

  @override
  _AgregarAsignaturaPageState createState() => _AgregarAsignaturaPageState();
}

class _AgregarAsignaturaPageState extends State<AgregarAsignaturaPage> {
  final paginaController = MenuController();
  TextEditingController _nombreController = new TextEditingController();
  TextEditingController _descripcionController = new TextEditingController();
  TextEditingController _catedraticoController = new TextEditingController();
  int i = 0;
  DateTime _fecha;
  Timestamp fechaT;
  String _nombre = '';
  String  _descripcion ='';
  String _catedratico = '';
   Map<String, dynamic> item ;

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot data = ModalRoute.of(context).settings.arguments;
    if(data !=null && i==0){
     item = data.data() ;
    _nombre =  item['nombre'] ;
    _descripcion = item['descripcion'] ;
    _catedratico = item['catedratico'] ;
    
      _nombreController.text = _nombre;
      _descripcionController.text = _descripcion;
      _catedraticoController.text = _catedratico;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Asignatura"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Nombre",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    labelText: "Nombre",
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
                    prefixIcon: Icon(Icons.text_format, color: Colors.blue,)),
                controller: _descripcionController,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Catedratico",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    labelText: "Catedratico",
                    prefixIcon: Icon(Icons.person,color: Colors.blue,)),
                controller: _catedraticoController,
              ),
            ),
                       
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                 setState(() {
                  i++;
                  _nombre = _nombreController.text;
                  _descripcion = _descripcionController.text;
                  _catedratico = _catedraticoController.text;
                });
                
                if (_nombre != '' && _descripcion != '' && _catedratico != '') {
                  if (data != null) {
                    FirebaseFirestore.instance
                        .collection("student_calendar")
                        .doc(data.id)
                        .update({
                      "nombre": _nombre,
                      "descripcion": _descripcion,
                      "catedratico": _catedratico,
                    }).then((value) => Toast.show('Actualizado', context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM));
                  } else {
                    FirebaseFirestore.instance.collection("student_calendar").add({
                      "nombre": _nombre,
                      "descripcion": _descripcion,
                      "catedratico": _catedratico,
                      "categoria": 'Asignatura',
                      'id_usuario' : PreferenciasUsuario().usuario
                    }).then((value) {
                      Toast.show('Agregado', context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                      _descripcionController.text = '';
                      _nombreController.text = '';
                      _catedraticoController.text = "";
                    });
                  }
                  
                   Navigator.pop(context);
                   paginaController.index = 4 ;
                   paginaController.pagina = 'Asignatura' ;
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
