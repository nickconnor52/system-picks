<template>
<div class="card">
  <div class="card-header">
    <ul id="header-override" class="nav nav-pills card-header-pills d-flex justify-content-md-center matchup-header">
        <li>
          <a @click="clickMatchDetails()" class="nav-link text-dark" href="#">View Matchup Details</a>
        </li>
        <li>
          <strong v-if="isAdmin" @click="showCustomWeightModal=true" class="nav-link text-dark pointer" href="#">Add Custom Spread Weight</strong>
        </li>
        <li>
          <strong v-if="isAdmin" @click="showSpreadModal=true" class="nav-link text-dark pointer" href="#">Update Current Spread</strong>
        </li>
        <li>
          <strong v-if="isAdmin" @click="showScoreModal=true" class="nav-link text-dark pointer" href="#">Update Score</strong>
        </li>
        <li>
          <i v-if="isAdmin" class="nav-link fas fa-sync-alt pointer align-center" @click="updateLine()" />
        </li>
        <li>
          <i v-if="isAdmin" class="nav-link far fa-edit pointer align-center" @click="showNoteModal=true" />
        </li>
    </ul>
  </div>
  <div id="bootstrap-matchup-override" class="card-body">
    <div class="row justify-content-md-center">
      <div class="col-md-4">
        <div class="card-body logo" :class="{ 'bg-success': this.predictedWinner.name === matchup.away_team.name }">
        <img :src="getSrc(matchup.away_team['name'])" :alt="matchup.away_team['name']"/>
        <h4 class="text-dark">{{matchup.away_team['location'] }} {{matchup.away_team['name'] }}</h4>
        </div>
      </div>
      <div class="col-md-2 align-self-center" style="margin-bottom: 5px">
        <h5 class="align-middle auto-margin">Vegas: {{ vegasSpreadFormatted }}</h5>
        <h5 class="align-end auto-margin">TheSystem: {{ systemSpreadFormatted }}</h5>
        <i v-if="matchup.home_team_score && matchup.away_team_score && matchupPush" class="push-box" style="font-size: 1.5em;">PUSH</i>
        <i v-else-if="matchup.home_team_score && matchup.away_team_score && matchup.correct_pick === 'true'" class="far fa-check-circle text-success" style="font-size: 2em; opacity: 0.8"></i>
        <i v-else-if="matchup.home_team_score && matchup.away_team_score && matchup.correct_pick ==='false'" class="far fa-times-circle text-danger" style="font-size: 2em; opacity: 0.8"></i>
      </div>
      <div class="col-md-4">
        <div class="card-body logo" :class="{ 'bg-success': this.predictedWinner.name === matchup.home_team.name }">
        <img :src="getSrc(matchup.home_team['name'])" :alt="matchup.home_team['name']"/>
        <h4 class="text-dark">{{matchup.home_team['location'] }} {{ matchup.home_team['name'] }}</h4>
        </div>
      </div>
    </div>
    <br>
    <div v-if="matchup.away_team_score && matchup.home_team_score" class="row justify-content-center">
      <div class="col-md-4">
        <strong class="score">{{matchup.away_team_score}}</strong>
      </div>
      <div class="offset-md-2 col-md-4">
        <strong class="score">{{matchup.home_team_score}}</strong>
      </div>
      <div>
      </div>
    </div>
    <div v-if="matchup.note">
      <small><strong>Matchup Note: </strong>{{ matchup.note }}</small>
    </div>
    <div v-if="matchup.custom_weight !== '0'">
      <small><strong>Custom Weight: </strong>{{ matchup.custom_weight }}</small>
    </div>
  </div>

  <!-- Custom Weight Modal -->
  <div v-if="showCustomWeightModal">
    <transition name="modal">
      <div class="modal-mask">
        <div class="modal-wrapper">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" style="width: 100%;">{{ matchup.away_team.name }} v {{ matchup.home_team.name }}</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" @click="showCustomWeightModal = false">
                <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body container">
                <div class="row justify-content-center">
                  <label class="col-md-4 col-form-label" for="spread">Spread Custom Weight:</label>
                  <input type="text" id="spread" class="form-control col-md-4" v-model="customWeight" placeholder="Custom Weighting" style="margin-left: 15px"/>
                </div>
                <br>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" @click="showCustomWeightModal = false">Close</button>
                <button type="button" class="btn btn-primary" :disabled="customWeight === ''" @click="updateCustomWeight()">Submit Weighting</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>

 <!-- Spread Modal -->
  <div v-if="showSpreadModal">
    <transition name="modal">
      <div class="modal-mask">
        <div class="modal-wrapper">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" style="width: 100%;">{{ matchup.away_team.name }} v {{ matchup.home_team.name }}</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" @click="showSpreadModal = false">
                <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body container">
                <div class="row justify-content-center">
                  <label class="col-md-4 col-form-label" for="spread">Home Spread:</label>
                  <input type="text" id="spread" class="form-control col-md-4" v-model="updatedSpread" placeholder="Current Spread" style="margin-left: 15px"/>
                </div>
                <br>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" @click="showSpreadModal = false">Close</button>
                <button type="button" class="btn btn-primary" :disabled="updatedSpread === ''" @click="updateSpread()">Submit Spread</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>

 <!-- Score Modal -->
  <div v-if="showScoreModal">
    <transition name="modal">
      <div class="modal-mask">
        <div class="modal-wrapper">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" style="width: 100%;">{{ matchup.away_team.name }} v {{ matchup.home_team.name }}</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" @click="showScoreModal = false">
                <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body container">
                <div class="row justify-content-center">
                  <label class="col-md-3 col-form-label" for="awayScore">{{ matchup.away_team.name }}:</label>
                  <input type="text" id="awayScore" class="form-control col-md-4" v-model="away_team_score" placeholder="Away" style="margin-left: 15px"/>
                </div>
                <br>
                <div class="row justify-content-center">
                  <label class="col-md-3 col-form-label" for="homeScore">{{ matchup.home_team.name }}:</label>
                  <input type="text" id="homeScore" class="form-control col-md-4" v-model="home_team_score" placeholder="Home" style="margin-left: 15px"/>
                </div>
                <br>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" @click="showScoreModal = false">Close</button>
                <button type="button" class="btn btn-primary" :disabled="home_team_score === '' || away_team_score === ''" @click="updateScore()">Submit Score</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>

 <!-- Notes Modal -->
  <div v-if="showNoteModal">
    <transition name="modal">
      <div class="modal-mask">
        <div class="modal-wrapper">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" style="width: 100%;">{{ matchup.away_team.name }} v {{ matchup.home_team.name }}</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" @click="showNoteModal = false">
                <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body container">
                <div class="row justify-content-center">
                  <label class="col-md-3 col-form-label" for="awayScore">Matchup Note:</label>
                  <textarea type="text" id="note" class="form-control col-md-8" v-model="note" placeholder="Add Matchup Note" style="margin-left: 15px"/>
                </div>
                <br>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" @click="showNoteModal = false">Close</button>
                <button type="button" class="btn btn-primary" :disabled="note === ''" @click="addNote()">Add Note</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>

  <!-- Stats Modal -->
  <div v-if="showMatchupModal">
    <transition name="modal">
      <div class="modal-mask">
        <div class="modal-wrapper">
          <div class="modal-dialog" style="max-width: 1250px" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" style="width: 100%;">{{ matchup.away_team.name }} v {{ matchup.home_team.name }}</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" @click="showMatchupModal = false">
                <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body container">
                <table class="table table-sm table-hover">
                  <thead>
                    <tr>
                      <th scope="col">Team Name</th>
                      <th scope="col">Off LOS/Dr.</th>
                      <th scope="col">Def LOS/Dr.</th>
                      <th scope="col">Off Pts/RZA</th>
                      <th scope="col">Def Pts/RZA</th>
                      <th scope="col">Off RZA/gm</th>
                      <th scope="col">Def RZA/gm</th>
                      <th scope="col">(+/-)</th>
                      <th scope="col">Off 3rd Down %</th>
                      <th scope="col">Def 3rd Down %</th>
                      <th scope="col">Off Pass Yds/gm</th>
                      <th scope="col">Off Rush Yds/gm</th>
                      <th scope="col">Def Pass Yds/gm</th>
                      <th scope="col">Def Rush Yds/gm</th>
                      <th scope="col">Off Pts/gm</th>
                      <th scope="col">Def Pts/gm</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="team in teams" :key="team.team_id">
                      <th scope="row">{{ team.name }}</th>
                      <td>{{ team.off_LOS_drive }}</td>
                      <td>{{ team.def_LOS_drive }}</td>
                      <td>{{ team.off_pts_rz }}</td>
                      <td>{{ team.def_pts_rz }}</td>
                      <td>{{ team.off_RZA_game }}</td>
                      <td>{{ team.def_RZA_game }}</td>
                      <td>{{ team.give_take_diff }}</td>
                      <td>{{ team.off_3rd_pct }}</td>
                      <td>{{ team.def_3rd_pct }}</td>
                      <td>{{ team.off_pass_yds_game }}</td>
                      <td>{{ team.off_rush_yds_game }}</td>
                      <td>{{ team.def_pass_yds_game }}</td>
                      <td>{{ team.def_rush_yds_game }}</td>
                      <td>{{ team.off_pts_game }}</td>
                      <td>{{ team.def_pts_game }}</td>
                    </tr>
                  </tbody>
                </table>
                <br>
                <highcharts :options="chartOptions"></highcharts>
              </div>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>
</div>

</template>

<script>
import axios from 'axios'
import { mapState } from 'vuex'
import moment from 'moment'

export default {
  name: 'matchup',
  props: [
    'matchup'
  ],
  data () {
    return {
      showScoreModal: false,
      showNoteModal: false,
      showMatchupModal: false,
      showSpreadModal: false,
      showCustomWeightModal: false,
      home_team_score: '',
      away_team_score: '',
      updatedSpread: '',
      homeTeamStats: {},
      awayTeamStats: {},
      customWeight: '',
      note: ''
    }
  },
  created () {
    // this.getMatchupStats()
    // TODO ---- CALL ON SELECT WEEK OR GET MATCHUP DETAILS SO THAT IT UPDATES
    // DYNAMICALLY THE STATS OBJECT FOR EACH WEEK/MATCHUP
    if (!this.matchup.home_team_score && !this.matchup.away_team_score) {
      this.queryForScore()
    }
  },
  computed: {
    ...mapState([
      'activeWeek',
      'activeUser'
    ]),
    isAdmin () {
      return this.activeUser.admin
    },
    teams () {
      return [this.awayTeamStats, this.homeTeamStats]
    },
    systemSpreadFormatted () {
      let spread = this.roundHalf(this.matchup.system_spread)
      if (spread > 0) {
        return '+' + spread
      } else if (spread === 0) {
        return 'Pick \'Em'
      } else {
        return spread
      }
    },
    vegasSpreadFormatted () {
      if (!this.matchup.vegas_spread) {
        return 'No Spread Info'
      }
      let spread = this.matchup.vegas_spread.includes('+') ? this.matchup.vegas_spread.substring(1) : this.matchup.vegas_spread
      if (spread > 0) {
        return '+' + spread
      } else if (spread === 0 || spread === '0') {
        return 'Pick \'Em'
      } else {
        return spread
      }
    },
    predictedWinner () {
      let homeTeam = this.matchup.home_team
      let awayTeam = this.matchup.away_team
      if (this.matchup.system_spread < parseFloat(this.matchup.vegas_spread)) {
        return homeTeam
      } else {
        return awayTeam
      }
    },
    chartOptions () {
      const parsedHistory = JSON.parse(this.matchup.spread_history)
      var spreadHistory = parsedHistory.map(point => {
        return [point.date, parseFloat(point.spread)]
      })
      let optionsObject = {
        series: [{
          data: spreadHistory, // sample data
          name: 'Spread'
        }],
        title: 'Spread History',
        xAxis: {
          type: 'datetime',
          ordinal: false,
          dateTimeLabelFormats: { // don't display the dummy year
            day: '%e. %b',
            hour: '%H:%M'
          },
          title: {
            text: 'Date'
          }
        },
        lang: {
          noData: 'No Spread History'
        },
        noData: {
          style: {
            fontWeight: 'bold',
            fontSize: '2em'
          }
        },
        credits: {
          enabled: false
        }
      }

      return optionsObject
    },
    matchupPush () {
      return parseFloat(this.matchup.away_team_score - this.matchup.home_team_score) === parseFloat(this.matchup.vegas_spread)
    }
  },
  watch: {
    activeWeek () {
      if (!this.matchup.away_team_score && !this.home_team_score) {
        this.queryForScore()
      }
    }
  },
  methods: {
    roundHalf (value) {
      return Math.round(value * 2) / 2
    },
    queryForScore () {
      let gameDate = this.matchup.date.replace(/-/g, '')
      let today = moment().format('YYYYMMDD')
      if (gameDate < today) {
        axios({
          url: '/api/matchups/' + this.matchup.matchup_id + '/score',
          method: 'POST',
          data: this.matchup
        }).then(response => {
          this.matchup.home_team_score = response.data.home_team_score
          this.matchup.away_team_score = response.data.away_team_score
        })
      }
    },
    clickMatchDetails () {
      this.showMatchupModal = true
      this.getHomeMatchupStats()
      this.getAwayMatchupStats()
    },
    getHomeMatchupStats (teamId) {
      const body = {
        week: this.matchup.week,
        season: this.matchup.season
      }
      axios({
        url: '/api/teams/' + this.matchup.home_team_id + '/weekly_stats',
        method: 'POST',
        data: body
      }).then(response => {
        this.homeTeamStats = response.data[0]
        this.homeTeamStats.name = this.matchup.home_team.name
      }).catch(error => {
        console.log(error)
      })
    },
    getAwayMatchupStats (teamId) {
      const body = {
        week: this.matchup.week,
        season: this.matchup.season
      }
      axios({
        url: '/api/teams/' + this.matchup.away_team_id + '/weekly_stats',
        method: 'POST',
        data: body
      }).then(response => {
        this.awayTeamStats = response.data[0]
        this.awayTeamStats.name = this.matchup.away_team.name
      }).catch(error => {
        console.log(error)
      })
    },
    getSrc (name) {
      var images = require.context('../../static/img/logos/', false, /\.png$/)
      return images('./' + name.toLowerCase() + '.png')
      // return '../../static/img/logos/' + name + '.png'
    },
    deleteMatchup () {
      axios({
        url: '/api/matchups/' + this.matchup._id,
        method: 'DELETE'
      }).then(response => {
        this.$parent.$emit('deletedMatchup', response)
      }
      ).catch(error => {
        console.log(error)
      })
    },
    updateLine () {
      axios({
        url: '/api/matchups/' + this.matchup.matchup_id + '/refresh_system_spread',
        method: 'POST',
        data: this.matchup
      }).then(response => {
        this.matchup.system_spread = response.data.system_spread
        this.$parent.$emit('updatedMatchup', response)
      }
      ).catch(error => {
        console.log(error)
      })
    },
    updateScore () {
      this.matchup.away_team_score = this.away_team_score
      this.matchup.home_team_score = this.home_team_score
      axios({
        url: '/api/matchups/' + this.matchup.matchup_id,
        method: 'PUT',
        data: this.matchup
      }).then(response => {
        this.showScoreModal = false
        this.matchup.correct_pick = response.data.correct_pick
        this.home_team_score = ''
        this.away_team_score = ''
        this.$forceUpdate()
        console.log('Score Updated!')
      }).catch(response => {
        console.log(response)
      })
    },
    updateCustomWeight () {
      this.matchup.custom_weight = this.customWeight
      axios({
        url: '/api/matchups/' + this.matchup.matchup_id,
        method: 'PUT',
        data: this.matchup
      }).then(response => {
        this.showCustomWeightModal = false
        this.matchup.custom_weight = response.data.custom_weight
        this.customWeight = ''
      }).catch(response => {
        console.log(response)
      })
    },
    updateSpread () {
      this.matchup.vegas_spread = this.updatedSpread <= 0 ? this.updatedSpread : '+' + this.updatedSpread
      axios({
        url: '/api/matchups/' + this.matchup.matchup_id,
        method: 'PUT',
        data: this.matchup
      }).then(response => {
        this.showSpreadModal = false
        this.matchup.spread_history = response.data.spread_history
        this.matchup.vegas_spread = response.data.vegas_spread
        this.updatedSpread = ''
      }).catch(response => {
        console.log(response)
      })
    },
    addNote () {
      this.matchup.note = this.note
      axios({
        url: '/api/matchups/' + this.matchup.matchup_id,
        method: 'PUT',
        data: this.matchup
      }).then(response => {
        this.note = ''
        this.showNoteModal = false
      }).catch(response => {
        console.log(response)
      })
    }
  }
}
</script>

<style>
.align-center {
  height: 100%;
  display: flex;
  align-items: center;  /*Aligns vertically center */
  justify-content: center; /*Aligns horizontally center */
}

#bootstrap-matchup-override .bg-success {
  background-color: rgba(0, 166, 105, .3) !important;
}

.card {
  margin-bottom: 3em;
}

#header-override li i.nav-link {
  margin-bottom: auto;
  margin-top: auto;
}

#header-override ul {
  display: grid !important;
  grid-column-gap: 5px;
  justify-items: center;
}

li:nth-child(2) { margin-left: auto; }

.score {
  font-size: 1.5em
}

.push-box {
  border: 2px solid #262626;
  box-shadow: 2px 2px 8px grey;
  padding: 5px;
  margin-top: 5px;
}

</style>


