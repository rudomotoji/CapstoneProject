import { RepositoryFactory } from '../../repositories/RepositoryFactory'
// import router from '../../router'

const symptomRepository = RepositoryFactory.get('symptomRepository')

const state = () => ({
    listsymptom: [],
    detail: {},
})
const getters = {
}

const actions = {
    getListSymptom({ commit }) {
        symptomRepository.getList().then(response => {
            if (response.status === 200) {
                commit('getAllSuccess', response.data)
            } else {
                commit('failure')
            }
        });
    },
    createsymptom({ commit, dispatch }, symptom) {
        symptomRepository.create(symptom).then(response => {
            if (response.status === 201) {
                dispatch('getListSymptom')
            } else {
                commit('failure')
            }
        });
    },
    updatesymptom({ commit, dispatch }, symptom) {
        symptomRepository.update(symptom).then(response => {
            if (response.status === 200) {
                dispatch('getListSymptom')
            } else {
                commit('failure')
            }
        });
    },
}

const mutations = {
    getAllSuccess(state, data) {
        state.listsymptom = data
    },
}

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}
