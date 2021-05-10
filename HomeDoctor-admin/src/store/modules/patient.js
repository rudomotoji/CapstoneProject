import { RepositoryFactory } from '../../repositories/RepositoryFactory'

const patientRepository = RepositoryFactory.get('patientRepository')

const state = () => ({
  status: '',
  patients: []
})
const getters = {
}
const actions = {
  async getPatients({ commit, state }) {
    await patientRepository.getListPatients().then(response => {
      if (response.status === 200) {
        commit('success', response.data)
      } else {
        state.patients = []
      }
    });
  }
}
const mutations = {
  success(state, data) {
    state.patients = data
  },
}
export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
