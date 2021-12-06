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
        let param = {
            "name": license.name,
            "days": parseInt(license.days),
            "description": license.description,
            "price": parseInt(license.price),
        };
        licenseRepository.create(param).then(response => {
            if (response.status === 201) {
                dispatch('getListLicense')
            } else {
                commit('failure')
            }
        });
    },
    updateLicense({ commit, dispatch }, license) {
        let param = {
            "licenseId": license.licenseId,
            "name": license.name,
            "days": parseInt(license.days),
            "description": license.description,
            "price": parseInt(license.price),
        };
        licenseRepository.update(param).then(response => {
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
