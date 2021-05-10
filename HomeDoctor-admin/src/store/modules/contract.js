import { RepositoryFactory } from '../../repositories/RepositoryFactory'

const contractRepository = RepositoryFactory.get('contractRepository')

const state = () => ({
    listContracts: []
})
const getters = {
}

const actions = {
    async getListContracts({ commit, state }) {
        await contractRepository.getContracts().then(response => {
            if (response.status === 200) {
                commit('success', response.data)
            } else {
                commit('fail')
            }
        }).catch(() => {
            commit('fail')
        });
    },
    async activeContract({ dispatch }, data) {
        await contractRepository.activeContract(data.id, data.status).then(response => {
            if (response.status === 204) {
                dispatch('getListContracts');
            }
        });
    }
}

const mutations = {
    success(state, data) {
        state.listContracts = data
    },
    fail(state) {
        state.listContracts = []
    },
}

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}
