import 'dart:io';

import 'package:metrica_codegen/data_types_generator.dart';
import 'package:metrica_codegen/functions_generator.dart';
import 'package:yaml/yaml.dart';

abstract class Runner {
  static int indentLength = 2;

  static void run(List<String> args) async {
    final file = File(args[0]);
    final contents = await file.readAsString();
    final yaml = loadYaml(contents);
    final typeGenerator = DataTypesGenerator();
    final funsGenerator = FunctionsGenerator();
    final lines = [
      ...typeGenerator.generateTypes(yaml['data_types']),
      '',
      ...funsGenerator.generateFunctions(yaml['events']),
    ].join('\n');
    await File('metrica_output.dart').writeAsString(lines);
  }
}
