const admin = require('firebase-admin');
const XLSX = require('xlsx');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://profectus-c8a3f.firebaseio.com",
});

const db = admin.firestore();

async function importarObjetivos() {
  try {
    const workbook = XLSX.readFile('C:/Users/Utilizador/OneDrive/Documents/MBA/trabalho JM/Objetivos1.xlsx');
    const sheet = workbook.Sheets[workbook.SheetNames[0]];
    const objetivos = XLSX.utils.sheet_to_json(sheet);

    console.log(`📋 Foram encontrados ${objetivos.length} objetivos no ficheiro.`);

    for (const objetivo of objetivos) {
      const uid = String(objetivo.Id_colaborador);
      const descricao = objetivo.Objetivos || '';
      const pontos = objetivo.Pontos || 0;
      const prazo = objetivo.Prazo || '';
      const data = objetivo.Data;
      const hora = objetivo.Hora;

      // Verifica se o colaborador existe
      const userRef = admin.firestore().collection('users').doc(uid);
      const userSnap = await userRef.get();

      if (!userSnap.exists) {
        console.log(`❌ Utilizador com ID "${uid}" não encontrado. Objetivo ignorado.`);
        continue;
      }

      // Combinar data e hora corretamente
      const dataObj = new Date(`${formatarData(data)}T${formatarHora(hora)}:00`);

      const objetivosRef = userRef.collection('objetivos');
      const snapshot = await objetivosRef.where('dataLimite', '==', dataObj).get();

      if (!snapshot.empty) {
        console.log(`⚠️ Objetivo com dataLimite "${dataObj}" já existe para ${uid}. Ignorado.`);
        continue;
      }

      await objetivosRef.add({
        descricao,
        pontos,
        prazo,
        progresso: 0,
        criadoEm: admin.firestore.Timestamp.now(),
        dataLimite: admin.firestore.Timestamp.fromDate(dataObj),
      });

      console.log(`✅ Objetivo adicionado para colaborador ${uid}`);
    }

    console.log('🚀 Importação de objetivos concluída!');
  } catch (error) {
    console.error('❌ Erro ao importar objetivos:', error);
  }
}

// Funções auxiliares
function formatarData(excelDate) {
  if (typeof excelDate === 'string') return excelDate; // já vem formatada
  const jsDate = new Date((excelDate - (25567 + 2)) * 86400 * 1000);
  return jsDate.toISOString().split('T')[0]; // YYYY-MM-DD
}

function formatarHora(excelHour) {
  if (typeof excelHour === 'string') return excelHour.padStart(5, '0'); // já vem como HH:mm
  const totalMinutes = Math.round(24 * 60 * excelHour); // hora decimal
  const hours = Math.floor(totalMinutes / 60);
  const minutes = totalMinutes % 60;
  return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
}


importarObjetivos();
