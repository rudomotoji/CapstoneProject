import request from '../utils/request'

export default {
  async getTimeSystem() {
    return await request({
      method: 'get',
      url: 'Times'
    })
  },
  async setTimeSystem(time) {
    return await request({
      method: 'post',
      url: `Times?dateTime=${time}&onLinux=true`
    })
  }
}
