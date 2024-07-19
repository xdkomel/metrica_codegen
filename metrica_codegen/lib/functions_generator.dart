import 'package:metrica_codegen/utils.dart';
import 'package:yaml/yaml.dart';

class FunctionsGenerator {
  List<String> generateFunctions(YamlList funs) => funs
      .expand(
        (f) => _genFun(f),
      )
      .toList();

  Iterable<String> _genFun(YamlMap fun) => [
        'void report${fun["name"]}(${fun["obj"]} object) => {',
        ..._parsePath(fun["path"]).map(indent(1)),
        '};',
      ];

  Iterable<String> _parsePath(String path) => _parsePathRec(path.split('/'));

  Iterable<String> _parsePathRec(List<String> path) => switch (path) {
        [String e] => ['\"$e\" : object.toJson'],
        _ => [
            '\"${path.first}\" : {',
            ..._parsePathRec(path.sublist(1)).map(indent(1)),
            '}',
          ],
      };
}
