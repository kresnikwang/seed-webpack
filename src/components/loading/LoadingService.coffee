#################################################
#
# LoadingService
#
#################################################

require "./loading.sass"

module.exports = [
  "$rootScope"
  ($rootScope)->

    class LoadingService

      name: "LoadingService"

      constructor: ()->
        @events =
          loaded: []
        @startDate = Date.now()
        @loaders = []
        @loaded = false
        @percent = 0
        @q = queue()
        requestAnimationFrame @anim
        # console.log "************ #{@name} START ************"

      on: (eventName, cb)=>
        @events[eventName].push cb

      off: (eventName, cb)=>
        i = @events[eventName].indexOf cb
        @events[eventName].splice(i, 1) if i >= 0


      trigger: (eventName, evt)=>
        for fx in @events[eventName]
          fx evt

      add: (name)=>
        # console.log "#{@name}.add() #{name}"
        @loaders.push {name: name, percent: 0, startDate: Date.now()}
        $rootScope.$apply() if not $rootScope.$$phase


      remove: (name)=>
        loader = _.find @loaders, (loader)-> loader.name == name
        loader.endDate = Date.now()
        loader.time = loader.endDate - loader.startDate
        $rootScope.$apply() if not $rootScope.$$phase
        # console.log "#{@name}.#{name}: DONE"

      update: (name, percent)=>
        loader = _.find @loaders, (loader)-> loader.name == name
        return if not loader?
        loader.percent = percent
        # console.log "#{@name}.#{name}: #{percent}"
        if percent >= 1
          @remove name
        $rootScope.$apply() if not $rootScope.$$phase

      done: ()=>
        endDate = Date.now()
        time = endDate - @startDate
        console.log "************ #{@name} DONE #{time / 1000}s ************"
        @loaded = true
        @trigger "loaded"
        # document.querySelector("#loading").classList.add 'inactive'
        # console.log document.querySelector("#loading").classList
        $rootScope.$apply() if not $rootScope.$$phase



      anim: ()=>
        # @percent = @q._ended / @q._tasks.length
        # document.querySelector("#loading #main-bar .progress").style.transform = "scaleX(#{@percent})"
        # document.querySelector("#loading #main-bar .progress").style.webkitTransform = "scaleX(#{@percent})"
        # if @q._ended > 0 and @percent >= 1
        #   return @done()

        percent = 0
        for loader in @loaders
          continue if loader.endDate?
          percent += loader.percent

        numNotLoaded = _.filter(@loaders, (loader)-> !loader.endDate?).length
        if @loaders.length > 0 and numNotLoaded > 0
          @percent = percent / numNotLoaded
        else
          @percent = 0

        @percent = 0 if not @percent
        @percent = 1 if numNotLoaded == 0

        if @loaders.length > 1 and numNotLoaded == 0
          return @done()

        else
          requestAnimationFrame @anim


    window.LoadingService = new LoadingService()
]



