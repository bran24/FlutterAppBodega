import 'package:flutter/foundation.dart';

class Usuario {
  late String _correo = "@GMAIL";
  late String _nombre;
  late String _apellido;
  late String _password;
  String get correo => _correo;
  String get nombre => _nombre;
  String get apellido => _apellido;
  String get password => _password;

  set correo(String n) {
    _correo = n;
  }

  set nombre(String n) {
    _nombre = n;
  }

  set apellido(String n) {
    _apellido = n;
  }

  set password(String n) {
    _password = n;
  }

  // Usuario(this._nombre, this._apellido, this._correo, this._password);
}
