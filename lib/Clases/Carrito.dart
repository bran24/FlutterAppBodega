import 'package:flutter/foundation.dart';

import 'Item.dart';

class Carrito {
  final List<Item> _items = [];

  /// Una vista inmodificable de items en el carrito.
  List<Item> get items => _items;

  /// El precio total actual de todos los items (asumiendo que todos cuestan $42).
  int get totalPrice => _items.length * 42;

  /// Añadir [item] al carro. Esta es la única manera de modificar el carrito desde fuera.
  void add(Item item) {
    _items.add(item);
    // Esta llamada dice a los widgets que están escuchando este modelo que se reconstruyan.
  }
}
