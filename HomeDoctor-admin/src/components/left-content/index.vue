<template>
  <div class="wrapper leftContent">
    <div class="wrapper_intro">
      <p class="wrapper_intro-weekday"></p>
      <p class="wrapper_intro-date"></p>
      <p class="wrapper_intro-hello">Xin chào, Admin</p>
    </div>
    <div class="wrapper_shortcut">
      <h4 class="titleColor">Lối tắt</h4>
      <div class="wrapper_shortcut-items">
        <div class="router-items pointer">
          <router-link to="/" class="router-items pointer">
            <el-row
              :gutter="20"
              class="wrapper_shortcut-items_item"
              style="margin-left: -15px; margin-right: 5px; margin-top: 0.7em"
            >
              <el-col :span="4">
                <img src="../../assets/icons/ic-medical-instruction.png" />
              </el-col>
              <el-col :span="20">
                <el-row
                  ><span class="wrapper_shortcut-items_item-title"
                    >Bác sĩ</span
                  ></el-row
                >
                <el-row
                  ><span class="wrapper_shortcut-items_item-description"></span
                ></el-row>
              </el-col>
            </el-row>
          </router-link>
        </div>
        <div class="router-items pointer">
          <router-link to="/patient" class="router-items pointer">
            <el-row
              :gutter="20"
              class="wrapper_shortcut-items_item"
              style="margin-left: -15px; margin-right: 5px; margin-top: 0.7em"
            >
              <el-col :span="4">
                <img src="../../assets/icons/ic-patient-list.png" />
              </el-col>
              <el-col :span="20">
                <el-row
                  ><span class="wrapper_shortcut-items_item-title"
                    >Bệnh nhân</span
                  ></el-row
                >
                <el-row
                  ><span class="wrapper_shortcut-items_item-description"></span
                ></el-row>
              </el-col>
            </el-row>
          </router-link>
        </div>
        <div class="router-items pointer">
          <router-link to="/contract" class="router-items pointer">
            <el-row
              :gutter="20"
              class="wrapper_shortcut-items_item"
              style="margin-left: -15px; margin-right: 5px; margin-top: 0.7em"
            >
              <el-col :span="4">
                <img src="../../assets/icons/ic-contract.png" />
              </el-col>
              <el-col :span="20">
                <el-row
                  ><span class="wrapper_shortcut-items_item-title"
                    >Hợp đồng</span
                  ></el-row
                >
                <el-row
                  ><span class="wrapper_shortcut-items_item-description"></span
                ></el-row>
              </el-col>
            </el-row>
          </router-link>
        </div>
        <div class="router-items pointer">
          <router-link to="/licence" class="router-items pointer">
            <el-row
              :gutter="20"
              class="wrapper_shortcut-items_item"
              style="margin-left: -15px; margin-right: 5px; margin-top: 0.7em"
            >
              <el-col :span="4">
                <img src="../../assets/icons/ic-licence.png" />
              </el-col>
              <el-col :span="20">
                <el-row
                  ><span class="wrapper_shortcut-items_item-title"
                    >Gói hợp đồng</span
                  ></el-row
                >
                <el-row
                  ><span class="wrapper_shortcut-items_item-description"></span
                ></el-row>
              </el-col>
            </el-row>
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
</script>

<style lang="scss" scoped>
@import "../../style/index.scss";

.wrapper_intro {
  margin-bottom: 2em;
  .wrapper_intro-weekday {
    color: gray;
    font-weight: $font-semi-bold;
  }
  .wrapper_intro-date {
    font-size: 0.7em;
    color: gray;
    font-weight: $font-light;
  }
  .wrapper_intro-hello {
    margin: 1em 0;
    font-weight: $font-semi-bold;
  }
}
.wrapper_shortcut-items {
  margin-left: 2em;
  .wrapper_shortcut-items_item {
    background-image: linear-gradient(45deg, #f8f8fa, #eeeff3);
    border-radius: 15px;
    height: 60px;
    margin-right: 0;
    @include center() img {
      width: 2em;
    }
    .wrapper_shortcut-items_item-title {
      font-size: 0.8em;
    }
    .wrapper_shortcut-items_item-description {
      font-size: 0.4em;
      color: $color-button-sub-bg;
    }
  }
}
</style>
