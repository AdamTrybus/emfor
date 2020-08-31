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
exports.usePayuNotification = functions.database.ref('/users/{userUid}/{documentId}')
  .onCreate((snapshot, context) => {
    const v = snapshot.val();
    var tit = "cos poszlo nie tak";
    if (v.order["status"] === "COMPLETED" || v.order["status"] === "CANCELED") {
      return admin.messaging().sendToTopic(v.order["description"], {
        notification: {
          title: v.order["status"] === "COMPLETED" ? "Płatność sfinalizowana" : "Płatność anulowana",
          body: v.order["orderCreateDate"],
          clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        },
        data: {"orderId": v.order["orderId"], "status": v.order["status"],},
      });
    }
  });
