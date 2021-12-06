<template>
  <div class="mainContent">
    <el-breadcrumb separator="/" style="font-size: 10px">
      <el-breadcrumb-item :to="{ path: '/' }">Trang chủ</el-breadcrumb-item>
    </el-breadcrumb>
    <br />
    <div class="card-wrapper bg-theme">
      <el-row class="card-wrapper__header">
        <el-col :span="21">
          <el-row class="verticalCenter">
            <el-col :span="1">
              <img
                class="iconDialog"
                src="../../../assets/icons/ic-patient-list.png"
              />
            </el-col>
            <el-col :span="23">
              <div class="next-event__header_title titleColor">
                <strong>Danh sách bệnh nhân</strong>
                <p v-if="patients.length > 0">
                  Hiện tại đang có {{ patients.length }} bệnh nhân đã tham gia
                  vào hệ thống
                </p>
                <p v-else>Hiện chưa có bệnh nhân nào đăng ký vào hệ thống</p>
              </div>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-table :data="patients">
        <el-table-column type="expand">
          <template slot-scope="props">
            <p>Giới tính: {{ props.row.gender }}</p>
            <p>Chiều cao: {{ props.row.height }}</p>
            <p>Cân nặng: {{ props.row.weight }}</p>
            <p>Ngày sinh: {{ formatDateTime(props.row.dateOfBirth) }}</p>
            <!-- <p>Người nhà: {{ props.row.zip }}</p> -->
          </template>
        </el-table-column>
        <el-table-column prop="fullName" label="Tên"> </el-table-column>
        <el-table-column prop="phoneNumber" label="SĐT"> </el-table-column>
        <el-table-column prop="email" label="Email"> </el-table-column>
        <el-table-column prop="address" label="Địa chỉ"> </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'
import moment from 'moment'
export default {
  data () {
    return {}
  },
  computed: {
    ...mapState('patient', ['patients'])
  },
  mounted () {
    this.getPatients()
  },
  methods: {
    ...mapActions('patient', ['getPatients']),
    formatDateTime (dateStr) {
      return moment(dateStr).format('DD/MM/YYYY')
    }
  }
}
</script>

<style lang="scss">
@import "../../../style/index.scss";
.card-wrapper {
  font-size: 13px;
}
.patient-health-wrapper {
  .patient-health-wrapper_card {
    margin: 0.5em 1em;
    .patient-health-wrapper_card_header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 1em;
      border-radius: 8px;
      .display-status {
        display: inherit;
        .display-status_item {
          margin: 0 0.3em;
        }
      }
    }
    .patient-health-wrapper_card_item {
      margin: 0.5em 0;
      margin-left: 1em;
    }
  }
}
</style>
