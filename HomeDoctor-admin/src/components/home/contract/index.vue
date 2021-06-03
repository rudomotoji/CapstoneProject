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
                src="../../../assets/icons/ic-contract.png"
              />
            </el-col>
            <el-col :span="23">
              <div class="next-event__header_title titleColor">
                <strong>Danh sách hợp đồng</strong>
                <p v-if="listContracts.length > 0">
                  Hiện tại đang có {{ listContracts.length }} hợp đồng trong hệ
                  thống
                </p>
                <p v-else>Hiện chưa có hợp đồng nào trong hệ thống</p>
              </div>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-table :data="listContracts">
        <el-table-column prop="contractCode" label="Mã"> </el-table-column>
        <el-table-column prop="fullNameDoctor" label="Người chăm sóc">
        </el-table-column>
        <el-table-column prop="fullNamePatient" label="Bệnh nhân">
        </el-table-column>
        <el-table-column label="Ngày bắt đầu">
          <template slot-scope="scope">
            {{ formatDateTime(scope.row.dateStarted) }}
          </template>
        </el-table-column>
        <el-table-column label="Ngày kết thúc">
          <template slot-scope="scope">
            {{ formatDateTime(scope.row.dateFinished) }}
          </template>
        </el-table-column>
        <el-table-column label="Trạng thái">
          <template slot-scope="scope">
            <el-tag
              v-if="
                scope.row.status === 'ACTIVE' || scope.row.status === 'APPROVED'
              "
              >{{ scope.row.status }}</el-tag
            >
            <el-tag
              v-if="
                scope.row.status === 'CANCELP' || scope.row.status === 'CANCELD'
              "
              type="info"
              >{{ scope.row.status }}</el-tag
            >
            <el-tag v-if="scope.row.status === 'FINISHED'" type="success">{{
              scope.row.status
            }}</el-tag>
            <el-tag
              v-if="
                scope.row.status === 'PENDING' || scope.row.status === 'SIGNED'
              "
              type="warning"
              >{{ scope.row.status }}</el-tag
            >
            <el-tag v-if="scope.row.status === 'LOCKED'" type="danger">{{
              scope.row.status
            }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column fixed="right" label="" width="120">
          <template slot-scope="scope">
            <div>
              <el-button
                @click="viewDetail(scope.row)"
                type="text"
                size="small"
              >
                Chi tiết
              </el-button>
              <el-button
                v-if="scope.row.status === 'LOCKED' && checkOpenContract(scope.row.dateFinished) === true"
                v-on:click="ChangeStatus(scope.row.contractId, 'ACTIVE')"
                type="text"
                size="small"
              >
                Mở lại
              </el-button>
              <!-- <el-button
                v-if="
                  scope.row.status === 'SIGNED' || scope.row.status === 'ACTIVE'
                "
                v-on:click="ChangeStatus(scope.row.contractId, 'LOCKED')"
                type="text"
                size="small"
              >
                Khóa
              </el-button> -->
            </div>
          </template>
        </el-table-column>
      </el-table>
      <!-- <div class="block">
    <span class="demonstration">Change page size</span>
    <el-pagination
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
      :current-page.sync="currentPage2"
      :page-sizes="[100, 200, 300, 400]"
      :page-size="100"
      layout="sizes, prev, pager, next"
      :total="1000">
    </el-pagination>
  </div> -->

      <el-dialog
        title="Thông tin hợp đồng"
        :visible.sync="dialogVisible"
        width="50%"
        :before-close="closeDialog"
      >
        <div>
          <div v-if="contractDetail!=null">
            <h3>Hợp đồng: {{ contractDetail.contractCode }}</h3>
            <div class="row" style="display: flex; justify-content: space-between">
              <div class="column">
                <span>Bác sĩ: {{ contractDetail.fullNameDoctor }}</span>
                <span>SĐT: {{ contractDetail.phoneNumberDoctor }}</span>
              </div>
              <div class="column">
                <span>Bệnh nhân: {{ contractDetail.fullNamePatient }}</span>
                <span>SĐT: {{ contractDetail.phoneNumberPatient }}</span>
              </div>
            </div>
            <div style="display: grid">
              <span>Trạng thái: {{ contractDetail.status }}</span>
              <span
                >Ngày bắt đầu:
                {{ formatDateTime(contractDetail.dateStarted) }}</span
              >
              <span
                >Ngày kết thúc:
                {{ formatDateTime(contractDetail.dateFinished) }}</span
              >
              <span>Tổng ngày theo dõi: {{ contractDetail.daysOfTracking }}</span>
              <span
                >Tổng tiền:
                {{ contractDetail.priceLicense * contractDetail.daysOfTracking }}
                ({{ contractDetail.nameLicense }})</span
              >
              <el-button @click="closeDialog">Đóng</el-button>
            </div>
          </div>
        </div>
      </el-dialog>
    </div>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'
import moment from 'moment'
export default {
  data () {
    return {
      dialogVisible: false,
      contractDetail: null
    }
  },
  computed: {
    ...mapState('contract', ['listContracts']),
    ...mapState('time', ['timeSystem'])
  },
  mounted () {
    this.getTimeSystem()
    this.getListContracts()
  },
  methods: {
    ...mapActions('contract', ['getListContracts', 'activeContract']),
    ...mapActions('time', ['getTimeSystem']),

    ChangeStatus (id, status) {
      if (status === 'LOCKED') {
        if (confirm('Bạn chắc chắn muốn khóa hợp đồng này?')) {
          this.activeContract({ id, status })
            .then((resp) => {
              console.log(resp)
            })
            .catch((error) => {
              console.log(error)
            })
        }
      } else if (status === 'ACTIVE') {
        if (confirm('Bạn chắc chắn muốn mở khóa hợp đồng này?')) {
          this.activeContract({ id, status })
            .then((resp) => {
              console.log(resp)
            })
            .catch((error) => {
              console.log(error)
            })
        }
      }
    },
    formatDateTime (dateStr) {
      return moment(dateStr).format('DD/MM/YYYY')
    },
    viewDetail (row) {
      this.dialogVisible = true
      this.contractDetail = row
    },
    closeDialog () {
      this.dialogVisible = false
      this.contractDetail = null
    },
    checkOpenContract (dateFinished) {
      if (Date.parse(dateFinished) > Date.parse(this.timeSystem)) {
        return true
      } else {
        return false
      }
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
/* Create three equal columns that floats next to each other */
.column {
  float: left;
  // width: 33.33%;
  display: grid;
  // height: 300px; /* Should be removed. Only for demonstration */
}

/* Clear floats after the columns */
.row:after {
  clear: both;
}
span {
  padding: 10px;
}
</style>
