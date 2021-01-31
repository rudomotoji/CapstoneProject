import request from '../utils/request.js'

export default {
    async getList() {
        return await request({
            url: `Licenses?status=active`,
            method: 'get'
        })
    },
    async create(license) {
        return await request({
            url: `Licenses`,
            method: 'post',
            params: {
                "name": license.name,
                "price": license.price,
                "days": license.days,
                "description": license.description
            }
        })
    },
    async update(license) {
        return await request({
            url: `Licenses`,
            method: 'put',
            data: {
                "licenseId": license.licenseId,
                "name": license.name,
                "price": license.price,
                "days": license.days,
                "description": license.description,
                "status": license.status
            }
        })
    },
}
