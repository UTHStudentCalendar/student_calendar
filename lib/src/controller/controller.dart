
import 'package:get/get.dart';

class PerfilController extends GetxController{

  RxString _nombre = ''.obs;
  RxString _foto = ''.obs;

set nombre(String valor) => this._nombre.value = valor;
 String get nombre => this._nombre.value;
 
set foto(String valor) => this._foto.value = valor;
 String get foto => this._foto.value;

 
}