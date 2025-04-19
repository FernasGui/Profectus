const admin = require('firebase-admin');
const XLSX = require('xlsx');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://profectus-c8a3f.firebaseio.com",
});

const db = admin.firestore();

async function importarNotificacoes() {
  try {
    const workbook = XLSX.readFile('C:/Users/Utilizador/OneDrive/Documents/MBA/trabalho JM/mensagens.xlsx');
    const sheet = workbook.Sheets[workbook.SheetNames[0]];
    const notificacoes = XLSX.utils.sheet_to_json(sheet);

    console.log(`📋 Foram encontradas ${notificacoes.length} notificações no ficheiro.`);

    for (const notificacao of notificacoes) {
      const uid = String(notificacao.uid); // ← atualizado para refletir a coluna correta do Excel
      const conteudo = notificacao.mensagem || '';
      const data = notificacao.data;
      const hora = notificacao.hora;
      const dataHoraFormatada = `${formatarData(data)} ${formatarHora(hora)}`;

      const userRef = db.collection('users').doc(uid);
      const userSnap = await userRef.get();

      if (!userSnap.exists) {
        console.log(`❌ Utilizador com UID "${uid}" não encontrado. Notificação ignorada.`);
        continue;
      }

      const notificacoesRef = userRef.collection('notificacoes');
      const duplicado = await notificacoesRef.where('dataHora', '==', dataHoraFormatada).limit(1).get();

      if (!duplicado.empty) {
        console.log(`⚠️ Notificação com dataHora "${dataHoraFormatada}" já existe para ${uid}. Ignorada.`);
        continue;
      }

      await notificacoesRef.add({
        mensagem: conteudo,
        data,
        hora,
        dataHora: dataHoraFormatada,
        criadoEm: admin.firestore.Timestamp.now(),
      });

      console.log(`✅ Notificação adicionada para utilizador ${uid}`);
    }

    console.log('🚀 Importação de notificações concluída!');
  } catch (error) {
    console.error('❌ Erro ao importar notificações:', error);
  }
}

// Funções auxiliares
function formatarData(excelDate) {
  if (typeof excelDate === 'string') return excelDate;
  const jsDate = new Date((excelDate - (25567 + 2)) * 86400 * 1000);
  return jsDate.toISOString().split('T')[0];
}

function formatarHora(excelHour) {
  if (typeof excelHour === 'string') return excelHour.padStart(5, '0');
  const totalMinutes = Math.round(24 * 60 * excelHour);
  const hours = Math.floor(totalMinutes / 60);
  const minutes = totalMinutes % 60;
  return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
}

importarNotificacoes();
