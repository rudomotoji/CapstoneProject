import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import './style/element-variables.scss'
import locale from 'element-ui/lib/locale/lang/vi'
// import { register } from 'register-service-worker'
// import { setTokenFirebase } from './utils/cookie'

// var firebaseConfig = {
//   apiKey: "AIzaSyBybbA9Kb5ltzi6EEBt1JWCRjhS-HIlmco",
//   authDomain: "home-doctor-de846.firebaseapp.com",
//   projectId: "home-doctor-de846",
//   storageBucket: "home-doctor-de846.appspot.com",
//   messagingSenderId: "974778918990",
//   appId: "1:974778918990:web:31c5daf7ea8f37ceb1bb1f",
//   measurementId: "G-TRGWRR7Z6H"
// };
// var firebase = require('firebase/app')
// require('firebase/messaging')
// firebase.default.initializeApp(firebaseConfig) // init firebase

// const messaging = firebase.default.messaging()
// messaging.requestPermission().then(function () {
//   console.log('Have permission')
//   return messaging.getToken()
// })
//   .then((token) => {
//     console.log('Token firebase:::', token)
//     setTokenFirebase(token)
//   })
//   .catch((err) => {
//     console.log('Have not permission', err)
//     if ('serviceWorker' in navigator) {
//       register('../public/firebase-messaging-sw.js', { scope: '../public_html/' })
//         .then(function (registration) {
//           console.log('Registration successful, scope is:', registration.scope)
//         }).catch(function (err) {
//           console.log('Service worker registration failed, error:', err)
//         })
//     }
//   })
// messaging.onMessage(payload => {
//   console.log('Message from firebase:::', payload)
//   store.dispatch('notifications/newMessage', payload, { root: true })
//   ElementUI.Message.info({ dangerouslyUseHTMLString: true, message: `<h4 style="color: black;">${payload.notification.title}</h4><div style="width: 100%; height: 1px; background-color: grey;"></div><p style="margin-top: .5em; color: black;">${payload.notification.body}</p>`, duration: 15000, showClose: true })
// })

Vue.config.productionTip = false
Vue.use(ElementUI, { locale })

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
