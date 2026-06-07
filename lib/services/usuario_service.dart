import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goalink/models/filtros_pesquisa.dart';
import 'package:goalink/models/usuario_model.dart';

class UsuarioService {
  late final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'default',
  );

  Future<UsuarioModel?> obterUsuarioUid(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('usuarios')
          .doc(uid)
          .get();
      if (snapshot.exists && snapshot.data() != null) {
        return UsuarioModel.fromJson(snapshot.data()!);
      }

      return null;
    } catch (e) {
      throw Exception('Erro ao buscar usuário: $e');
    }
  }

  Future<void> cadastrarUsuarioNoBanco(UsuarioModel usuario) async {
    try {
      await _firestore
          .collection('usuarios')
          .doc(usuario.id)
          .set(usuario.toJson());
    } catch (e) {
      throw Exception('Erro ao criar usuário: $e');
    }
  }

  Future<void> atualizarUsuario(UsuarioModel usuario) async {
    try {
      await _firestore
          .collection('usuarios')
          .doc(usuario.id)
          .update(usuario.toJson());
    } catch (e) {
      throw Exception('Erro ao atualizar usuário: $e');
    }
  }

  Future<void> deletarUsuario(String uid) async {
    try {
      await _firestore.collection('usuarios').doc(uid).delete();
    } catch (e) {
      throw Exception('Erro ao deletar usuário: $e');
    }
  }

  Future<List<UsuarioModel>> obterJogadoresNovos() async {
    final trintaDiasAtras = DateTime.now()
        .subtract(const Duration(days: 30))
        .toIso8601String();
    try {
      final querySnapshot = await _firestore
          .collection('usuarios')
          .where('criado_em', isGreaterThan: trintaDiasAtras)
          .where('tipo', isEqualTo: 'jogador')
          .get();
      if (querySnapshot.docs.isEmpty) {
        return [];
      }
      return querySnapshot.docs
          .map((doc) => UsuarioModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Erro ao obter jogadores novos: $e');
    }
  }

  Future<List<DocumentSnapshot>> pesquisarUsuarios({
    String? termoNome,
    FiltrosPesquisa? filtros,
  }) async {
    try {
      Query query = _firestore.collection("usuarios");

      // Igualdade
      if (filtros != null) {
        if (filtros.tipo != null && filtros.tipo!.isNotEmpty) {
          query = query.where('tipo', isEqualTo: filtros.tipo);
        }
        if (filtros.cidade != null && filtros.cidade!.isNotEmpty) {
          query = query.where('cidade', isEqualTo: filtros.cidade);
        }
        if (filtros.posicao != null && filtros.posicao!.isNotEmpty) {
          query = query.where('posicao', isEqualTo: filtros.posicao);
        }
        if (filtros.pernaPreferida != null &&
            filtros.pernaPreferida!.isNotEmpty) {
          query = query.where(
            'perna_preferida',
            isEqualTo: filtros.pernaPreferida,
          );
        }
      }

      // Peso
      if (filtros?.pesoMinimo != null) {
        query = query.where(
          'peso',
          isGreaterThanOrEqualTo: filtros!.pesoMinimo,
        );
      }
      if (filtros?.pesoMaximo != null) {
        query = query.where('peso', isLessThanOrEqualTo: filtros!.pesoMaximo);
      }

      // Altura
      if (filtros?.alturaMinima != null) {
        query = query.where(
          'altura',
          isGreaterThanOrEqualTo: filtros!.alturaMinima,
        );
      }
      if (filtros?.alturaMaxima != null) {
        query = query.where(
          'altura',
          isLessThanOrEqualTo: filtros!.alturaMaxima,
        );
      }

      if (termoNome != null && termoNome.isNotEmpty) {
        final termo = termoNome.trim();
        query = query
            .where('nome', isGreaterThanOrEqualTo: termo)
            .where('nome', isLessThanOrEqualTo: '$termo\uf8ff');
      }

      QuerySnapshot snapshot = await query.limit(30).get();

      return snapshot.docs;
    } catch (e) {
      throw Exception('Erro ao pesquisar usuários: $e');
    }
  }
}
