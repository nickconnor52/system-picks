<template>
  <form class="form-signup" @submit.prevent="signup">
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
    <div class="form-group">
      <label for="email">Email address</label>
      <input v-model="email" type="email" class="form-control" id="email" placeholder="email@example.com">
    </div>
    <div class="form-group">
      <label for="password">Password</label>
      <input v-model="password" type="password" class="form-control" id="password" placeholder="Password">
    </div>
    <div class="form-group">
      <label for="password">Password Confirmation</label>
      <input v-model="password_confirmation" type="password" class="form-control" id="password_confirmation" placeholder="Password Confirmation">
    </div>
    <button type="submit" class="btn btn-primary mb-3">Sign up</button>
    <div>
      <router-link class="link" to="/">Sign in</router-link>
    </div>
  </form>
</template>

<script>
import { mapState } from 'vuex'

export default {
  name: 'Signup',
  data () {
    return {
      email: '',
      password: '',
      password_confirmation: '',
      error: ''
    }
  },
  computed: {
    ...mapState([
      'userSignedIn'
    ])
  },
  created () {
    this.checkSignedIn()
  },
  updated () {
    this.checkSignedIn()
  },
  methods: {
    signup () {
      this.$http.plain.post('/api/signup', { email: this.email, password: this.password, password_confirmation: this.password_confirmation })
        .then(response => this.signupSuccessful(response))
        .catch(error => this.signupFailed(error))
    },
    signupSuccessful (response) {
      if (!response.data.csrf) {
        this.signupFailed(response)
        return
      }
      const user = response.data.user
      const payload = {signedIn: true, user: user}
      localStorage.csrf = response.data.csrf
      this.$store.commit('setUserSignedIn', payload)
      this.error = ''
      this.$router.replace('/matchups')
    },
    signupFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
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

<style lang="css">
.btn-primary {
  background-color: #35495E;
  border-color: #35495E;
}

.link {
  color: #35495E;
}

.form-signup {
  width: 70%;
  max-width: 500px;
  padding: 10% 15px;
  margin: 0 auto;
}
</style>
