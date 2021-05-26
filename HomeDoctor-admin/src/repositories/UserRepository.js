/* eslint-disable key-spacing */
/* eslint-disable quotes */
/* eslint-disable quote-props */
import request from '../utils/request.js'
// Tương tác với database
export default {
  // Đăng nhập vào hệ thống.
  async loginApp (account) {
    return await request({
      method: 'POST',
      url: '/Accounts/Login/',
      data: {
        // eslint-disable-next-line quote-props
        // eslint-disable-next-line quotes
        "username": `${account.userName}`,
        // eslint-disable-next-line quote-props
        "password": `${account.password}`
      }
    })
  }
}
