const admin = require('firebase-admin');
const XLSX = require('xlsx');
const { adicionarColaborador } = require('./listaColaboradores');

// Inicializar Admin SDK (só se ainda não estiver)
admin.initializeApp();

async function importarExcelParaFirestore() {
  try {
    // Lê o ficheiro Excel
    const workbook = XLSX.readFile('C:/Users/Utilizador/OneDrive/Documents/MBA/trabalho JM/colaboradoresjm.xlsx');
    const sheetName = workbook.SheetNames[0];
    const sheet = workbook.Sheets[sheetName];
    const colaboradores = XLSX.utils.sheet_to_json(sheet);

    console.log(`📋 Foram encontrados ${colaboradores.length} colaboradores no ficheiro.`);

    for (const colaborador of colaboradores) {
      await adicionarColaborador({
        uid: colaborador.uid, // Atenção: tens de ter coluna "uid" no Excel
        nome: colaborador.nome,
        area: colaborador.area,
        departamento: colaborador.departamento,
        cargo: colaborador.cargo,
        anoEntrada: colaborador.anoEntrada,
        chefeDireto: colaborador.chefeDireto,
      });
    }

    console.log('🚀 Todos os colaboradores foram importados com sucesso!');
  } catch (error) {
    console.error('❌ Erro ao importar Excel:', error);
  }
}

// Executa a função
importarExcelParaFirestore();
