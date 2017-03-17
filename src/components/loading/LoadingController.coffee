
module.exports = [
  "$rootScope", "$scope", "$timeout", "$window", "LoadingService", "AnalyticsService"
  ($rootScope, $scope, $timeout, $window, LoadingService, AnalyticsService)->

    class LoadingController

      name: "item"

      constructor: ()->
        @scope = $scope
        $scope.name = @name
        $scope.service = LoadingService
        $scope.Math = Math

    window.item = new LoadingController()
]

