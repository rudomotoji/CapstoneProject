import { RepositoryFactory } from '../../repositories/RepositoryFactory'
// import router from '../../router'

const doctorRepository = RepositoryFactory.get('doctorRepository')

const state = () => ({
    listDoctor: []
})
const getters = {
}

const actions = {
    getListDoctor({ commit }) {
        doctorRepository.getListDoctor().then(response => {
            if (response.status === 200) {
                commit('success', response.data)
            } else {
                commit('failure')
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
