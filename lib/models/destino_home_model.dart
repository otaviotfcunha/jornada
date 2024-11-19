class DestinosHomeModel {
  List<DestinoHome> results = [];

  DestinosHomeModel(this.results);

  DestinosHomeModel.fromJson(List<dynamic> jsonList) {
    results = jsonList.map((json) => DestinoHome.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

class DestinoHome {
  int id = 0;
  String nome = "";

  DestinoHome(this.id, this.nome);

  DestinoHome.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    return data;
  }

  Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    return data;
  }
}
