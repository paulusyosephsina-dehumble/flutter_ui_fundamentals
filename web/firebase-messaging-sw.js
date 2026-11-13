importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyDfaKx6FvmprWIQT0KqV9vHMOT-36zEE38",
  authDomain: "kosfinder-app.firebaseapp.com",
  projectId: "kosfinder-app",
  storageBucket: "kosfinder-app.firebasestorage.app",
  messagingSenderId: "365104189891",
  appId: "1:365104189891:web:4be85294cbd0d70a80ad76"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Background message: ', payload);
  const notificationTitle = payload.notification?.title || 'KosFinder';
  const notificationOptions = {
    body: payload.notification?.body || 'Notifikasi baru',
    icon: '/favicon.png'
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});
