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
      const numero = objetivo.Número || 0;
      const descricao = objetivo.Objetivos || '';
      const meta = objetivo.Meta || 0;
      const hora = objetivo.Hora;
      const dataCriacao = objetivo.DataCriacao;
      const dataLimite = objetivo.DataLimite;
      const progressoAtual = objetivo.ProgressoAtual || 0;
      const progressoRelativo = objetivo.ProgressoRelativo || 0;
      const diasRestantes = objetivo.DiasRestantes || 0;
      const diasPassados = objetivo.DiasPassados || 0;
      const previsao = objetivo['Previsão'] || '';
      const estadoAtual = objetivo.EstadoAtual || '';
      const esperado = objetivo['%Esperado(dias)'] || 0;
      const desvio = objetivo.DesviovsEsperado || 0;
      const pontoSituacao = objetivo.PontodeSituação || '';
      const resultado = objetivo.Resultado || '';

      const userRef = db.collection('users').doc(uid);
      const userSnap = await userRef.get();

      if (!userSnap.exists) {
        console.log(`❌ Utilizador com ID "${uid}" não encontrado. Objetivo ignorado.`);
        continue;
      }

      const dataHora = new Date(`${formatarData(dataLimite)}T${formatarHora(hora)}:00`);
      const objetivosRef = userRef.collection('objetivos');
      const snapshot = await objetivosRef.where('dataLimite', '==', admin.firestore.Timestamp.fromDate(dataHora)).get();

      if (!snapshot.empty) {
        console.log(`⚠️ Objetivo com data "${dataHora}" já existe para ${uid}. Ignorado.`);
        continue;
      }

      await objetivosRef.add({
        numero,
        descricao,
        meta,
        progresso: progressoAtual,
        progressoRelativo,
        diasRestantes,
        diasPassados,
        previsao,
        estadoAtual,
        esperado,
        desvio,
        pontoSituacao,
        resultado,
        criadoEm: admin.firestore.Timestamp.fromDate(new Date(dataCriacao)),
        dataLimite: admin.firestore.Timestamp.fromDate(dataHora),
      });

      console.log(`✅ Objetivo adicionado para colaborador ${uid}`);
    }

    console.log('🚀 Importação de objetivos concluída!');
  } catch (error) {
    console.error('❌ Erro ao importar objetivos:', error);
  }
}

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

importarObjetivos();
