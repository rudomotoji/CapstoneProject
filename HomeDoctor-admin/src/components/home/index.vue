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
                src="../../assets/icons/ic-medical-instruction.png"
              />
            </el-col>
            <el-col :span="23">
              <div class="next-event__header_title titleColor">
                <strong>Danh sách các bác sĩ trong hệ thống</strong>
                <p v-if="listDoctor.length > 0">
                  Hiện tại đang có {{ listDoctor.length }} bác sĩ trong hệ thống
                </p>
                <p v-else>Hiện chưa có bác sĩ nào trong hệ thống</p>
              </div>
            </el-col>
            <!-- <el-col :span="2">
              <el-button type="primary" @click="dialogVisible = true"
                >Thêm bác sĩ</el-button
              >
            </el-col> -->
          </el-row>
        </el-col>
      </el-row>
      <el-table :data="listDoctor">
        <el-table-column prop="fullName" label="Tên"> </el-table-column>
        <el-table-column prop="phone" label="SĐT"> </el-table-column>
        <el-table-column prop="email" label="Email"> </el-table-column>
        <el-table-column prop="workLocation" label="Nơi làm việc">
        </el-table-column>
        <el-table-column prop="address" label="Nơi ở"></el-table-column>
      </el-table>

      <el-dialog title="Thêm bác sĩ" :visible.sync="dialogVisible" width="50%">
        <el-form
          :model="ruleForm"
          :rules="rules"
          ref="ruleForm"
          label-width="170px"
          class="demo-ruleForm"
        >
          <el-form-item label="Tên đăng nhập" prop="username">
            <el-input v-model="ruleForm.username"></el-input>
          </el-form-item>
          <el-form-item label="Họ và tên" prop="fullName">
            <el-input v-model="ruleForm.fullName"></el-input>
          </el-form-item>
          <el-form-item label="Số điện thoại" prop="phone">
            <el-input v-model="ruleForm.phone"></el-input>
          </el-form-item>
          <el-form-item label="Email" prop="email">
            <el-input v-model="ruleForm.email"></el-input>
          </el-form-item>
          <el-form-item label="Ngày sinh" prop="dateOfBirth">
            <el-col :span="11">
              <el-date-picker
                format="dd/MM/yyyy"
                type="date"
                placeholder="Chọn ngày sinh"
                v-model="ruleForm.dateOfBirth"
                style="width: 100%"
              ></el-date-picker>
            </el-col>
          </el-form-item>
          <el-form-item label="Nơi làm việc" prop="workLocation">
            <el-input v-model="ruleForm.workLocation"></el-input>
          </el-form-item>
          <el-form-item label="Số năm kinh nghiệm" prop="experience">
            <el-input v-model="ruleForm.experience"></el-input>
          </el-form-item>
          <el-form-item label="Chuyên khoa" prop="specialization">
            <el-input v-model="ruleForm.specialization"></el-input>
          </el-form-item>
          <el-form-item label="Nơi ở hiện tại" prop="address">
            <el-input v-model="ruleForm.address"></el-input>
          </el-form-item>
          <el-form-item label="Thông tin thêm" prop="details">
            <el-input type="textarea" v-model="ruleForm.details"></el-input>
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="submitForm('ruleForm')"
              >Tạo</el-button
            >
            <el-button @click="dialogVisible = false">Hủy</el-button>
          </el-form-item>
        </el-form>
      </el-dialog>
    </div>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'
import { isValidEmail, isPhone } from '../../utils/validation'
export default {
  data () {
    var checkEmail = (rule, value, callback) => {
      if (!value) {
        return callback(new Error('Vui long nhap email'))
      }
      setTimeout(() => {
        if (!isValidEmail(value)) {
          callback(new Error('Vui long nhap dung format email'))
        } else {
          callback()
        }
      }, 1000)
    }
    var checkPhone = (rule, value, callback) => {
      if (!value) {
        return callback(new Error('Vui long nhap SDT'))
      }
      setTimeout(() => {
        if (!isPhone(value)) {
          callback(new Error('Vui long nhap dung format SDT'))
        } else {
          callback()
        }
      }, 1000)
    }
    return {
      dialogVisible: false,
      ruleForm: {
        username: '',
        fullName: '',
        workLocation: '',
        experience: '',
        specialization: '',
        address: '',
        details: '',
        phone: '',
        email: '',
        dateOfBirth: ''
      },
      rules: {
        username: [
          {
            required: true,
            message: 'Khong duoc bo trong',
            trigger: 'blur'
          },
          {
            min: 3,
            max: 5,
            message: 'Ten danng nhap can lon hon 3 va nho hon 5',
            trigger: 'blur'
          }
        ],
        fullName: [
          {
            required: true,
            message: 'Khong duoc bo trong',
            trigger: 'blur'
          }
        ],
        dateOfBirth: [
          {
            required: true,
            message: 'Khong duoc bo trong',
            trigger: 'change'
          }
        ],
        phone: [
          {
            trigger: 'blur',
            validator: checkPhone,
            required: true
          }
        ],
        email: [
          {
            trigger: 'blur',
            validator: checkEmail,
            required: true
          },
          {
            type: 'email',
            message: 'Vui long nhap dung email format ',
            trigger: ['blur', 'change']
          }
        ],
        address: [
          {
            required: true,
            message: 'Khong duoc bo trong',
            trigger: 'blur'
          }
        ],
        workLocation: [
          {
            required: true,
            message: 'Khong duoc bo trong',
            trigger: 'blur'
          }
        ],
        specialization: [
          {
            required: true,
            message: 'Khong duoc bo trong',
            trigger: 'blur'
          }
        ]
      }
    }
  },
  computed: {
    ...mapState('doctor', ['listDoctor']),
    ...mapState('time', ['openDialogTime', 'timeSystem'])
  },
  mounted () {
    this.login()
    this.getTimeSystem()
  },
  methods: {
    ...mapActions('doctor', ['getListDoctor', 'login']),
    ...mapActions('time', ['setTimeSystem', 'getTimeSystem']),
    submitForm (formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          alert('submit!')
          this.dialogVisible = false
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    resetForm (formName) {
      this.$refs[formName].resetFields()
    }
  }
}
</script>

<style lang="scss">
@import "../../style/index.scss";
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
.danger {
  animation: myfirst 0.5s infinite;
  webkit-animation: myfirst 0.5s infinite;
}
@keyframes myfirst {
  0% {
    background: transparent;
  }
  100% {
    background: red;
  }
}
</style>
