import { RepositoryFactory } from '../../repositories/RepositoryFactory'
import { setToken } from '../../utils/cookie'
import router from '../../router'

const userRepository = RepositoryFactory.get('userRepository')

const state = () => ({
  status: '',
  user: {
    userId: '', // Id của bác sĩ
    userName: '', // Tên đăng nhập vào hệ thống của bác sĩ
    fullName: '', // Họ tên của bác sĩ
    workLocation: '', // Nơi làm việc của bác sĩ
    phone: '', // Số điện thoại của bác sĩ
    email: '', // Email của bác sĩ
    dateOfBirth: '' // Ngày sinh của bác sĩ
  }
})
const getters = {
}
const actions = {
  // Nhận thông tin account (username, password) từ màn hình để đăng nhập
  login({ commit }, account) {
    userRepository.loginApp(account).then((response) => { // Truy cập repository
      if (response.status === 200) { // Thành công
        console.log(response.data)
        setToken(`${response.data.token}`) // Lưu lại token để sử dụng những chức năng khác
        const tmpUser = {
          userId: '1',
          userName: 'huynl',
          fullName: 'Nguyễn Lê Huy',
          workLocation: 'BV quận 9',
          phone: '987654321',
          email: 'huynl@gmail.com',
          dateOfBirth: '1998-02-17'
        }
        commit('loginSuccess', tmpUser) // Báo cho mutation thành công để render view
        router.push('/home') // Chuyển qua trang home
      } else {
        console.log('failed')
        commit('loginFailed') // Báo cho mutation thất bại để render view
      }
    }).catch((error) => {
      console.log(error)
    })
  }
}
const mutations = {
  // Nhận thông tin người dùng từ database và cập nhật vào store vuex
  loginSuccess(state, tmpUser) {
    state.status = 'logged'
    state.user.userId = tmpUser.userId
    state.user.userName = tmpUser.userName
    state.user.fullName = tmpUser.fullName
    state.user.workLocation = tmpUser.workLocation
    state.user.phone = tmpUser.phone
    state.user.email = tmpUser.email
    state.user.dateOfBirth = tmpUser.dateOfBirth
  },
  loginFailed(state) {
    state.status = 'unLogged'
    state.user = null
  }
}
export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
