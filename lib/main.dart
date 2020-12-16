import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:student_calendar/src/pages/agregarAsignatura_page.dart';
import 'package:student_calendar/src/pages/agregarCalificaciones_page.dart';
import 'package:student_calendar/src/pages/agregarExamenes_page.dart';
import 'package:student_calendar/src/pages/agregarHorario_page.dart';
import 'package:student_calendar/src/pages/agregarTarea_page.dart';
import 'package:student_calendar/src/pages/home_page.dart';
import 'package:student_calendar/src/pages/login_page.dart';
import 'package:student_calendar/src/pages/perfil_page.dart';
import 'package:student_calendar/src/provider/notificaciones_provider.dart';
import 'package:student_calendar/src/provider/preferencias.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations(
   [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
 );
 
  PreferenciasUsuario preferenciasUsuario = new PreferenciasUsuario();
  await preferenciasUsuario.iniciarPreferencias();
  runApp(MyApp());
  }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

 class _MyAppState extends State<MyApp>{

 final navigatorKey = GlobalKey<NavigatorState>();
 final preferencias = PreferenciasUsuario();

   @override
   void initState() { 
     
    final _notificacionesProvider = new NotificacionesProvider();

    _notificacionesProvider.initNotificaciones();
   
    _notificacionesProvider.notificacionStreamController.listen((data) { 
     print("data desde el main $data");

    navigatorKey.currentState.pushReplacementNamed('inicio');


    });
     super.initState();
   }
  Widget build(BuildContext context) {

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Material App',
           localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('es', 'ES'),
      ],
      initialRoute: preferencias.usuario==''?'home':'inicio',
      routes:{ 'home': (context) => LoginPage(),
      'inicio': (context) => HomePage(),
      'perfil': (context) => PerfilPage(),
      'agregar':(context)=>AgregarExamenPage(),
      'agregarAsignatura':(context)=> AgregarAsignaturaPage(),
      "agregarCalificacion": (context)=> AgregarCalificacionPage(),
      "agregarTarea": (context)=> AgregarTarePage(),
      "agregarHorario": (context) => AgregarHorarioPage()
      }
    );
  }


}


