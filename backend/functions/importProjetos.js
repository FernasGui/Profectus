const admin = require('firebase-admin');
const XLSX = require('xlsx');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function importarProjetosDoExcel() {
  try {
    const workbook = XLSX.readFile('C:/Users/Utilizador/OneDrive/Documents/MBA/trabalho JM/projetos_para_firebase.xlsx');
    const sheetName = workbook.SheetNames[0];
    const sheet = workbook.Sheets[sheetName];
    const projetos = XLSX.utils.sheet_to_json(sheet);

    console.log(`📁 ${projetos.length} projetos encontrados.`);

    for (const projeto of projetos) {
      const nome = projeto.nome || "Projeto sem nome";
      let equipa = [];

      // Corrigir string para array real
      try {
        equipa = JSON.parse(projeto.equipa.replace(/'/g, '"')); // converter aspas simples para duplas
      } catch (err) {
        console.warn(`⚠️ Erro a processar equipa para o projeto ${nome}:`, err);
      }

      await db.collection('projetos').add({
        nome,
        equipa,
      });

      console.log(`✅ Projeto "${nome}" importado com ${equipa.length} membros.`);
    }

    console.log("🚀 Todos os projetos foram importados com sucesso!");
  } catch (err) {
    console.error("❌ Erro ao importar projetos:", err);
  }
}

importarProjetosDoExcel();
