const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.useMultipleWildcards = functions.firestore
  .document('chat/{chatId}/messages/{message}')
  .onCreate((snapshot, context) => {
    console.log(snapshot);
    return admin.messaging().sendToTopic(snapshot.data().topic, {
      notification: {
        title: snapshot.data().userName,
        body: "Masz nową wiadomość",
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      },
      data: { "chatId": snapshot.data().topic, "respository": snapshot.data().respository, },
    });
  });