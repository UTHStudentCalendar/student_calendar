import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario{
  SharedPreferences _pref;

  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  PreferenciasUsuario._internal();
  
  factory PreferenciasUsuario(){
    return _instancia;
  }

  Future<void> iniciarPreferencias() async{
    this._pref = await SharedPreferences.getInstance();
  }



  String get usuario => this._pref.getString('usuario') ?? "";
  set usuario(String valor)=> this._pref.setString("usuario", valor);



  delete(){
    this._pref.remove('usuario');
  }
}