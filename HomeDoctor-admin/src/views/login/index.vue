<template>
<div class="wrapper">
    <div class="wrapper-opacity"/>
    <div class="container">
      <h1 class="container__logo-word">Home Doctor</h1>
    <div class="container__login-form">
      <el-form v:model="loginForm" ref="loginForm" class="container__login-form_form">
        <h2>Đăng nhập</h2>
        <el-form-item label="Tên đăng nhập">
          <el-input v-model="loginForm.userName" type="text" class="container__login-form_input"></el-input>
        </el-form-item>
        <el-form-item label="Mật khẩu">
          <el-input v-model="loginForm.password" type="password"  class="container__login-form_input"></el-input>
        </el-form-item>
        <el-link type="primary" style="margin-bottom: 1em;">Quên mật khẩu?</el-link>
        <el-form-item>
          <el-button class="container__login-form_login-button" type="primary" @click="login(loginForm)">Đăng nhập</el-button>
        </el-form-item>
        <p v-if="status === 'unLogged'" style="color: red;">Tài khoản hoặc mật khẩu không hợp lệ!</p>
      </el-form>
   </div>
</div>

</div>
</template>

<script>
import { mapActions, mapState } from 'vuex'
export default {
  name: 'Login',
  computed: {
    ...mapState('users', ['status'])
  },
  data () {
    return {
      // Form dùng để đăng nhập
      loginForm: {
        userName: '', // Tên tài khoản dùng để đăng nhập
        password: '' // Mật khẩu dùng để đăng nhập
      }
    }
  },
  methods: {
    ...mapActions('users', ['login'])
  }
}
</script>
<style lang="scss" scoped>
@import '../../style/index.scss';
.wrapper {
  background-image: linear-gradient(to right, #64E8DE, #8A64E8);
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  position: fixed;
  .wrapper-opacity {
    height: 60.3125em;
    background-color: #575E6E;
    opacity: 60%;
  }
  .container {
    .container__logo-word {
      position: absolute;
      top: 20px;
      left: 30px;
      font-size: 40px;
      background: -webkit-linear-gradient(#F8F8F9, #AFB0B3);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      @include fontWeight($font-bold)
    }
    .container__login-form {
      @include verticalCenterRight(3.75em)
      display: flex;
      align-items: center;
      height: 31.25em;
      width: 31.25em;
      background: #FFFFFF;
      box-shadow: 2px 2px 25px 0 rgba(0,0,0,0.50);
      @include borderRadius(15px)
      .container__login-form_form {
        margin: 2em;
        h2 {
          margin-bottom: 1em;
        }
      }
      .container__login-form_input {
        width: 31.5em;
      }
      .container__login-form_login-button {
        width: 31.5em;
      }
    }
}
}

</style>
