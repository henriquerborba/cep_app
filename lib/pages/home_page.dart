import 'package:cep_app/models/endereco_model.dart';
import 'package:cep_app/repository/cep_repository_impl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cepRepository = CepRepositoryImpl();

  final formKey = GlobalKey<FormState>();

  final cepEC = TextEditingController();

  EnderecoModel? endereco;
  var loading = false;

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar CEP'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: cepEC,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CEP obrigatório';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final valid = formKey.currentState?.validate() ?? false;
                  if (valid) {
                    try {
                      setState(() {
                        loading = true;
                      });
                      final response =
                          await cepRepository.getAdress(cepEC.text);
                      setState(() {
                        endereco = response;
                      });
                    } catch (e) {
                      setState(() {
                        endereco = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    } finally {
                      setState(() {
                        loading = false;
                      });
                    }
                  }
                },
                child: const Text('Buscar'),
              ),
              Visibility(
                visible: loading,
                child: const CircularProgressIndicator(),
              ),
              Visibility(
                visible: endereco != null,
                child: Text(
                    '${endereco?.logradouro} ${endereco?.complemento} ${endereco?.bairro} ${endereco?.localidade}'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
