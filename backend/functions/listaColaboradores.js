const admin = require('firebase-admin');

async function adicionarColaborador({
  uid,
  nome,
  area,
  departamento,
  cargo,
  anoEntrada,
  chefeDireto,
}) {
  try {
    await admin.firestore()
      .collection('users')
      .doc(uid)
      .set({
        nome: nome,
        area: area,
        departamento: departamento,
        cargo: cargo,
        anoEntrada: anoEntrada,
        chefeDireto: chefeDireto,
      }, { merge: true });

    console.log('✅ Colaborador adicionado ou atualizado com sucesso!');
  } catch (error) {
    console.error('❌ Erro ao adicionar colaborador:', error);
  }
}

module.exports = { adicionarColaborador };
