import 'package:cep_app/models/endereco_model.dart';

abstract class CepRepository {
  Future<EnderecoModel> getAdress(String cep);
}
