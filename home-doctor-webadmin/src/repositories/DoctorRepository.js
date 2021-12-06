import request from '../utils/request.js'

export default {
    async getListDoctor() {
        return await request({
            url: `doctor`,
            method: 'get'
        })
    },
    async getDoctorDetail(doctorID) {
        return await request({
            url: `doctor/${doctorID}`,
            method: 'get'
        })
    },
}
