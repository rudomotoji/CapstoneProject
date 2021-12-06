<template>
  <div>
    <header-default class="header-content" />
    <main class="container">
      <div class="sidebar">
        <slot name="left-content" />
      </div>
      <div class="main-content">
        <slot name="main-content" />
      </div>
      <NotificationBox />
    </main>
  </div>
</template>

<script>
import HeaderDefault from "./header";
import NotificationBox from "../components/NotificationBox.vue";
export default {
  components: {
    "header-default": HeaderDefault,
    NotificationBox,
  },
};
</script>

<style style="scss">
.container {
  height: 100vh;
  width: 100vw;
  margin-top: 2.5em;
}
.header-content {
  top: 0;
  left: 0;
  right: 0;
  height: 2.5em;
  background-color: #f9f9f9;
  position: fixed;
  align-items: "flex-end";
}
.main-content {
  background-color: white;
  margin-left: 250px;
  text-align: left;
}
</style>
