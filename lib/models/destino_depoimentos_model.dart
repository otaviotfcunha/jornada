import 'dart:math';

class DepoimentosDestinoModel {
  List<DepoimentoDestinoModel> results = [];

  DepoimentosDestinoModel(this.results);

  DepoimentosDestinoModel.fromJson(List<dynamic> jsonList) {
    // Verificar se jsonList contém uma lista de listas
    if (jsonList.isNotEmpty && jsonList.first is List) {
      for (var innerList in jsonList) {
        if (innerList is List) {
          results.addAll(innerList.map((json) => DepoimentoDestinoModel.fromJson(json)).toList());
        }
      }
    } else {
      results = jsonList.map((json) => DepoimentoDestinoModel.fromJson(json)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

class DepoimentoDestinoModel {
  int id = 0;
  String nome = "";
  String textoDepoimento = "";
  String local = "";
  int nota = 0;

  DepoimentoDestinoModel(this.id, this.nome, this.textoDepoimento, this.local, this.nota);

  DepoimentoDestinoModel.fromJson(Map<String, dynamic> json) {
    Random random = Random();
    id = json['id'];
    nome = json['nome'];
    textoDepoimento = json['textoDepoimento'];
    local = json['local'];
    nota = random.nextInt(5) + 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['textoDepoimento'] = this.textoDepoimento;
    data['local'] = this.local;
    data['nota'] = this.nota;
    return data;
  }

  Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['textoDepoimento'] = this.textoDepoimento;
    data['local'] = this.local;
    data['nota'] = this.nota;
    return data;
  }
}
