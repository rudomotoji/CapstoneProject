<template>
  <div>
    <BaseLayout>
      <template v-slot:left-content>
        <LeftContent />
      </template>
      <template v-slot:main-content>
        <el-button type="primary" @click="dialogVisible = true"
          >Thêm triệu chứng</el-button
        >
        <el-table
          :data="listsymptom"
          style="width: 100%"
          @cell-click="getDetailToUpdate"
        >
          <el-table-column prop="name" label="Tên"> </el-table-column>
          <el-table-column prop="code" label="Giá"> </el-table-column>
        </el-table>
      </template>
    </BaseLayout>
    <el-dialog
      title="Triệu chứng"
      :visible.sync="dialogVisible"
      width="50%"
      :before-close="closeDialog"
    >
      <el-form ref="form" :model="form">
        <el-form-item label="Mã">
          <el-input v-model="form.code"></el-input>
        </el-form-item>
        <el-form-item label="Tên">
          <el-input v-model="form.name"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button v-if="form == null" type="primary" @click="newsymptom"
            >Tạo</el-button
          >
          <el-button v-if="form != null" type="primary" @click="editsymptom"
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
  name: "symptom",
  components: {
    LeftContent,
    BaseLayout,
  },
  mounted() {
    this.getListSymptom();
  },
  data() {
    return {
      dialogVisible: false,
      form: {},
    };
  },
  computed: {
    ...mapState("symptom", ["listsymptom"]),
  },
  methods: {
    ...mapActions("symptom", [
      "getListSymptom",
      "createsymptom",
      "updatesymptom",
    ]),
    newsymptom() {
      this.dialogVisible = false;
      this.createsymptom(this.form);
      this.form = {};
    },
    editsymptom() {
      this.dialogVisible = false;
      this.updatesymptom(this.form);
      this.form = {};
    },
    closeDialog() {
      this.dialogVisible = false;
      this.form = {};
    },
    getDetailToUpdate(event) {
      this.form = {
        id: event.id,
        name: event.name,
        code: event.code,
      };
      this.dialogVisible = true;
    },
  },
};
</script>

<style>
</style>
