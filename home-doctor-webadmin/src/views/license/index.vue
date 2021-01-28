<template>
  <div>
    <BaseLayout>
      <template v-slot:left-content>
        <LeftContent />
      </template>
      <template v-slot:main-content>
        <el-button type="primary" @click="dialogVisible = true"
          >Thêm gói</el-button
        >
        <el-table
          :data="listLicense"
          style="width: 100%"
          @cell-click="getDetailToUpdate"
        >
          <el-table-column prop="name" label="Tên"> </el-table-column>
          <el-table-column prop="price" label="Giá"> </el-table-column>
          <el-table-column prop="type" label="Loại"></el-table-column>
          <el-table-column prop="description" label="Mô tả"></el-table-column>
          <!-- <el-table-column fixed="right" label="">
            <template>
              <el-button type="text" size="small">Cập nhật</el-button>
            </template>
          </el-table-column> -->
        </el-table>
      </template>
    </BaseLayout>
    <el-dialog
      title="Gói hợp đồng"
      :visible.sync="dialogVisible"
      width="50%"
      :before-close="closeDialog"
    >
      <el-form ref="form" :model="form">
        <el-form-item label="Tên">
          <el-input v-model="form.name"></el-input>
        </el-form-item>
        <el-form-item label="Giá">
          <el-input type="number" v-model="form.price"></el-input>
        </el-form-item>
        <el-form-item label="Loại">
          <el-radio-group v-model="form.type">
            <el-radio label="Bác sĩ"></el-radio>
            <el-radio label="Bệnh nhân"></el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="Mô tả">
          <el-input type="textarea" v-model="form.description"></el-input>
        </el-form-item>

        <el-form-item>
          <el-button v-if="form == null" type="primary" @click="newLicense"
            >Tạo</el-button
          >
          <el-button v-if="form != null" type="primary" @click="editLicense"
            >Cập nhật</el-button
          >
          <el-button @click="closeDialog">Cancel</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
import BaseLayout from "../../layouts/BaseLayout.vue";
import LeftContent from "../../layouts/left-content";
import { mapActions, mapState } from "vuex";

export default {
  name: "license",
  components: {
    LeftContent,
    BaseLayout,
  },
  data() {
    return {
      dialogVisible: false,
      form: {},
    };
  },
  computed: {
    ...mapState("license", ["listLicense"]),
  },
  methods: {
    ...mapActions("license", [
      "getListLicense",
      "createLicense",
      "updateLicense",
    ]),
    newLicense() {
      this.dialogVisible = false;
      this.createLicense(this.form);
      this.form = {};
    },
    editLicense() {
      this.dialogVisible = false;
      this.updateLicense(this.form);
      this.form = {};
    },
    closeDialog() {
      this.dialogVisible = false;
      this.form = {
        id: "",
        name: "",
        type: "",
        description: "",
        price: 0,
      };
    },
    getDetailToUpdate(event) {
      this.form = {
        id: event.id,
        name: event.name,
        type: event.type,
        description: event.description,
        price: event.price,
      };
      this.dialogVisible = true;
    },
  },
  mounted() {
    this.getListLicense();
  },
};
</script>

<style>
</style>
