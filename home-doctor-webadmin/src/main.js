import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import './style/element-variables.scss'
import locale from 'element-ui/lib/locale/lang/en'
import firebase from '@firebase/app'
import '@firebase/messaging'

Vue.config.productionTip = false
Vue.use(ElementUI, { locale })

// Initialize Firebase
firebase.initializeApp({
  apiKey: "AIzaSyA-SqGlY2EQpCWI7QwpD7GfaT6mBu6gYqU",
  authDomain: "fir-app-chat-de0a2.firebaseapp.com",
  databaseURL: "https://fir-app-chat-de0a2.firebaseio.com",
  projectId: "fir-app-chat-de0a2",
  storageBucket: "fir-app-chat-de0a2.appspot.com",
  messagingSenderId: "581919845216",
  appId: "1:581919845216:web:889fcf1d152e8a29d38c05",
  measurementId: "G-7WGJJX029D"
});
navigator.serviceWorker.register('firebase-messaging-sw.js')
  .then((registration) => {
    // console.log("Registration successful, scope is:", registration.scope);
    const messaging = firebase.messaging();
    messaging.useServiceWorker(registration);

  }).catch(err => {
    console.log(err)
  })

new Vue({
  router,
  store,
  render: h => h(App),
}).$mount('#app')
