const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const { getFirestore } = require("firebase-admin/firestore");

admin.initializeApp();

const REGIAO = "southamerica-east1";
const NOME_BANCO = "default";

const db = getFirestore(NOME_BANCO);

// ─────────────────────────────────────────────
// FUNÇÃO 1: Notificação de nova avaliação
// ─────────────────────────────────────────────
exports.enviarNotificacaoAvaliacao = functions
  .region(REGIAO)
  .firestore.database(NOME_BANCO)
  .document("avaliacoes/{avaliacaoId}")
  .onCreate(async (snapshot) => {
    const { jogador_id: jogadorId, texto: textoComentario } = snapshot.data();

    try {
      const jogadorDoc = await db.collection("usuarios").doc(jogadorId).get();
      if (!jogadorDoc.exists) return null;

      const { fcm_token: token, preferencias_notificacao: preferencias = {} } =
        jogadorDoc.data();

      if (!token) return null;
      if (preferencias.atualizacoes === false) {
        console.log(`Usuário ${jogadorId} desativou notificações de avaliação.`);
        return null;
      }

      await admin.messaging().send({
        notification: {
          title: "Nova avaliação no seu perfil!",
          body:
            textoComentario.length > 80
              ? `${textoComentario.substring(0, 80)}...`
              : textoComentario,
        },
        token,
      });

      console.log(`Notificação de avaliação enviada para ${jogadorId}.`);
    } catch (error) {
      console.error("Erro ao processar notificação de avaliação:", error);
    }

    return null;
  });

// ─────────────────────────────────────────────
// FUNÇÃO 2: Notificação de nova mensagem no chat
// ─────────────────────────────────────────────
exports.enviarNotificacaoMensagem = functions
  .region(REGIAO)
  .firestore.database(NOME_BANCO)
  .document("chats/{chatId}/mensagens/{mensagemId}")
  .onCreate(async (snapshot, context) => {
    const { remetente_id: remetenteId, texto: textoMensagem } = snapshot.data();
    const { chatId } = context.params;

    try {
      const chatDoc = await db.collection("chats").doc(chatId).get();
      if (!chatDoc.exists) return null;

      const { participantes = [], usuario_dados: usuariosDados = {} } =
        chatDoc.data();

      const destinatarioId = participantes.find((id) => id !== remetenteId);
      if (!destinatarioId) return null;

      const destinatarioDoc = await db
        .collection("usuarios")
        .doc(destinatarioId)
        .get();
      if (!destinatarioDoc.exists) return null;

      const { fcm_token: token, preferencias_notificacao: preferenciasNotificacao } = destinatarioDoc.data();
      if (!token) return null;

      if (preferenciasNotificacao && preferenciasNotificacao.mensagens === false) {
        console.log(`Envio cancelado: O usuário ${destinatarioId} desativou as notificações de mensagens.`);
        return null; 
      }

      const nomeRemetente = usuariosDados[remetenteId]?.nome ?? "Alguém";

      await admin.messaging().send({
        notification: {
          title: `${nomeRemetente} te enviou uma mensagem`,
          body:
            textoMensagem.length > 80
              ? `${textoMensagem.substring(0, 80)}...`
              : textoMensagem,
        },
        token,
      });

      console.log(`Notificação de mensagem enviada para ${destinatarioId}.`);
    } catch (error) {
      console.error("Erro ao processar notificação de mensagem:", error);
    }

    return null;
  });