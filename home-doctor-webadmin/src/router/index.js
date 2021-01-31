import VueRouter from 'vue-router'
import Vue from 'vue'

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import("../views/home")
  },
  {
    path: '/doctor',
    name: 'doctor',
    component: () => import("../views/doctor/docter.vue")
  },
  {
    path: '/doctor-detail',
    name: 'doctor-detail',
    component: () => import("../views/doctor/docter-detail.vue")
  },
  {
    path: '/license',
    name: 'license',
    component: () => import("../views/license")
  },
  {
    path: '/disease',
    name: 'disease',
    component: () => import("../views/disease")
  },
]

Vue.use(VueRouter);
const router = new VueRouter({
  mode: 'history',
  routes
})

export default router;