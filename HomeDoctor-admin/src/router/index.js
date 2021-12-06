import Vue from 'vue'
import VueRouter from 'vue-router'
// import Login from '../views/login'
import Home from '../views/home'
import HomePage from '../components/home'
import PatientPage from '../components/home/patient'
import ContractPage from '../components/home/contract'
import Licence from '../components/home/licence'

Vue.use(VueRouter)

const routes = [
  // {
  //   path: '/',
  //   name: 'Login',
  //   component: Login
  // },
  {
    path: '/',
    component: Home,
    children: [
      {
        path: '',
        component: HomePage
      },
      {
        path: 'patient',
        component: PatientPage
      },
      {
        path: 'contract',
        component: ContractPage
      },
      {
        path: 'licence',
        component: Licence
      }
    ]
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
