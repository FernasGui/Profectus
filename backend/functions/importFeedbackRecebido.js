const admin = require('firebase-admin');
const XLSX = require('xlsx');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://profectus-c8a3f.firebaseio.com",
});

const db = admin.firestore();

async function importarFeedbackRecebido() {
  try {
    const workbook = XLSX.readFile('C:/Users/Utilizador/OneDrive/Documents/MBA/trabalho JM/feedbackrecebido.xlsx');
    const sheet = workbook.Sheets[workbook.SheetNames[0]];
    const feedbacks = XLSX.utils.sheet_to_json(sheet);

    console.log(`📋 Foram encontrados ${feedbacks.length} registos de feedback no ficheiro.`);

    for (const feedback of feedbacks) {
      const id = String(feedback.id);
      const uid = String(feedback.uid);
      const mensagem = feedback.mensagem || '';
      const data = feedback.data;
      const hora = feedback.hora;

      const dataHoraFormatada = `${formatarData(data)} ${formatarHora(hora)}`;

      // Verifica se o utilizador de destino existe
      const userRef = db.collection('users').doc(id);
      const userSnap = await userRef.get();

      if (!userSnap.exists) {
        console.log(`❌ Utilizador com ID "${id}" não encontrado. Feedback ignorado.`);
        continue;
      }

      const feedbackRef = userRef.collection('feedbackrecebido');
      const duplicado = await feedbackRef.where('dataHora', '==', dataHoraFormatada).limit(1).get();

      if (!duplicado.empty) {
        console.log(`⚠️ Feedback com dataHora "${dataHoraFormatada}" já existe para ${id}. Ignorado.`);
        continue;
      }

      await feedbackRef.add({
        uid,
        mensagem,
        data,
        hora,
        dataHora: dataHoraFormatada,
        criadoEm: admin.firestore.Timestamp.now(),
      });

      console.log(`✅ Feedback adicionado para utilizador ${id}`);
    }

    console.log('🚀 Importação de feedback concluída!');
  } catch (error) {
    console.error('❌ Erro ao importar feedback:', error);
  }
}

// Funções auxiliares
function formatarData(excelDate) {
  if (typeof excelDate === 'string') return excelDate; // já vem formatada
  const jsDate = new Date((excelDate - (25567 + 2)) * 86400 * 1000);
  return jsDate.toISOString().split('T')[0]; // YYYY-MM-DD
}

function formatarHora(excelHour) {
  if (typeof excelHour === 'string') return excelHour.padStart(5, '0');
  const totalMinutes = Math.round(24 * 60 * excelHour);
  const hours = Math.floor(totalMinutes / 60);
  const minutes = totalMinutes % 60;
  return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
}

importarFeedbackRecebido();
