importScripts("https://www.gstatic.com/firebasejs/8.2.10/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.2.10/firebase-analytics.js");

try {
    var firebaseConfig = {
        apiKey: "AIzaSyA-SqGlY2EQpCWI7QwpD7GfaT6mBu6gYqU",
        authDomain: "fir-app-chat-de0a2.firebaseapp.com",
        databaseURL: "https://fir-app-chat-de0a2.firebaseio.com",
        projectId: "fir-app-chat-de0a2",
        storageBucket: "fir-app-chat-de0a2.appspot.com",
        messagingSenderId: "581919845216",
        appId: "1:581919845216:web:889fcf1d152e8a29d38c05",
        measurementId: "G-7WGJJX029D"
    };
    firebase.initializeApp(firebaseConfig);
    firebase.analytics();

    const messaging = firebase.messaging();
    messaging.setBackgroundMessageHandler(function (payload) {
        console.log(' Received background message ', payload);
        var sender = JSON.parse(payload.data.message);
        var notificationTitle = 'CometChat Pro Notification';
        var notificationOptions = {
            body: payload.data.alert,
            icon: sender.data.entities.sender.entity.avatar,
        };
        return self.registration.showNotification(
            notificationTitle,
            notificationOptions
        );
    });
    self.addEventListener('notificationclick', function (event) {
        event.notification.close();
        //handle click event onClick on Web Push Notification
    });
} catch (ex) {
    console.log('exception: ', ex)
}