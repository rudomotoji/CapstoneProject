import { RepositoryFactory } from '../../repositories/RepositoryFactory'
// import moment from 'moment'

const timeRepository = RepositoryFactory.get('timeRepository')
const state = () => ({
  timeSystem: '',
  openDialogTime: false
})
const getters = {
}
const actions = {
  async getTimeSystem ({ commit }) {
    await timeRepository.getTimeSystem().then(response => {
      commit('setTimeNow', response.data)
    }).catch(err => { console.log(err) })
  },
  async setTimeSystem ({ commit }, data) {
    commit('setTimeNow', '')
    commit('setDialog', false)
    await timeRepository.setTimeSystem(data).then(() => {
      commit('setTimeNow', '')
    }).catch(err => { console.log(err) })
  },
  openDialog ({ commit, dispatch }, flag) {
    dispatch('getTimeSystem')
    commit('setDialog', flag)
  }
}
const mutations = {
  setTimeNow (state, time) {
    state.timeSystem = time
  },
  setDialog (state, flag) {
    state.openDialogTime = flag
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
