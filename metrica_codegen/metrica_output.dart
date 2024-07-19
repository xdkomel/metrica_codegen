class SpecCat {
  final int specCatId;
  final String specCatName;
  const SpecCat(
    this.specCatId,
    this.specCatName,
  );
  dynamic get toJson => "($specCatId, $specCatName)";
}

class SpecialistsCategories {
  final List<String> specialistsNamesList;
  final List<SpecCat> specialistsCategoriesList;
  const SpecialistsCategories(
    this.specialistsNamesList,
    this.specialistsCategoriesList,
  );
  dynamic get toJson => {
    "Выбраны специалисты": "Имена: $specialistsNamesList",
    "Категории специалистов": specialistsCategoriesList,
  };
}

class SearchingData {
  final String query;
  const SearchingData(
    this.query,
  );
  dynamic get toJson => {
    "Поисковый запрос": query,
  };
}


void reportDutyExpertSelected(SpecialistsCategories object) => {
  "new_flow" : {
    "Дежурный эксперт" : object.toJson
  }
};
void reportSearchInitiated(SearchingData object) => {
  "new_flow" : {
    "Поиск" : {
      "Экран Поиска" : {
        "Поисковый запрос" : object.toJson
      }
    }
  }
};