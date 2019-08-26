import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/components/Home'
import Matchups from '@/components/Matchups'
import PickTracker from '@/components/PickTracker'
import Signin from '@/components/authentication/Signin'
import Signup from '@/components/authentication/Signup'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      name: 'Home',
      component: Home
    },
    {
      path: '/matchups',
      name: 'Matchups',
      component: Matchups
    },
    {
      path: '/pick-tracker',
      name: 'PickTracker',
      component: PickTracker
    },
    {
      path: '/signin',
      name: 'Signin',
      component: Signin
    },
    {
      path: '/signup',
      name: 'Signup',
      component: Signup
    }
  ]
})
