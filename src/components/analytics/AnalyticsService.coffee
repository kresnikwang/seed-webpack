#################################################
#
# AnalyticsService
#
#################################################

module.exports = [

  "$rootScope",
  ($rootScope)->


    class AnalyticsService

      name: "AnalyticsService"

      constructor: ()->

      sendPageview: (url)->
        ga?('set', 'page', url)
        ga?('send', 'pageview')

      sendEvent: (category, action, label, value)->
        ga?('send', 'event', category, action, label, value)

      setDimension: (dimension, value)->
        ga?('set', dimension, value)

    window.AnalyticsService = new AnalyticsService()

]