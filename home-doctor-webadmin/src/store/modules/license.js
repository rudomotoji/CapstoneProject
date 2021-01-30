import { RepositoryFactory } from '../../repositories/RepositoryFactory'
// import router from '../../router'

const licenseRepository = RepositoryFactory.get('licenseRepository')

const state = () => ({
    listLicense: [],
    detail: {},
})
const getters = {
}

const actions = {
    getListLicense({ commit }) {
        licenseRepository.getList().then(response => {
            if (response.status === 200) {
                commit('getAllSuccess', response.data)
            } else {
                commit('failure')
            }
        });
    },
    createLicense({ commit, dispatch }, license) {
        licenseRepository.create(license).then(response => {
            if (response.status === 201) {
                dispatch('getListLicense')
            } else {
                commit('failure')
            }
        });
    },
    updateLicense({ commit, dispatch }, license) {
        licenseRepository.update(license, license.id).then(response => {
            if (response.status === 200) {
                dispatch('getListLicense')
            } else {
                commit('failure')
            }
        });
    },
}

const mutations = {
    getAllSuccess(state, data) {
        state.listLicense = data
    },
}

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}
