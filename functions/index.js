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
  .onCreate(async (snapshot, context) => {
    // Adicionado avaliador_id (assumindo que você salva quem avaliou no doc)
    const { jogador_id: jogadorId, avaliador_id: avaliadorId, texto: textoComentario } = snapshot.data();
    const { avaliacaoId } = context.params;

    try {
      const jogadorDoc = await db.collection("usuarios").doc(jogadorId).get();
      if (!jogadorDoc.exists) return null;

      const { fcm_token: token, preferencias_notificacao: preferencias = {} } =
        jogadorDoc.data();

      // Busca os dados de quem enviou a avaliação para salvar no documento
      let nomeAvaliador = "Alguém";
      let fotoAvaliador = null;
      if (avaliadorId) {
        const avaliadorDoc = await db.collection("usuarios").doc(avaliadorId).get();
        if (avaliadorDoc.exists) {
          nomeAvaliador = avaliadorDoc.data().nome ?? "Alguém";
          fotoAvaliador = avaliadorDoc.data().foto_url ?? null;
        }
      }

      // 1. Criação do Documento no Banco (In-App Notification)
      const notificacaoDoc = {
        usuario_id: jogadorId,
        tipo: "atualizacoes",
        conteudo: textoComentario,
        lida: false,
        remetente_id: avaliadorId ?? "",
        remetente_nome: nomeAvaliador,
        remetente_foto_url: fotoAvaliador,
        criado_em: new Date().toISOString(),
        referencia_id: avaliacaoId
      };
      await db.collection("notificacoes").add(notificacaoDoc);


      // 2. Envio do Push Notification (FCM)
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

      const nomeRemetente = usuariosDados[remetenteId]?.nome ?? "Alguém";
      const fotoRemetente = usuariosDados[remetenteId]?.foto_perfil ?? null;

      // 1. Criação do Documento no Banco (In-App Notification)
      const notificacaoDoc = {
        usuario_id: destinatarioId,
        tipo: "mensagens",
        conteudo: textoMensagem,
        lida: false,
        remetente_id: remetenteId,
        remetente_nome: nomeRemetente,
        remetente_foto_url: fotoRemetente,
        criado_em: new Date().toISOString(),
        referencia_id: chatId
      };
      await db.collection("notificacoes").add(notificacaoDoc);


      // 2. Envio do Push Notification (FCM)
      const { fcm_token: token, preferencias_notificacao: preferenciasNotificacao } = destinatarioDoc.data();
      if (!token) return null;

      if (preferenciasNotificacao && preferenciasNotificacao.mensagens === false) {
        console.log(`Envio cancelado: O usuário ${destinatarioId} desativou as notificações de mensagens.`);
        return null; 
      }

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