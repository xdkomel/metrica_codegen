import 'package:metrica_codegen/runner.dart';

String Function(String) indent(int depth) => (s) {
      final postFix = [
        for (int i = 0; i < depth * Runner.indentLength; i++) ' ',
      ].join();
      return '$postFix$s';
    };
