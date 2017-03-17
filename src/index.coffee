#################################################
#
# Index
#
#################################################
require "./index.sass"

document.body.style.display = "block"
fastclick.attach document.body

#################################################
# BOOTSTRAP
#################################################
app = angular.module('app', [
  'ngAnimate'
  'ui.router'
  'pascalprecht.translate'
])

app.component    'counter',                    require './components/counter/counter.coffee'

app.directive    'svgReplace',                 require('./components/helpers/SvgReplace.coffee')

app.service      'AnalyticsService',           require('./components/analytics/AnalyticsService.coffee')
app.service      'AudioService',               require('./components/audio/AudioService.coffee')
app.service      'ShareService',               require('./components/share/ShareService.coffee')
app.service      'BrowserService',             require('./components/browser/BrowserService.coffee')
app.service      'DebugService',               require('./components/debug/DebugService.coffee')
app.service      'HistoryService',             require('./components/history/HistoryService.coffee')
app.service      'LoadingService',             require('./components/loading/LoadingService.coffee')


#################################################
# ROUTE CONFIG
#################################################
app.config [
  '$urlRouterProvider'
  '$stateProvider'
  ($urlRouterProvider, $stateProvider)->

    $urlRouterProvider.otherwise("/")

    $stateProvider
      .state('home', {
        url: '/'
        template: require("./pages/home/home.jade")
        controller: require('./pages/home/home.coffee')
      })
]




#################################################
# TRANSLATE CONFIG
#################################################
app.config(['$translateProvider', ($translateProvider)->

  $translateProvider.translations('en', {
    TITLE: "Title"
  })

  $translateProvider.translations('zh_CN', {
    TITLE: "搭配指南"

  })

  $translateProvider.useSanitizeValueStrategy 'escape'
  $translateProvider.preferredLanguage 'zh_CN'
  # $translateProvider.preferredLanguage 'en'

])



