import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/treino_salvo_model.dart';
import '../model/exercicio_model.dart';

class TreinosUsuarioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obter ID do usuário atual
  String? get _userId => _auth.currentUser?.uid;

  // Referência para a coleção de treinos do usuário
  CollectionReference? get _treinosCollection {
    if (_userId == null) return null;
    return _db.collection('users').doc(_userId).collection('treinos');
  }

  // CREATE - Criar novo treino
  Future<String?> criarTreino({
    required String nome,
    required List<ExercicioModel> exercicios,
  }) async {
    try {
      // Forçar atualização do usuário atual
      await _auth.currentUser?.reload();
      final currentUser = _auth.currentUser;

      print('🔵 Iniciando criação de treino...');
      print('🔵 Current User Email: ${currentUser?.email}');
      print('🔵 Current User ID: ${currentUser?.uid}');
      print('🔵 Caminho: users/${currentUser?.uid}/treinos');

      if (currentUser == null || currentUser.uid.isEmpty) {
        print('❌ ERRO: Usuário não autenticado ou UID vazio!');
        throw Exception('Usuário não autenticado');
      }

      // Criar referência diretamente com o UID do usuário logado
      final userDoc = _db.collection('users').doc(currentUser.uid);
      final treinosCollection = userDoc.collection('treinos');
      final treinoDoc = treinosCollection.doc();

      print('🔵 ID do documento do treino: ${treinoDoc.id}');
      print('🔵 Path completo: ${treinoDoc.path}');

      final treino = TreinoSalvoModel(
        id: treinoDoc.id,
        nome: nome,
        exercicios: exercicios,
        dataCriacao: DateTime.now(),
      );

      print(
        '🔵 Salvando treino: ${treino.nome} com ${treino.exercicios.length} exercícios',
      );
      await treinoDoc.set(treino.toJson());
      print('✅ Treino salvo no Firebase para o usuário ${currentUser.email}');
      print('✅ ID do treino: ${treino.id}');
      return treino.id;
    } catch (e) {
      print('❌ Erro ao criar treino: $e');
      print('❌ Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  // READ - Listar todos os treinos do usuário
  Future<List<TreinoSalvoModel>> listarTreinos() async {
    try {
      await _auth.currentUser?.reload();
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        print('⚠️ Usuário não autenticado ao listar treinos');
        return [];
      }

      print('🔵 Listando treinos do usuário: ${currentUser.email}');
      print('🔵 Path: users/${currentUser.uid}/treinos');

      final snapshot = await _db
          .collection('users')
          .doc(currentUser.uid)
          .collection('treinos')
          .orderBy('dataCriacao', descending: true)
          .get();

      print('🔵 Encontrados ${snapshot.docs.length} treinos');

      return snapshot.docs
          .map(
            (doc) =>
                TreinoSalvoModel.fromJson(doc.data()),
          )
          .toList();
    } catch (e) {
      print('❌ Erro ao listar treinos: $e');
      return [];
    }
  }

  // READ - Obter treinos recentes (últimos 3)
  Future<List<TreinoSalvoModel>> listarTreinosRecentes({int limite = 3}) async {
    try {
      if (_treinosCollection == null) {
        return [];
      }

      final snapshot = await _treinosCollection!
          .orderBy('dataCriacao', descending: true)
          .limit(limite)
          .get();

      return snapshot.docs
          .map(
            (doc) =>
                TreinoSalvoModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('❌ Erro ao listar treinos recentes: $e');
      return [];
    }
  }

  // READ - Obter um treino específico
  Future<TreinoSalvoModel?> obterTreino(String treinoId) async {
    try {
      if (_treinosCollection == null) return null;

      final doc = await _treinosCollection!.doc(treinoId).get();
      if (!doc.exists) return null;

      return TreinoSalvoModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('❌ Erro ao obter treino: $e');
      return null;
    }
  }

  // UPDATE - Atualizar treino existente
  Future<bool> atualizarTreino(TreinoSalvoModel treino) async {
    try {
      if (_treinosCollection == null) return false;

      await _treinosCollection!.doc(treino.id).update(treino.toJson());
      print('✅ Treino atualizado: ${treino.id}');
      return true;
    } catch (e) {
      print('❌ Erro ao atualizar treino: $e');
      return false;
    }
  }

  // UPDATE - Atualizar última execução do treino
  Future<bool> registrarExecucao(String treinoId) async {
    try {
      if (_treinosCollection == null) return false;

      await _treinosCollection!.doc(treinoId).update({
        'ultimaExecucao': DateTime.now().toIso8601String(),
      });
      print('✅ Execução registrada para treino: $treinoId');
      return true;
    } catch (e) {
      print('❌ Erro ao registrar execução: $e');
      return false;
    }
  }

  // DELETE - Deletar treino
  Future<bool> deletarTreino(String treinoId) async {
    try {
      if (_treinosCollection == null) return false;

      await _treinosCollection!.doc(treinoId).delete();
      print('✅ Treino deletado: $treinoId');
      return true;
    } catch (e) {
      print('❌ Erro ao deletar treino: $e');
      return false;
    }
  }

  // Stream para ouvir mudanças em tempo real
  Stream<List<TreinoSalvoModel>>? treinosStream() {
    if (_treinosCollection == null) return null;

    return _treinosCollection!
        .orderBy('dataCriacao', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => TreinoSalvoModel.fromJson(
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  // Contar total de treinos
  Future<int> contarTreinos() async {
    try {
      if (_treinosCollection == null) return 0;

      final snapshot = await _treinosCollection!.get();
      return snapshot.docs.length;
    } catch (e) {
      print('❌ Erro ao contar treinos: $e');
      return 0;
    }
  }
}
