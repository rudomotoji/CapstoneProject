<template>
  <div class="wrapper">
    <header-default class="header-content" />
    <main class="container">
      <div class="left-content">
        <slot name="left-content" />
      </div>
      <div class="main-content">
        <slot name="main-content" />
      </div>
    </main>
  </div>
</template>

<script>
import HeaderDefault from "./header";
export default {
  components: {
    "header-default": HeaderDefault,
  },
};
</script>

<style style="scss">
.wrapper {
  position: relative;
  min-height: 100%;
}
.container {
  background-color: cornflowerblue;
  width: 100%;
  top: 2em;
  position: absolute;
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
.left-content {
  width: 20%;
  left: 0;
  position: absolute;
  height: 100%;
}
.main-content {
  right: 0%;
  left: 30%;
  position: fixed;
}
</style>
