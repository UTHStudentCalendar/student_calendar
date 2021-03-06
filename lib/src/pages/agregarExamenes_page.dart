import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_calendar/src/controller/menu_controller.dart';
import 'package:student_calendar/src/provider/preferencias.dart';
import 'package:toast/toast.dart';

class AgregarExamenPage extends StatefulWidget {
  AgregarExamenPage({Key key}) : super(key: key);

  @override
  _AgregarExamenPageState createState() => _AgregarExamenPageState();
}

class _AgregarExamenPageState extends State<AgregarExamenPage> {
  final paginaController = MenuController();
  TextEditingController _nombreController = new TextEditingController();
  TextEditingController _descripcionController = new TextEditingController();
  TextEditingController _asignaturaController = new TextEditingController();
  TextEditingController _fechaController = new TextEditingController();
  int i = 0;
  DateTime _fecha;
  Timestamp fechaT;
  String _nombre = '';
  String  _descripcion ='';
  String _asignatura = '';
   Map<String, dynamic> item ;

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot data = ModalRoute.of(context).settings.arguments;
    if(data !=null && i==0){
     item = data.data() ;
    _nombre =  item['nombre'] ;
    _descripcion = item['descripcion'] ;
    _asignatura = item['asignatura'] ;
    fechaT = item['fecha'];
    _fecha =  fechaT.toDate();
    
      _nombreController.text = _nombre;
      _descripcionController.text = _descripcion;
      _asignaturaController.text = _asignatura;
      _fechaController.text = _fecha.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Examenes"),
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
                    prefixIcon: Icon(Icons.text_format,color: Colors.blue,)),
                controller: _descripcionController,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Asignatura",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    labelText: "Asignatura",
                    prefixIcon: Icon(Icons.assignment, color: Colors.blue,)),
                controller: _asignaturaController,
              ),
            ),
           Container(
              margin: EdgeInsets.all(10.0),
              child: TextField(
                controller: _fechaController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                    hintText: 'Seleccione una fecha',
                    labelText: 'Seleccione una fecha:',
                    prefixIcon: Icon(Icons.calendar_today_sharp,color: Colors.blue,)),
                onTap: ()  {
                  FocusScope.of(context).requestFocus(new FocusNode());
                    _mostrarCalendario(context);
                },
              )
              ),
            
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                 setState(() {
                  i++;
                  print("_fecha $_fecha");
                  _nombre = _nombreController.text;
                  _descripcion = _descripcionController.text;
                  _asignatura = _asignaturaController.text;
                });
                
                if (_nombre != '' && _descripcion != '' && _asignatura != '') {
                  if (data != null) {
                    FirebaseFirestore.instance
                        .collection("student_calendar")
                        .doc(data.id)
                        .update({
                      "nombre": _nombre,
                      "descripcion": _descripcion,
                      "asignatura": _asignatura,
                      "fecha": _fecha
                    }).then((value) => Toast.show('Actualizado', context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM));
                  } else {
                    FirebaseFirestore.instance.collection("student_calendar").add({
                      "nombre": _nombre,
                      "descripcion": _descripcion,
                      "asignatura": _asignatura,
                      "fecha": _fecha,
                      "categoria": 'Examen',
                      'id_usuario' : PreferenciasUsuario().usuario
                    }).then((value) {
                      Toast.show('Agregado', context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                      _descripcionController.text = '';
                      _fechaController.text = '';
                      _nombreController.text = '';
                      _asignaturaController.text = "";
                    });
                  }
                  
                     Navigator.pop(context);
                   paginaController.index = 5 ;
                   paginaController.pagina = 'Examenes' ;
                     for (int i = 0; i < 7; i++) {
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

  void _mostrarCalendario(BuildContext context) async {
  DateTime fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2022),
    );
    if (fecha != null){
    setState(() {
      i++;
     _fechaController.text = fecha.toString(); 
     _fecha = fecha;
    });
    }
  }
}
