import request from '../utils/request.js'

export default {
  async getDoctors () {
    return await request({
      url: 'Doctors/GetAllDoctor',
      method: 'get'
    })
  },
  async createNewDoctor (data) {
    return await request({
      url: '',
      method: 'post',
      data
    })
  },
  async login (data) {
    return await request({
      url: 'Accounts/Login',
      method: 'post',
      data
    })
  }
}
