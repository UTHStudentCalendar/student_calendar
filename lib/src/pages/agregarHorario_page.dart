import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:student_calendar/src/controller/menu_controller.dart';
import 'package:student_calendar/src/provider/preferencias.dart';
import 'package:toast/toast.dart';

class AgregarHorarioPage extends StatefulWidget {
  AgregarHorarioPage({Key key}) : super(key: key);

  @override
  _AgregarHorarioPageState createState() => _AgregarHorarioPageState();
}

class _AgregarHorarioPageState extends State<AgregarHorarioPage> {
  final paginaController = MenuController();
  TextEditingController _asignaturaController = new TextEditingController();
  TextEditingController _fechaController = new TextEditingController();
  TextEditingController _fechaController2 = new TextEditingController();
    TextEditingController _fechaController3 = new TextEditingController();
  int i = 0;
  DateTime _fecha;
  Timestamp fechaT;
  String _horai;
  String _horaf;
  String _asignatura = '';
   Map<String, dynamic> item ;

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot data = ModalRoute.of(context).settings.arguments;
    if(data !=null && i==0){
     item = data.data() ;
    _asignatura = item['asignatura'] ;
    _horai = item['horai'];
    _horaf = item['horaf'];
    fechaT = item['fecha'];
    _fecha =  fechaT.toDate();
    
      _fechaController3.text = _fecha.toString();
      _asignaturaController.text = _asignatura;
      _fechaController.text = _horai;
      _fechaController2.text = _horaf;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Horario"),
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
                    prefixIcon: Icon(Icons.assignment,color: Colors.blue,)),
                controller: _asignaturaController,
              ),
            ),
              Container(
              margin: EdgeInsets.all(10.0),
              child: TextField(
                onTap: () async{
                  _mostrarHora(context,1);
                },
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    hintText: "Hora Inicio",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    labelText: "Hora Inicio",
                    prefixIcon: Icon(Icons.watch_later,color: Colors.blue,)),
                controller: _fechaController,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: TextField(
                onTap: (){
                  _mostrarHora(context, 2);
                },
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    hintText: "Hora Final",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    labelText: "Hora final",
                    prefixIcon: Icon(Icons.watch_later,color: Colors.blue,)),
                controller: _fechaController2,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: TextField(
                controller: _fechaController3,
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
                  _asignatura = _asignaturaController.text;
                  _horai = _fechaController.text;
                  _horaf = _fechaController2.text;
                });
                
                if ( _asignatura != '') {
                  if (data != null) {
                    FirebaseFirestore.instance
                        .collection("student_calendar")
                        .doc(data.id)
                        .update({
                      "asignatura": _asignatura,
                      "horai": _horai,
                      "horaf": _horaf,
                      "fecha": _fecha,
                    }).then((value) => Toast.show('Actualizado', context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM));
                  } else {
                    FirebaseFirestore.instance.collection("student_calendar").add({
                      "nombre":'',
                      "asignatura": _asignatura,
                      "horai": _horai,
                      "horaf": _horaf,
                      "fecha": _fecha,
                      "categoria": 'Horario',
                      'id_usuario' : PreferenciasUsuario().usuario
                    }).then((value) {
                      Toast.show('Agregado', context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                      _fechaController.text = '';
                      _asignaturaController.text = "";
                      _fechaController2.text = '';
                    });
                  }
                     Navigator.pop(context);
                }
              },
              child: Text(data != null ? "Actualizar" : "Agregar", style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ),
    );
  }

  void _mostrarHora(BuildContext context, int index) async {
  TimeOfDay fecha = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    print("fecha $fecha");
    if (fecha != null){
     String hour = fecha.hour.toString() + ' : '+  fecha.minute.toString();
    setState(() {
      i++;
      if(index ==1){
      _fechaController.text = hour;}
     if(index ==2){
     _fechaController2.text = hour;}
    });
    }
  }

  void _mostrarCalendario(BuildContext context) async {
  DateTime fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2022),
    );
    print("fecha $fecha");
    if (fecha != null){
    setState(() {
      i++;
     _fechaController3.text = fecha.toString(); 
     _fecha = fecha;
     print("_fecha $_fecha");
    });
    }
  }
}
