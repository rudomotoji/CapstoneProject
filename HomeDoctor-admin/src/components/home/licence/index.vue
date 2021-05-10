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
                src="../../../assets/icons/ic-licence.png"
              />
            </el-col>
            <el-col :span="23">
              <div class="next-event__header_title titleColor">
                <strong>Danh sách gói hợp đồng</strong>
              </div>
            </el-col>
            <!-- <el-col :span="2">
              <el-button type="primary" @click="dialogVisible = true"
                >Thêm gói</el-button
              >
            </el-col> -->
          </el-row>
        </el-col>
      </el-row>
      <el-table :data="licences">
        <el-table-column prop="name" label="Tên gói"> </el-table-column>
        <el-table-column prop="days" label="Số ngày theo dõi">
        </el-table-column>
        <el-table-column prop="price" label="Giá tiền"> </el-table-column>
        <el-table-column prop="description" label="Mô tả"> </el-table-column>
        <el-table-column prop="status" label="Trạng thái"> </el-table-column>
      </el-table>

      <el-dialog title="Thêm gói" :visible.sync="dialogVisible" width="40%">
        <el-form
          :model="ruleForm"
          :rules="rules"
          ref="ruleForm"
          label-width="170px"
          class="demo-ruleForm"
        >
          <el-form-item label="Tên gói" prop="name">
            <el-input v-model="ruleForm.name"></el-input>
          </el-form-item>
          <el-form-item label="Số ngày theo dõi" prop="days">
            <el-input-number
              v-model="ruleForm.days"
              :min="1"
              :max="10000"
              style="width: 100%"
            ></el-input-number>
          </el-form-item>
          <el-form-item label="Giá tiền" prop="price">
            <el-input-number
              v-model="ruleForm.price"
              :min="1000"
              :max="1000000000"
              style="width: 100%"
            ></el-input-number>
          </el-form-item>
          <el-form-item label="Mô tả" prop="description">
            <el-input
              :autosize="{ minRows: 2, maxRows: 4 }"
              type="textarea"
              v-model="ruleForm.description"
            ></el-input>
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
import { mapState, mapActions } from "vuex";
import moment from "moment";
export default {
  data() {
    return {
      dialogVisible: false,
      ruleForm: {
        price: 0,
        days: 0,
        name: "",
        description: "",
      },
      rules: {
        price: [
          {
            required: true,
            message: "Giá tiền không thể bỏ trông",
            trigger: "blur",
            trigger: "change",
          },
        ],
        days: [
          {
            required: true,
            message: "Ngày theo dõi không thể bỏ trống",
            trigger: "blur",
            trigger: "change",
          },
        ],
        name: [
          {
            required: true,
            message: "Tên gói không thể bỏ trống",
            trigger: "blur",
            trigger: "change",
          },
        ],
      },
    };
  },
  computed: {
    ...mapState("licence", ["licences"]),
  },
  mounted() {
    this.getLicences();
  },
  methods: {
    ...mapActions("licence", ["getLicences", "createLicense"]),
    formatDateTime(dateStr) {
      return moment(dateStr).format("DD/MM/YYYY");
    },
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.dialogVisible = false;
          this.createLicense(ruleForm);
        } else {
          console.log("error submit!!");
          return false;
        }
      });
    },
    resetForm(formName) {
      this.$refs[formName].resetFields();
    },
  },
};
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
