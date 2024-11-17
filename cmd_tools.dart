import 'dart:io';

import 'package:args/args.dart';
import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/create_curator.dart';
import 'package:einblicke_server/injection_container.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

main(List<String> arguments) async {
  sqfliteFfiInit();
  await initGetIt();
  exitCode = 0;
  final parser = ArgParser();

  final argResults = parser.parse(arguments);

  switch (argResults.arguments.first) {
    case "create_curator":
      createCurator(argResults.arguments[1], argResults.arguments[2]);
      break;
    default:
      stdout.writeln("Unknown command");
  }
}

void createCurator(String username, String password) async {
  final CreateCurator createCuratorUsecase = getIt();

  final Either<Failure, Curator> curatorEither =
      await createCuratorUsecase(username, password);

  curatorEither.fold(
      (Failure failure) => stdout.writeln("Oh, oh: " + failure.toString()),
      (Curator curator) {
    stdout.writeln("Curator created: " + curator.toString());
  });
}
