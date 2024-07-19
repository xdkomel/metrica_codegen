import 'package:metrica_codegen/utils.dart';
import 'package:yaml/yaml.dart';

class DataTypesGenerator {
  List<String> generateTypes(YamlList dataTypes) => dataTypes
      .expand(
        (s) => [..._generateOneType(s), ''],
      )
      .toList();

  List<String> _generateOneType(YamlMap obj) => [
        'class ${obj["name"]} {',
        ..._generateVars(obj['vars']).map(indent(1)),
        ..._generateConstructor(obj["name"], obj['vars']).map(indent(1)),
        ..._toJson(obj['repr'], obj['vars']).map(indent(1)),
        '}',
      ];

  Iterable<String> _generateVars(YamlList vars) => vars.map(
        (v) => 'final ${_mapType(v["type"])} ${v["name"]};',
      );

  Iterable<String> _generateConstructor(String name, YamlList vars) => [
        'const $name(',
        ...vars.map((v) => 'this.${v["name"]},').map(indent(1)),
        ');',
      ];

  Iterable<String> _toJson(String? reprRule, YamlList vars) {
    final body = switch (reprRule) {
      null => _toJsonVars(vars),
      String rule => _toJsonRepr(rule),
    };
    return [
      'dynamic get toJson => ' + body[0],
      ...body.sublist(1),
    ];
  }

  List<String> _toJsonRepr(String reprRule) => ['\"$reprRule\";'];

  List<String> _toJsonVars(YamlList vars) => [
        '{',
        ...vars.map((v) => '${_varKey(v)}: ${_varVal(v)},').map(indent(1)),
        '};',
      ];

  String _varKey(YamlMap variable) => switch (variable['key']) {
        null => "\"${variable['name']}\"",
        _ => _format(
            variable['name'],
            "\"${variable['key']}\"",
          ),
      };

  String _varVal(YamlMap variable) => switch (variable['val']) {
        null => variable['name'],
        _ => _format(
            variable['name'],
            "\"${variable['val']}\"",
          ),
      };

  String _format(String varName, String line) => line.replaceAll('\$', '\$$varName');

  String _mapType(String type) => switch (type) {
        'str' => 'String',
        String t when t.startsWith('list<') => 'List<${_mapType(type.substring(5, type.length - 1))}>',
        _ => type,
      };
}
