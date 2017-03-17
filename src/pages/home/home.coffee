require "./home.sass"


module.exports = [
  "$scope"
  ($scope)->
    class HomeCtrl

      name: "HomeCtrl"

      constructor: ()->
        $scope.name = 'World'

      changeName: ()->
        $scope.name = 'New World'

    window.HomeCtrl = new HomeCtrl()
]

