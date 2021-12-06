import { RepositoryFactory } from '../../repositories/RepositoryFactory'

const licenceRepository = RepositoryFactory.get('licenceRepository')

const state = () => ({
  status: '',
  licences: []
})
const getters = {
}
const actions = {
  async getLicences ({ commit, state }) {
    await licenceRepository.getLicences().then(response => {
      if (response.status === 200) {
        commit('success', response.data)
      } else {
        state.licences = []
      }
    })
  },
  async createLicense ({ dispatch }, data) {
    await licenceRepository.createNewLicense(data).then(response => {
      if (response.status === 201) {
        dispatch('getLicences')
      } else {
        dispatch('getLicences')
      }
    })
  }
}
const mutations = {
  success (state, data) {
    state.licences = data
  }
}
export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
