import request from '../utils/request.js'

export default {
    async getList() {
        return await request({
            url: `license`,
            method: 'get'
        })
    },
    async create(license) {
        return await request({
            url: `license`,
            method: 'post',
            data: {
                "name": license.name,
                "price": license.price,
                "type": license.type,
                "description": license.description
            }
        })
    },
    async update(license, licenseID) {
        return await request({
            url: `license/${licenseID}`,
            method: 'put',
            data: {
                "name": license.name,
                "price": license.price,
                "type": license.type,
                "description": license.description
            }
        })
    },
}
