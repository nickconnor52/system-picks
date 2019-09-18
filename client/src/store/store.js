import Vue from 'vue'
import Vuex from 'vuex'
import createPersistedState from 'vuex-persistedstate'

Vue.use(Vuex)

const state = {
  luckyNumber: '52',
  activeWeek: '3',
  userSignedIn: false,
  activeUser: {},
  chosenSeason: '2019'
}
const getters = { }
const mutations = {
  setActiveWeek (state, data) {
    state.activeWeek = data
  },
  setUserSignedIn (state, payload) {
    state.userSignedIn = payload.signedIn
    state.activeUser = payload.user
  },
  updateSeason (state, value) {
    state.chosenSeason = value
    state.activeWeek = '1'
  }
}
const actions = {
  // Vudo - Be a good Boyscout and move all Axios Calls here, please!
}

export default new Vuex.Store({
  plugins: [createPersistedState({
    paths: ['userSignedIn', 'activeUser', 'activeWeek', 'chosenSeason']
  })],
  state,
  // Current state of the application lies here.
  getters,
  // Compute derived state based on the current state. More like computed property.
  mutations,
  // Mutate the current state
  actions
  // Get data from server and send that to mutations to mutate the current state
})
