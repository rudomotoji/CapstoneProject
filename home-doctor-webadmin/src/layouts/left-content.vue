<template>
  <div>
    <h1>Danh mục</h1>
    <router-link to="/doctor">
      <div class="menuPatientFollowingView">
        <img src="../assets/patient.png" class="bitmapTwoImage" />
        Danh sách bác sĩ
      </div>
    </router-link>
    <router-link to="/license">
      <div class="menuPatientFollowingView">
        <img src="../assets/patient.png" class="bitmapTwoImage" />
        Danh sách gói hợp đồng
      </div>
    </router-link>
    <router-link to="/">
      <div class="menuPatientFollowingView">
        <img src="../assets/patient.png" class="bitmapTwoImage" />
        Danh sách yêu cầu
      </div>
    </router-link>
    <router-link to="/">
      <div class="menuPatientFollowingView">
        <img src="../assets/patient.png" class="bitmapTwoImage" />
        Danh sách triệu chứng
      </div>
    </router-link>
  </div>
</template>

<script>
export default {
  name: "left-content",
};
</script>

<style>
.bitmapImage {
  resize: center;
  background-color: transparent;
  width: 35px;
  height: 35px;
  margin-left: 45px;
  margin-top: 23px;
}
.menuPatientFollowingView {
  align-items: center;
  display: flex;
  margin: 10px;
}
</style>
