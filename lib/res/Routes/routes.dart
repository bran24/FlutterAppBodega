import 'package:flutter_login_taxi/Vistas/ventas_screen/ventas_screen%20.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../Binding/BotellasBinding.dart';
import '../../Binding/ClientesBinding.dart';
import '../../Binding/LoginBinding.dart';
import '../../Binding/ProductoBinding.dart';
import '../../Binding/ProfileBinding.dart';
import '../../Binding/ProveedorBinding.dart';
import '../../Binding/RegistrarUserBinding.dart';
import '../../Binding/VentasBinding.dart';
import '../../Vistas/Login.dart';
import '../../Vistas/Registrar.dart';
import '../../Vistas/botellas_screen/botellas_screen.dart';
import '../../Vistas/clientes_screen/clientes_screen.dart';
import '../../Vistas/home_screen/home_screen.dart';
import '../../Vistas/productos_screen/productos_screen.dart';
import '../../Vistas/profile_screen/profile_screen.dart';
import '../../Vistas/proveedores_screen/proveedor_screen.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(name: '/Login', page: () => Login(), binding: LoginBinding()),
        GetPage(
          name: '/Home',
          page: () => homescreen(),
        ),
        GetPage(
            name: '/Producto',
            page: () => productosscreen(),
            binding: ProductoBinding()),
        GetPage(
            name: '/Botella',
            page: () => botellasscreen(),
            binding: BotellasBinding()),
        GetPage(
            name: '/Proveedor',
            page: () => proveedorscreen(),
            binding: ProveedorBinding()),
        GetPage(
            name: '/Clientes',
            page: () => clientescreen(),
            binding: ClientesBinding()),
        GetPage(
            name: '/Profile',
            page: () => profilescreen(),
            binding: ProfileBinding()),
        GetPage(
            name: '/RegistrarUser',
            page: () => Registrar(),
            binding: RegistrarUserBinding()),
        GetPage(
            name: '/Ventas',
            page: () => ventasscreen(),
            binding: VentasBinding()),
      ];
}
