import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/treino_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TipotreinoService {
  Future<List<TreinoModel>> listarTreinos() async {
    try {
      print('🔄 Buscando treinos da API wger.de...');
      final resposta = await http
          .get(Uri.parse('https://wger.de/api/v2/exercisecategory/'))
          .timeout(const Duration(seconds: 10));

      print('📡 Status da resposta: ${resposta.statusCode}');

      if (resposta.statusCode == 200) {
        final jsonData = json.decode(resposta.body);
        final lista = jsonData['results'] as List;
        print('✅ ${lista.length} treinos carregados com sucesso!');
        return lista.map((item) => TreinoModel.fromJson(item)).toList();
      }
      print('❌ Erro na API: Status ${resposta.statusCode}');
      return [];
    } catch (e) {
      print('❌ Erro ao buscar treinos: $e');
      return [];
    }
  }
}

class TreinoFirebaseService {
  final _db = FirebaseFirestore.instance;

  Future<void> salvarTreino(TreinoModel treino) async {
    await _db
        .collection('treinos')
        .doc(treino.id.toString())
        .set(treino.toMap());
  }

  Future<void> salvarLista(List<TreinoModel> lista) async {
    final batch = _db.batch();

    for (var treino in lista) {
      final ref = _db.collection('treinos').doc(treino.id.toString());
      batch.set(ref, treino.toMap());
    }

    await batch.commit();
  }
}
