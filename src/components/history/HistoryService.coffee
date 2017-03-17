#################################################
#
# HistoryService
#
#################################################

module.exports = ["$rootScope", ($rootScope)->


  class HistoryService

    name: "HistoryService"

    depth: 0

    history: []

    constructor: ()->

      $rootScope.$on '$stateChangeStart', (evt, to, toParams, from, fromParams)=>

        state = _.clone from
        state.params = _.clone fromParams

        if to.back || toParams.back
          @history.pop()
        else
          @history.push state

        # console.log "#{@name}", to?.name, _.last(@history)?.name, _.pluck(@history, 'name')

        @prevState = from
        back = from.back
        @prevState.params = fromParams
        @prevState.params.back = back

    reset: ()=>
      history = []

    getBackState: ()=>
      _.last @history

    decreaseDepth: ()=>
      @depth -= 1
      @depth = 0 if @depth < 0

    increaseDepth: ()=>
      @depth += 1


  window.HistoryService = new HistoryService()

]


