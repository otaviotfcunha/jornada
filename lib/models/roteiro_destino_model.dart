class RoteiroDestinoModel {
  String roteiro;

  RoteiroDestinoModel(this.roteiro);

  factory RoteiroDestinoModel.fromJson(String json) {
    return RoteiroDestinoModel(json);
  }

  Map<String, dynamic> toJson() {
    return {'roteiro': roteiro};
  }
}
