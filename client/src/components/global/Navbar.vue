<template>
<div id="app">
    <!-- <header>
      <nav id="global-navbar" style="padding-top: 7px" class="nav-bar nav nav-pills nav-fill">
        <a class="nav-item nav-link navitem" :class="{ active: activeLink1 }" href="/">Home</a>
        <a class="nav-item nav-link navitem" :class="{ active: activeLink2 }" href="/matchups/">Matchups</a>
        <a class="nav-item nav-link navitem" :class="{ active: activeLink3 }" href="/pick-tracker/">Pick Tracker</a>
      </nav>
    </header> -->
  <b-navbar id="global-navbar" toggleable="lg" type="dark" variant="primary">
    <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>
    <b-collapse id="nav-collapse" is-nav>
      <b-navbar-brand class="nav-item logo" href="/">The System</b-navbar-brand>
      <b-navbar-nav>
        <b-nav-item class="nav-item" href="/matchups">Matchups</b-nav-item>
        <b-nav-item class="nav-item" href="/pick-tracker">Pick Tracker</b-nav-item>
      </b-navbar-nav>

      <!-- Right aligned nav items -->
      <b-navbar-nav class="ml-auto">
        <b-nav-item-dropdown v-if="userSignedIn" right>
          <!-- Using 'button-content' slot -->
          <template slot="button-content"><em>User</em></template>
          <b-dropdown-item @click="signOut">Sign Out</b-dropdown-item>
        </b-nav-item-dropdown>
        <b-nav-item v-else class="nav-item" href="/signin">Sign In</b-nav-item>
      </b-navbar-nav>
    </b-collapse>
  </b-navbar>
</div>
</template>
<script>
import { mapState } from 'vuex'

export default {
  name: 'navbar',
  computed: {
    ...mapState([
      'userSignedIn'
    ]),
    activeLink1 () {
      return this.$route.path === '/'
    },
    activeLink2 () {
      console.log(this.$route.path)
      return this.$route.path === '/matchups/'
    },
    activeLink3 () {
      return this.$route.path === '/pick-tracker/'
    }
  },
  methods: {
    signOut () {
      this.$http.secured.delete('/api/signin')
        .then(response => {
          delete localStorage.csrf
          this.$store.commit('setUserSignedIn', false)
          this.$router.replace('/')
        })
        .catch(error => this.setError(error, 'Cannot sign out'))
    }
  }
}
</script>
<style>
#global-navbar {
  background-color: #35495E !important;
}

#global-navbar .nav-item {
  /* background-color: #9e253196; */
  margin-left: 3px;
  margin-right: 3px;

}

.active {
  /* background-color: #ff5f5f !important */
}

.navitem {
  /* color: white !important */
}
</style>
