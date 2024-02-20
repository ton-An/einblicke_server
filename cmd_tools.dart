import 'dart:io';

import 'package:args/args.dart';
import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/create_user.dart';
import 'package:einblicke_server/features/image_exchange/domain/usecases/pair_curator_x_frame.dart';
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
    case "create_picture_frame":
      createPictureFrame(argResults.arguments[1], argResults.arguments[2]);
      break;
    case "pair_curator_x_frame":
      pairCuratorXFrame(argResults.arguments[1], argResults.arguments[2]);
      break;
    default:
      stdout.writeln("Unknown command");
  }
}

void createCurator(String username, String password) async {
  final CreateCurator createCurator = getIt();

  final Either<Failure, Curator> curatorEither =
      await createCurator(username, password);

  curatorEither.fold(
      (Failure failure) => stdout.writeln("Oh, oh: " + failure.toString()),
      (Curator curator) {
    stdout.writeln("Curator created: " + curator.toString());
  });
}

void createPictureFrame(String username, String password) async {
  final CreatePictureFrame createPictureFrame = getIt();

  final Either<Failure, Frame> curatorEither =
      await createPictureFrame(username, password);

  curatorEither.fold(
      (Failure failure) => stdout.writeln("Oh, oh: " + failure.toString()),
      (Frame frame) {
    stdout.writeln("Frame created: " + frame.toString());
  });
}

void pairCuratorXFrame(String curatorId, String frameId) async {
  final PairCuratorXFrame pairCuratorXFrame = getIt();

  final Either<Failure, None> pairEither =
      await pairCuratorXFrame(curatorId: curatorId, frameId: frameId);

  pairEither.fold(
    (Failure failure) => stdout.writeln("Oh, oh: " + failure.toString()),
    (None none) => stdout.writeln("Pairing successful"),
  );
}
