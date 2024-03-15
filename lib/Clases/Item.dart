class Item {
  int _Id = 1;
  late final String _Nombre;
  late final String _Marca;
  late final String _Modelo;
  Item(this._Nombre, this._Marca, this._Modelo);

  String get Nombre => this._Nombre;
  set Nombre(String n) {
    _Nombre = n;
  }

  String get Marca => this._Marca;
  set Marca(String n) {
    _Marca = n;
  }

  String get Modelo => this._Modelo;
  set Modelo(String n) {
    _Modelo = n;
  }
}
