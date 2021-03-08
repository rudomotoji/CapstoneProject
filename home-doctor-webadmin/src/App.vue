<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script>
import firebase from "@firebase/app";
import "@firebase/messaging";

export default {
  name: "App",
  methods: {
    prepareFcm() {
      var messaging = firebase.messaging();
      try {
        messaging
          .requestPermission()
          .then(() => {
            return messaging
              .getToken({
                vapidKey:
                  "BOvdz6uBqwhypDNGTkp9HgRyhtjzfWMWqOT4XFpSuOJwRvSwzyr-Hpfr1QeaFf3aSRG9z0HtCQWw4PF_WluKWUQ",
              })
              .then(async (fcmToken) => {
                console.log("token: ", fcmToken);
              })
              .catch((e) => {
                console.log("error: " + e);
              });
          })
          .catch((e) => {
            console.log("error permission: " + e);
          });
      } catch (error) {
        console.log("Unable to get token, ", error);
      }
    },
  },

  created() {
    this.prepareFcm();
  },
};
</script>

<style>
#app {
  font-family: "Roboto", sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
body {
  margin: 0px;
  padding: 0px;
  box-sizing: border-box;
}
</style>
