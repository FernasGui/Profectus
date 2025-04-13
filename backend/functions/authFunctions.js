const functions = require("firebase-functions");
const admin = require("firebase-admin");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.registerUser = functions.https.onCall(async (data) => {
  const { nome, email, password } = data;

  if (!nome || !email || !password) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Os campos de nome, e-mail e password são obrigatórios."
    );
  }

  try {
    const userRecord = await admin.auth().createUser({
      email,
      password,
      displayName: nome,
    });

    await admin.firestore().collection('users').doc(userRecord.uid).set({
      nome: nome,
      email: email,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { status: "success", userId: userRecord.uid };
  } catch (error) {
    console.error("Erro ao registar utilizador:", error);
    throw new functions.https.HttpsError("internal", "Erro ao criar utilizador.");
  }
});
