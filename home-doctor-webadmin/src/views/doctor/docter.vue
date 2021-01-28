<template>
  <div>
    <BaseLayout>
      <template v-slot:left-content>
        <LeftContent />
      </template>
      <template v-slot:main-content>
        <el-table :data="listDoctor" style="width: 100%">
          <el-table-column abel="Avatar" width="180">
            <template slot-scope="doctor">
              <img
                v-bind:src="doctor.avatar"
                style="width: 50px; height: 50px"
              />
            </template>
          </el-table-column>
          <el-table-column prop="fullname" label="Tên" width="180">
          </el-table-column>
          <el-table-column prop="phone" label="SĐT"> </el-table-column>
          <el-table-column fixed="right" label="Operations" width="120">
            <template>
              <router-link
                :to="{ name: 'doctor-detail', param: { docterID: 1 } }"
              >
                <el-button type="text" size="small">Detail</el-button>
              </router-link>
            </template>
          </el-table-column>
        </el-table>
      </template>
    </BaseLayout>
  </div>
</template>

<script>
import BaseLayout from "../../layouts/BaseLayout.vue";
import LeftContent from "../../layouts/left-content";
import { mapActions, mapState } from "vuex";

export default {
  name: "doctor",
  components: {
    LeftContent,
    BaseLayout,
  },
  computed: {
    ...mapState("doctor", ["listDoctor"]),
  },
  methods: {
    ...mapActions("doctor", ["getListDoctor"]),
  },
  mounted() {
    this.getListDoctor();
  },
};
</script>

<style>
</style>
