import request from '../utils/request.js'

export default {
    async getLicences() {
        return await request({
            url: `Licenses`,
            method: 'get'
        })
    },
    async createNewLicense(data) {
        return await request({
            url: `Licenses`,
            method: 'post',
            data
        })
    }
}
