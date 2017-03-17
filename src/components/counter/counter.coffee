require "./counter.sass"

module.exports =

  template: require("./counter.jade")()

  bindings: 
    count: '='

  controller: ->

    @increment = ->
      @count++
      
    @decrement = ->
      @count--

    return
