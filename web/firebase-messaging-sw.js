importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

firebase.initializeApp({
 apiKey: "AIzaSyDJbBtF5WT1Fx0u_nedPgyOgTdj1TWC31Y",
  authDomain: "notification-website-app.firebaseapp.com",
  projectId: "notification-website-app",
  storageBucket: "notification-website-app.appspot.com",
  messagingSenderId: "496326957683",
  appId: "1:496326957683:web:dc5d76ea2d0e31928de806",
  measurementId: "G-VQ05B53X13"
//    apiKey: "AIzaSyADQ_hksW--_1My_B3iPYnlVvkV_yOAzd4",
//    authDomain: "notification-app-web.firebaseapp.com",
//    projectId: "notification-app-web",
//    storageBucket: "notification-app-web.appspot.com",
//    messagingSenderId: "429587231376",
//    appId: "1:429587231376:web:dfeac28b1adbc59244de15",
//    measurementId: "G-PXXG8YFQGJ"
});
const messaging = firebase.messaging();

messaging.onBackgroundMessage((m) => {
    console.log("onBackgroundMessage", m);
});


//
// it sending 2 times same notification
//  messaging.onBackgroundMessage(function(payload) {
//    console.log('Received background message ', payload);
//
//    const notificationTitle = payload.notification.title;
//    const notificationOptions = {
//      body: payload.notification.body,
//    };
//
//    self.registration.showNotification(notificationTitle,
//      notificationOptions);
//  });
  //
