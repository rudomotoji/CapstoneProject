import request from '../utils/request.js'

export default {
    async getList() {
        return await request({
            url: `Diseases`,
            method: 'get'
        })
    },
    async create(diseases) {
        return await request({
            url: `Diseases`,
            method: 'post',
            data: {
                name: diseases.name,
                diseaseId: diseases.diseaseId
            }
        })
    },
    async update(diseases) {
        return await request({
            url: `Diseases/${diseases.id}`,
            method: 'put',
            data: {
                name: diseases.name,
                diseaseId: diseases.diseaseId
            }
        })
    },
}
