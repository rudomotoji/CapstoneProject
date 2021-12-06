import { RepositoryFactory } from '../../repositories/RepositoryFactory'
// import router from '../../router'
const diseaseRepository = RepositoryFactory.get('diseaseRepository')

const state = () => ({
    listDiseases: [],
    detail: {},
})
const getters = {
}

const actions = {
    getListDisease({ commit }) {
        diseaseRepository.getList().then(response => {
            if (response.status === 200) {
                commit('getAllSuccess', response.data)
            } else {
                commit('failure')
            }
        });
    },
    createDisease({ commit, dispatch }, disease) {
        diseaseRepository.create(disease).then(response => {
            if (response.status === 201) {
                dispatch('getListDiseases')
            } else {
                commit('failure')
            }
        });
    },
    updateDisease({ commit, dispatch }, disease) {
        diseaseRepository.update(disease).then(response => {
            if (response.status === 200) {
                dispatch('getListDiseases')
            } else {
                commit('failure')
            }
        });
    },
}

const mutations = {
    getAllSuccess(state, data) {
        state.listDiseases = data
    },
}

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}
