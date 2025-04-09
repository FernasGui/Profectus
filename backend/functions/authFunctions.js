const functions = require("firebase-functions");
const admin = require("firebase-admin");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

// Função para registar novo utilizador
exports.registerUser = functions.https.onCall(async (data) => {
  const { nome, email, password } = data;

  // Validação dos dados de entrada
  if (!nome || !email || !password) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Os campos de nome, e-mail e password são obrigatórios."
    );
  }

  try {
    // Cria o utilizador no Firebase Authentication
    const userRecord = await admin.auth().createUser({
      email,
      password,
      displayName: nome, // Atribui o nome ao utilizador
    });

    return { status: "success", userId: userRecord.uid };
  } catch (error) {
    console.error("Erro ao registar utilizador:", error);

    if (error.code && error.code.startsWith("auth/")) {
      throw new functions.https.HttpsError("aborted", error.message);
    } else {
      throw new functions.https.HttpsError(
        "internal",
        "Erro ao criar utilizador. Por favor, tente novamente mais tarde."
      );
    }
  }
});
