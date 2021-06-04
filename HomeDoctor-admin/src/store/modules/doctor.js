import { RepositoryFactory } from '../../repositories/RepositoryFactory'
import { getToken, setToken } from '../../utils/cookie'

const doctorRepository = RepositoryFactory.get('doctorRepository')

const state = () => ({
  listDoctor: []
})
const getters = {
}

const actions = {
  async getListDoctor ({ commit, state }) {
    await doctorRepository.getDoctors().then(response => {
      if (response.status === 200) {
        commit('success', response.data)
      } else {
        state.listDoctor = []
      }
    })
  },
  async createDoctor ({ dispatch }, data) {
    await doctorRepository.createNewDoctor(data).then(response => {
      if (response.status === 201) {
        dispatch('getListDoctor')
      } else {
        dispatch('getListDoctor')
      }
    })
  },
  async login ({ dispatch }) {
    const data = {
      username: 'admin',
      password: 'admin'
    }

    if (!getToken()) {
      await doctorRepository.login(data).then(response => {
        setToken(response.data.token)
      })
    }
    dispatch('getListDoctor')
  }
}

const mutations = {
  success (state, data) {
    state.listDoctor = data
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
