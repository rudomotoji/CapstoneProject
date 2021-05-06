<template>
  <header class="heading">
    <nav class="heading__nav-bar">
      <router-link to="/" class="router-items">
        <div class="heading__nav-bar_app-name">
          <h3>HOMEDOCTOR</h3>
        </div>
      </router-link>
      <router-link to="/" class="router-items">
        <div class="heading__nav-bar_logo">
          <img src="../../assets/icons/logo-home-doctor.png" />
        </div>
      </router-link>
      <div class="heading__nav-bar">
        <el-row class="heading__nav-bar_items horizontalCenter">
          <el-button @click="openDialog(true)">Chỉnh thời gian</el-button>
          <!-- <el-col>
            <el-popover
              placement="bottom"
              title="Tải khoản"
              width="200"
              trigger="click"
            >
              <img
                src="../../assets/icons/avatar-default.jpg"
                slot="reference"
                style="border-radius: 30px"
                class="icon-heading pointer"
              />
              <router-link to="/home/account-manage">
                <el-button>Cài đặt</el-button>
              </router-link>
              <el-button v-on:click="handleLogout()">Đăng xuất</el-button>
            </el-popover>
          </el-col> -->
        </el-row>
      </div>
    </nav>
  </header>
</template>
<script>
import { mapState, mapActions } from "vuex";
export default {
  name: "HeaderDefault",
  methods: {
    ...mapActions("users", ["handleLogout"]),
    ...mapActions("time", ["openDialog"]),
  },
};
</script>

<style style="scss" scoped>
.horizontalCenter {
  display: flex;
  width: 300px;
}
.heading__nav-bar {
  display: flex;
  justify-content: space-between;
  position: relative;
}
.heading__nav-bar_badge {
  width: 300px;
  height: auto;
  overflow: auto;
  background-color: whitesmoke;
  position: absolute;
  z-index: 3000;
  top: 30px;
  right: 200px;
  padding: 1em;
  font-size: 13px;
  max-height: 400px;
  box-shadow: 0px 0px 7px -2px rgba(0, 0, 0, 0.93);
  border-radius: 8px;
}
.heading__nav-bar_badge-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  padding: 1em;
}
.heading__nav-bar_logo {
  padding: 0.5em 1em;
  margin-left: 8%;
}
.heading__nav-bar_app-name {
  padding: 0.5em 1em;
}
.heading__nav-bar_app-name h3 {
  background: -webkit-linear-gradient(#64e8de, #8a64e8);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  margin-top: 10px;
}
.heading__nav-bar img {
  width: 30px;
  height: 30px;
}
.heading__nav-bar_items {
  display: inline-flex;
  padding: 0.5em 1em;
  margin-top: 3px;
}
.heading__nav-bar_items img {
}
.router-items {
  text-decoration: none;
  color: black;
}
.icon-heading {
  width: 25px;
  height: 25px;
}
.pointer {
  cursor: pointer;
}
.unseen-notification {
  background-color: #cecece;
}
.margin-03 {
  margin: 0.3em 0;
}
</style>
