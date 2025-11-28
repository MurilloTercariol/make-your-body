import 'package:flutter/material.dart';
import 'package:projeto_app/controller/treino_controller.dart';
import 'package:projeto_app/model/treino_model.dart';

class TiposdetreinosView extends StatefulWidget {
  const TiposdetreinosView({super.key});

  @override
  State<TiposdetreinosView> createState() => _TiposdetreinosState();
}

class _TiposdetreinosState extends State<TiposdetreinosView> {
  final controller = TreinoController();

  late Future<List<TreinoModel>> futureTreinos;

  @override
  void initState() {
    super.initState();
    futureTreinos = controller.listarDaApi(); // busca da API ao abrir tela
  }

  Future<void> importar() async {
    await controller.importarParaFirebase();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Importado para Firebase ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tipos de Treino"),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            onPressed: importar,
            tooltip: "Importar para Firebase",
          ),
        ],
      ),
      body: FutureBuilder<List<TreinoModel>>(
        future: futureTreinos,
        builder: (context, snapshot) {
          // enquanto está carregando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // erro na requisição
          if (snapshot.hasError) {
            return Center(
              child: Text("Erro ao carregar dados: ${snapshot.error}"),
            );
          }

          // lista vazia
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum treino encontrado"));
          }

          // sucesso
          final lista = snapshot.data!;

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (_, index) {
              final treino = lista[index];
              return ListTile(
                title: Text(treino.name),
                subtitle: Text("ID: ${treino.id}"),
              );
            },
          );
        },
      ),
    );
  }
}
