import 'package:shared_preferences/shared_preferences.dart';

enum STORAGE_CHAVES {
  CHAVE_NOME_USUARIO,
  CHAVE_TELEFONE_USUARIO,
  CHAVE_EMAIL_USUARIO,
  CHAVE_FOTO_USUARIO,
}

class AppStorageService {
  Future<void> setConfiguracoesNomeUsuario(String nome) async {
    await _setString(STORAGE_CHAVES.CHAVE_NOME_USUARIO.toString(), nome);
  }

  Future<String> getConfiguracoesNomeUsuario() async {
    return _getString(STORAGE_CHAVES.CHAVE_NOME_USUARIO.toString());
  }

  Future<void> setConfiguracoesTelefoneUsuario(String nome) async {
    await _setString(STORAGE_CHAVES.CHAVE_TELEFONE_USUARIO.toString(), nome);
  }

  Future<String> getConfiguracoesTelefoneUsuario() async {
    return _getString(STORAGE_CHAVES.CHAVE_TELEFONE_USUARIO.toString());
  }

  Future<void> setConfiguracoesEmailUsuario(String nome) async {
    await _setString(STORAGE_CHAVES.CHAVE_EMAIL_USUARIO.toString(), nome);
  }

  Future<String> getConfiguracoesEmailUsuario() async {
    return _getString(STORAGE_CHAVES.CHAVE_EMAIL_USUARIO.toString());
  }

  Future<void> setConfiguracoesFotoUsuario(String nome) async {
    await _setString(STORAGE_CHAVES.CHAVE_FOTO_USUARIO.toString(), nome);
  }

  Future<String> getConfiguracoesFotoUsuario() async {
    return _getString(STORAGE_CHAVES.CHAVE_FOTO_USUARIO.toString());
  }

  Future<void> _setString(String chave, String value) async {
    var storage = await SharedPreferences.getInstance();
    await storage.setString(chave, value);
  }

  Future<String> _getString(String chave) async {
    var storage = await SharedPreferences.getInstance();
    return storage.getString(chave) ?? "";
  }
}
