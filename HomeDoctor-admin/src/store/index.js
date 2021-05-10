import Vue from 'vue'
import Vuex from 'vuex'
import user from './modules/user';
import doctor from './modules/doctor';
import patient from './modules/patient';
import contract from './modules/contract';
import time from './modules/time';
import licence from './modules/licence';

// eslint-disable-next-line quotes
import createPersistedState from 'vuex-persistedstate'
Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    user,
    doctor,
    patient,
    time,
    contract,
    licence
  },
  plugins: [createPersistedState()]
})
