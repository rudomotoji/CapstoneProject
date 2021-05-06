import { RepositoryFactory } from '../../repositories/RepositoryFactory'

const doctorRepository = RepositoryFactory.get('doctorRepository')

const state = () => ({
    listDoctor: []
})
const getters = {
}

const actions = {
    async getListDoctor({ commit, state }) {
        await doctorRepository.getDoctors().then(response => {
            if (response.status === 200) {
                commit('success', response.data)
            } else {
                state.listDoctor = []
            }
        });
    },
    async createDoctor({ dispatch }, data) {
        await doctorRepository.createNewDoctor(data).then(response => {
            if (response.status === 201) {
                dispatch('getListDoctor')
            } else {
                dispatch('getListDoctor')
            }
        });
    }
}

const mutations = {
    success(state, data) {
        state.listDoctor = data
    },
}

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}
