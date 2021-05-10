<template>
  <div class="wrapper">
    <header-default />
    <main>
      <slot name="left-content" />
      <slot name="main-content" />
    </main>
    <footer-default class="footer-content" />
  </div>
</template>

<script>
import HeaderDefault from "../components/header";
import FooterDefault from "../components/footer";
export default {
  components: {
    "header-default": HeaderDefault,
    "footer-default": FooterDefault,
  },
};
</script>

<style style="scss">
</style>
