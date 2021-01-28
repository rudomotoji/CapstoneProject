import Vue from 'vue'
import Vuex from 'vuex'
import users from './modules/users'
import doctor from './modules/doctor'
import license from './modules/license'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    users,
    doctor,
    license
  }
})
