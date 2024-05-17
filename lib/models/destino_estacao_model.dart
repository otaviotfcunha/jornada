class DestinosEstacaoModel {
  List<DestinoEstacaoModel> results = [];

  DestinosEstacaoModel(this.results);

  DestinosEstacaoModel.fromJson(List<dynamic> jsonList) {
    results = jsonList.map((json) => DestinoEstacaoModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

class DestinoEstacaoModel {
  int id = 0;
  String nome = "";
  String descricao = "";
  String estacao = "";

  DestinoEstacaoModel(this.id, this.nome, this.descricao, this.estacao);

  DestinoEstacaoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricaoCompleta'];
    estacao = json['estacaoRecomendada'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['descricaoCompleta'] = this.descricao;
    data['estacaoRecomendada'] = this.estacao;
    return data;
  }

  Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    data['estacao'] = this.estacao;
    return data;
  }
}
