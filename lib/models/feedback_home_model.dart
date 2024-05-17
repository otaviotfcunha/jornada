class FeedbacksHomeModel {
  List<FeedbackHomeModel> results = [];

  FeedbacksHomeModel(this.results);

  FeedbacksHomeModel.fromJson(List<dynamic> jsonList) {
    results = jsonList.map((json) => FeedbackHomeModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

class FeedbackHomeModel {
  int id = 0;
  String nomeUsuario = "";
  String feedback = "";
  int nota = 0;

  FeedbackHomeModel(this.id, this.nomeUsuario, this.feedback, this.nota);

  FeedbackHomeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomeUsuario = json['nomeUsuario'];
    feedback = json['feedback'];
    nota = json['nota'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nomeUsuario'] = this.nomeUsuario;
    data['feedback'] = this.feedback;
    data['nota'] = this.nota;
    return data;
  }

  Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['nomeUsuario'] = this.nomeUsuario;
    data['feedback'] = this.feedback;
    data['nota'] = this.nota;
    return data;
  }
}
