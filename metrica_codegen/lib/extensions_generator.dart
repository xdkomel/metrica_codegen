class ExtensionsGenerator {
  List<String> get generateExtensions => [
        'extension on List {',
        '  dynamic get toJson => map((e) => e.toJson).toList();',
        '}',
        ...['int', 'double', 'bool', 'String'].expand(_idToJson),
      ];

  Iterable<String> _idToJson(String name) => [
        'extension on $name {',
        '  dynamic get toJson => this;',
        '}',
      ];
}
