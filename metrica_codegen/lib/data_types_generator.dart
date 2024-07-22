import 'dart:collection';

import 'package:metrica_codegen/utils.dart';
import 'package:yaml/yaml.dart';

class DataTypesGenerator {
  Iterable<String> generateTypes(YamlList dataTypes) => dataTypes.expand(
        (s) => [..._generateOneType(s), ''],
      );

  Iterable<String> _generateOneType(YamlMap obj) => [
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
      String rule => _toJsonRepr(
          HashSet.from(vars.map((v) => v['name'])),
          rule,
        ),
    };
    return [
      'dynamic get toJson => ' + body[0],
      ...body.sublist(1),
    ];
  }

  List<String> _toJsonRepr(HashSet<String> vars, String reprRule) {
    final dollarSigns = reprRule.runes.indexed
        .where(
          (e) => e.$2 == '\$'.runes.first,
        )
        .map((e) => e.$1)
        .map((i) => i + 1);
    final body = dollarSigns.fold(
      (reprRule, 0),
      (acc, index) => _applyVars(vars, acc.$1, index + acc.$2),
    );
    return ['\"${body.$1}\";'];
  }

  (String, int) _applyVars(HashSet<String> vars, String str, int indexFrom) {
    final (start, other) = (
      str.substring(0, indexFrom),
      str.substring(indexFrom),
    );
    return vars.fold(
      (str, 0),
      (acc, name) {
        if (other.startsWith(name)) {
          final end = other.substring(name.length);
          final newStr = start + '{$name.toJson}' + end;
          return (newStr, newStr.length - str.length);
        }
        return acc;
      },
    );
  }

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
        null => '${variable["name"]}.toJson',
        _ => _format(
            variable['name'],
            "\"${variable['val']}\"",
          ),
      };

  String _format(String varName, String line) => line.replaceAll('\$', '\${$varName.toJson}');

  String _mapType(String type) => switch (type) {
        'str' => 'String',
        String t when t.startsWith('list<') => 'List<${_mapType(type.substring(5, type.length - 1))}>',
        _ => type,
      };
}
