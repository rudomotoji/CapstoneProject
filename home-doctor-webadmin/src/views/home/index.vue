<template>
  <div>
    <BaseLayout>
      <template v-slot:left-content>
        <LeftContent />
      </template>
      <template v-slot:main-content>
        <h1>home</h1>
      </template>
    </BaseLayout>
  </div>
</template>

<script>
import BaseLayout from "../../layouts/BaseLayout.vue";
import LeftContent from "../../layouts/left-content";

export default {
  name: "Home",
  components: {
    LeftContent,
    BaseLayout,
  },
};
</script>

<style>
</style>
