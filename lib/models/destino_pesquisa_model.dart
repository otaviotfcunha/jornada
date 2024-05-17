class DestinosPesquisaModel {
  List<DestinoPesquisaModel> results = [];

  DestinosPesquisaModel(this.results);

  DestinosPesquisaModel.fromJson(List<dynamic> jsonList) {
    results = jsonList.map((json) => DestinoPesquisaModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

class DestinoPesquisaModel {
  int id = 0;
  String nome = "";
  String descricaoCompleta = "";
  String estacaoRecomendada = "";

  DestinoPesquisaModel(this.id, this.nome, this.descricaoCompleta, this.estacaoRecomendada);

  DestinoPesquisaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricaoCompleta = json['descricaoCompleta'];
    estacaoRecomendada = json['estacaoRecomendada'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['descricaoCompleta'] = this.descricaoCompleta;
    data['estacaoRecomendada'] = this.estacaoRecomendada;
    return data;
  }

  Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['descricaoCompleta'] = this.descricaoCompleta;
    data['estacaoRecomendada'] = this.estacaoRecomendada;
    return data;
  }
}
