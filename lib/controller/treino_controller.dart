import 'package:projeto_app/model/treino_model.dart';
import 'package:projeto_app/service/tipotreino_service.dart';


class TreinoController {
  final apiService = TipotreinoService();
  final firebaseService = TreinoFirebaseService();

  Future<void> importarParaFirebase() async {
    final lista = await apiService.listarTreinos();
    await firebaseService.salvarLista(lista);
  }

  Future<List<TreinoModel>> listarDaApi() async {
    return await apiService.listarTreinos();
  }
}
