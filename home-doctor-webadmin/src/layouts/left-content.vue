<template>
  <!-- <div>
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
    <router-link to="/symptom">
      <div class="menuPatientFollowingView">
        <img src="../assets/patient.png" class="bitmapTwoImage" />
        Danh sách triệu chứng
      </div>
    </router-link>
  </div> -->
  <div class="container">
    <div class="control">Menu bar</div>
    <div class="navigation-links">
      <router-link to="/doctor" style="text-decoration: none">
        <div key="1">
          <img src="../assets/patient.png" class="bitmapTwoImage" />
          Danh sách bác sĩ
        </div>
      </router-link>
      <router-link to="/license" style="text-decoration: none">
        <div key="2">
          <img src="../assets/patient.png" class="bitmapTwoImage" /> Danh sách
          gói hợp đồng
        </div>
      </router-link>
      <router-link to="/" style="text-decoration: none">
        <div key="3">
          <img src="../assets/patient.png" class="bitmapTwoImage" /> Danh sách
          yêu cầu
        </div>
      </router-link>
      <router-link to="/symptom" style="text-decoration: none">
        <div key="4">
          <img src="../assets/patient.png" class="bitmapTwoImage" /> Danh sách
          triệu chứng
        </div>
      </router-link>
    </div>
  </div>
</template>

<script>
export default {
  name: "left-content",
};
</script>

<style lang="scss" scoped>
.container {
  position: fixed;
  top: 0;
  left: 0;
  width: 200px;
  padding: 10px;
  min-height: calc(100vh - 20px);
  background-color: white;
  border: solid #fff;
  border-width: 0 1px 0 0;
  z-index: 999;
  transition: all 0.5s ease-in-out;
  .control {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100px;
    margin-bottom: 10px;
    i {
      font-size: 2rem;
      cursor: pointer;
      transition: all 0.5s ease-in-out;
    }
  }
  .navigation-links {
    padding-top: 14px;
    float: left;
    div {
      font-size: 0.8rem;
      padding-left: 10px;
      margin-bottom: 18px;
      cursor: pointer;
      &:hover {
        color: red;
      }
      img {
        resize: center;
        background-color: transparent;
        width: 20px;
        height: 20px;
      }
    }
  }
}
</style>
