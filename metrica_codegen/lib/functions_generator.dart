import 'package:metrica_codegen/utils.dart';
import 'package:yaml/yaml.dart';

class FunctionsGenerator {
  Iterable<String> generateFunctions(YamlList funs) => [
        'abstract class AbstractReporter {',
        indent(1)('Future<void> reportEventWithMap(String key, dynamic body);'),
        '}',
        'class MetricaReporter {',
        indent(1)('final AbstractReporter _reporter;'),
        indent(1)('const MetricaReporter(this._reporter);'),
        ...funs
            .expand(
              (f) => _genFun(f),
            )
            .map(indent(1)),
        '}'
      ];

  Iterable<String> _genFun(YamlMap fun) => [
        'void report${fun["name"]}(${fun["obj"]} object) => _reporter.reportEventWithMap(',
        ..._parsePath(fun["path"]).map(indent(1)),
        ');',
      ];

  Iterable<String> _parsePath(String path) => _parsePathRec(
        path.split('/'),
        funCall: true,
      );

  Iterable<String> _parsePathRec(
    List<String> path, {
    bool funCall = false,
  }) =>
      switch (path) {
        [String e] when funCall => ['\"$e\", object.toJson,'],
        [String e] => ['\"$e\" : object.toJson'],
        _ when funCall => [
            '\"${path.first}\",',
            '{',
            ..._parsePathRec(path.sublist(1)).map(indent(1)),
            '},',
          ],
        _ => [
            '\"${path.first}\" : {',
            ..._parsePathRec(path.sublist(1)).map(indent(1)),
            '}',
          ],
      };
}
