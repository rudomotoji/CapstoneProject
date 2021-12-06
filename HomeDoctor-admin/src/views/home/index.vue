<template>
  <div class="wrapper">
    <base-layout>
      <template v-slot:left-content>
        <left-content />
      </template>
      <template v-slot:main-content>
        <router-view></router-view>
      </template>
    </base-layout>

    <el-dialog
      title="Chỉnh thời gian hệ thống"
      :visible.sync="openDialogTime"
      width="50%"
      :before-close="closeDialog"
    >
      <el-row class="verticalCenter" style="margin-bottom: 0.5em">
        <el-col :span="6">Ngày:</el-col>
        <el-col :span="18">
          <el-date-picker
            type="datetime"
            v-model="dateSelect"
            placeholder="Ngày hệ thống"
          ></el-date-picker>
        </el-col>
      </el-row>
      <el-button @click="openDialog(false)">Đóng</el-button>
      <el-button @click="setDateOfSystem">Cập nhật</el-button>
    </el-dialog>
  </div>
</template>

<script>
import BaseLayout from '../../layouts/BaseLayout.vue'
import LeftContent from '../../components/left-content'
import { mapState, mapActions } from 'vuex'
import moment from 'moment'
export default {
  data () {
    return {
      dateSelect: ''
    }
  },
  methods: {
    ...mapActions('time', ['setTimeSystem', 'getTimeSystem', 'openDialog']),
    closeDialog () {
      this.openDialog(false)
    },
    setDateOfSystem () {
      var date = new Date(this.dateSelect)
      this.setTimeSystem(moment(date).format('YYYY-MM-DDTHH:mm:ss'))
    }
  },
  computed: {
    ...mapState('time', ['openDialogTime', 'timeSystem'])
  },
  components: {
    'base-layout': BaseLayout,
    'left-content': LeftContent
  }
}
</script>

<style lang="scss" scoped>
@import "../../style/index.scss";
.form {
  .form__item {
    margin-bottom: 10px;
    .form__item_use-time {
      margin-bottom: 0.5em;
    }
    .form__item_content-opt {
      margin-left: 0.5em;
    }
  }
}

.margin-all {
  margin-bottom: 2em;
  margin: 1em;
}
</style>
