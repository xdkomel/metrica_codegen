extension on List {
  dynamic get toJson => map((e) => e.toJson).toList();
}

extension on int {
  dynamic get toJson => this;
}

extension on double {
  dynamic get toJson => this;
}

extension on bool {
  dynamic get toJson => this;
}

extension on String {
  dynamic get toJson => this;
}

class SpecCat {
  final int specCatId;
  final String specCatName;
  const SpecCat(
    this.specCatId,
    this.specCatName,
  );
  dynamic get toJson => "${specCatId.toJson} and ${specCatName.toJson}";
}

class SpecialistsCategories {
  final List<String> specialistsNamesList;
  final List<SpecCat> specialistsCategoriesList;
  const SpecialistsCategories(
    this.specialistsNamesList,
    this.specialistsCategoriesList,
  );
  dynamic get toJson => {
        "Выбраны специалисты": "Имена: ${specialistsNamesList.toJson}",
        "Категории специалистов": specialistsCategoriesList.toJson,
      };
}

class SearchingData {
  final String query;
  const SearchingData(
    this.query,
  );
  dynamic get toJson => {
        "Поисковый запрос": query.toJson,
      };
}

abstract class AbstractReporter {
  Future<void> reportEventWithMap(String key, dynamic body);
}

class MetricaReporter {
  final AbstractReporter _reporter;
  const MetricaReporter(this._reporter);
  void reportDutyExpertSelected(SpecialistsCategories object) => _reporter.reportEventWithMap(
        "new_flow",
        {"Дежурный эксперт": object.toJson},
      );
  void reportSearchInitiated(SearchingData object) => _reporter.reportEventWithMap(
        "new_flow",
        {
          "Поиск": {
            "Экран Поиска": {"Поисковый запрос": object.toJson}
          }
        },
      );
}
