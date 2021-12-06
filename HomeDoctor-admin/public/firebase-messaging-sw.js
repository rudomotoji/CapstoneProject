
// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here. Other Firebase libraries
// are not available in the service worker.
// eslint-disable-next-line no-undef
importScripts('https://www.gstatic.com/firebasejs/8.2.10/firebase-app.js')
// eslint-disable-next-line no-undef
importScripts('https://www.gstatic.com/firebasejs/8.2.10/firebase-messaging.js')

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
// eslint-disable-next-line no-undef
firebase.default.initializeApp({
  apiKey: "AIzaSyBybbA9Kb5ltzi6EEBt1JWCRjhS-HIlmco",
  authDomain: "home-doctor-de846.firebaseapp.com",
  projectId: "home-doctor-de846",
  storageBucket: "home-doctor-de846.appspot.com",
  messagingSenderId: "974778918990",
  appId: "1:974778918990:web:31c5daf7ea8f37ceb1bb1f",
  measurementId: "G-TRGWRR7Z6H"
})

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
// eslint-disable-next-line no-undef
const messaging = firebase.messaging()
messaging.setBackgroundMessageHandler(function (payload) {
  console.log('payload firebase: ', payload)
  const title = 'message'
  const option = {
    body: 'This is test message'
  }
  return self.registration.showNotification(title, option)
})
