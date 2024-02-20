import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:einblicke_server/injection_container.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  sqfliteFfiInit();

  await initGetIt();

  return serve(handler, ip, port);
}
