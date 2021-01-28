import request from '../utils/request.js'

export default {
    async getList() {
        return await request({
            url: `symptom`,
            method: 'get'
        })
    },
    async create(symptom) {
        return await request({
            url: `symptom`,
            method: 'post',
            data: {
                name: symptom.name,
                code: symptom.code
            }
        })
    },
    async update(symptom) {
        return await request({
            url: `symptom/${symptom.id}`,
            method: 'put',
            data: {
                name: symptom.name,
                code: symptom.code
            }
        })
    },
}
