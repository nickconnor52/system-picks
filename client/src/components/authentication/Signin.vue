<template>
  <form class="form-signin" @submit.prevent="signin">
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
    <div class="form-group">
      <label for="email">Email address</label>
      <input v-model="email" type="email" class="form-control" id="email" placeholder="email@example.com">
    </div>
    <div class="form-group">
      <label for="password">Password</label>
      <input v-model="password" type="password" class="form-control" id="password" placeholder="Password">
    </div>
    <button type="submit" class="btn btn-primary mb-3">Sign in</button>
    <div>
      <router-link class="link" to="/signup">Sign up</router-link>
    </div>
  </form>
</template>

<script>
import { mapState } from 'vuex'

export default {
  name: 'Signin',
  data () {
    return {
      email: '',
      password: '',
      error: ''
    }
  },
  created () {
    this.checkSignedIn()
  },
  updated () {
    this.checkSignedIn()
  },
  computed: {
    ...mapState([
      'userSignedIn'
    ])
  },
  methods: {
    signin () {
      this.$http.plain.post('/api/signin', { email: this.email, password: this.password })
        .then(response => this.signinSuccessful(response))
        .catch(error => this.signinFailed(error))
    },
    signinSuccessful (response) {
      if (!response.data.csrf) {
        this.signinFailed(response)
        return
      }
      localStorage.csrf = response.data.csrf
      const user = response.data.user
      const payload = {signedIn: true, user: user}
      this.$store.commit('setUserSignedIn', payload)
      this.error = ''
      this.$router.replace('/matchups')
    },
    signinFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      delete localStorage.csrf
      const payload = {signedIn: false, user: {}}
      this.$store.commit('setUserSignedIn', payload)
    },
    checkSignedIn () {
      if (this.userSignedIn) {
        this.$router.replace('/matchups')
      }
    }
  }
}
</script>

<style>
.btn-primary {
  background-color: #35495E;
  border-color: #35495E;
}

#sign-up {
  color: #35495E;
}

.form-signin {
  width: 70%;
  max-width: 500px;
  padding: 10% 15px;
  margin: 0 auto;
}
</style>
