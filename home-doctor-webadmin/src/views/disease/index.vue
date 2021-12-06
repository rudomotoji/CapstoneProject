<template>
  <div>
    <BaseLayout>
      <template v-slot:left-content>
        <LeftContent />
      </template>
      <template v-slot:main-content>
        <el-button
          type="primary"
          @click="dialogVisible = true"
          style="margin: 16px"
          >Thêm triệu chứng</el-button
        >
        <el-table :data="listDiseases" style="width: 100%">
          <el-table-column prop="diseaseId" label="Mã"> </el-table-column>
          <el-table-column prop="name" label="Tên"> </el-table-column>
          <el-table-column fixed="right" label="">
            <template slot-scope="scope">
              <el-button
                type="text"
                size="small"
                @click="getDetailToUpdate(scope.row)"
                >Cập nhật</el-button
              >
            </template>
          </el-table-column>
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
          <el-input v-model="form.diseaseId"></el-input>
        </el-form-item>
        <el-form-item label="Tên">
          <el-input v-model="form.name"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button
            v-if="form.diseaseId == null"
            type="primary"
            @click="newDisease"
            >Tạo</el-button
          >
          <el-button
            v-if="form.diseaseId != null"
            type="primary"
            @click="editDisease"
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
  name: "disease",
  components: {
    LeftContent,
    BaseLayout,
  },
  mounted() {
    this.getListDisease();
  },
  data() {
    return {
      dialogVisible: false,
      form: {},
    };
  },
  computed: {
    ...mapState("disease", ["listDiseases"]),
  },
  methods: {
    ...mapActions("disease", [
      "getListDisease",
      "createDisease",
      "updateDisease",
    ]),
    newDisease() {
      this.dialogVisible = false;
      this.createDisease(this.form);
      this.form = {};
    },
    editDisease() {
      this.dialogVisible = false;
      this.updateDisease(this.form);
      this.form = {};
    },
    closeDialog() {
      this.dialogVisible = false;
      this.form = {};
    },
    getDetailToUpdate(event) {
      this.form = {
        name: event.name,
        diseaseId: event.diseaseId,
      };
      this.dialogVisible = true;
    },
  },
};
</script>

<style>
</style>
