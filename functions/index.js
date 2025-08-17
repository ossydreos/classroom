const {setGlobalOptions} = require("firebase-functions/v2");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getMessaging} = require("firebase-admin/messaging");

setGlobalOptions({region: "europe-west3"});

initializeApp();

exports.myFunction = onDocumentCreated(
    "rooms/{roomId}/chat/{message}",
    async (event) => {
      const snap = event.data;
      if (!snap) return null;

      const data = snap.data() || {};
      const roomId = event.params.roomId;
      const title = `${data.username || "Nouveau message"} (${roomId})`;
      const body = data.text || "";

      console.log("Trigger OK:", {title, body});

      const messageId = await getMessaging().send({
        topic: "chat",
        notification: {title, body},
        android: {notification: {clickAction: "FLUTTER_NOTIFICATION_CLICK"}},
      });

      console.log("FCM sent:", messageId);
      return null;
    },
);
