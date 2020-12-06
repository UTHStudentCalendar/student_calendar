import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificacionesProvider{

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

//Streams
StreamController<String> _notificacionStreamController = StreamController<String>.broadcast();

Stream<String> get notificacionStreamController => _notificacionStreamController.stream;

dispose(){
  _notificacionStreamController?.close();
}

static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}


initNotificaciones() async {

 await _firebaseMessaging.requestNotificationPermissions();

  //guardar en preferencias
  //firebase sql
  //api propia
  String token = await _firebaseMessaging.getToken();
  print(token);

_firebaseMessaging.configure(
      onMessage: onMessage,
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: onLaunch,
      onResume: onResume,
    );

}
Future<dynamic> onMessage(Map<String, dynamic> message) async{
//mostrar una notificacion local
//enviar a una pantalla especifica
//mostrar una alerta con la informacion de notificacion
print("onMessage: $message");
print('${message["data"]["pantalla"]}');

_notificacionStreamController.sink.add(message["data"]["pantalla"]);
}

Future<dynamic> onLaunch(Map<String, dynamic> message) async{
print("onLaunch: $message");
_notificacionStreamController.sink.add(message["data"]["pantalla"]);
}
Future<dynamic> onResume(Map<String, dynamic> message) async{
print("onResume: $message");
_notificacionStreamController.sink.add(message["data"]["pantalla"]);
}

}