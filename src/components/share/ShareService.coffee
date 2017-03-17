#################################################
#
# ShareService
#
#################################################


module.exports = [
  "$rootScope", "$http", "$stateParams", "AnalyticsService"
  ($rootScope, $http, $stateParams, AnalyticsService)->

    class ShareService

      name: "ShareService"
      shareImg: require("src/assets/icon.jpg")


      constructor: ()->
        @lastUrl = null
        @inWechat = /micromessenger/i.test(navigator.userAgent)


      #################################################
      # INIT
      #################################################
      injectScript: (cb)=>
        head = document.head || document.getElementsByTagName('head')[0]
        src = "//res.wx.qq.com/open/js/jweixin-1.0.0.js"
        postscribe(head, "<script src='#{src}'><\/script>", {
          afterAsync: ()->
            cb?()
        })


      init: ()=>
        @injectScript ()=>
          @updateConfig ()=>
            @enableShare()
            @setDefaultLink()



      updateConfig: ( cb )=>

        configUrl = "/api/component/wechat/share"

        if @lastUrl == encodeURIComponent(location.href.split('#')[0])
          return cb?()

        @lastUrl = encodeURIComponent(location.href.split('#')[0])

        $http({
          url: "#{configUrl}?url=#{@lastUrl}"
          type: 'GET'
          timeout: 30000
        }).success((config)=>
          @handleConfigSuccess config, cb
        )


      handleConfigSuccess: (@config, cb)=>
        wx?.config({
          debug: false
          appId: @config.data.appId
          timestamp: @config.data.timestamp
          nonceStr: @config.data.nonceStr
          signature: @config.data.signature
          jsApiList: [
            'checkJsApi'
            'onMenuShareTimeline'
            'onMenuShareAppMessage'
            'hideMenuItems'
            'showMenuItems'
          ]
        })
        wx?.ready cb



      disableShare: ()->
        wx?.hideMenuItems({
          menuList: [
            'menuItem:share:appMessage'
            'menuItem:share:timeline'
            'menuItem:share:qq'
            'menuItem:share:weiboApp'
            'menuItem:share:facebook'
          ]
        })

      enableShare: ()=>
        wx?.showMenuItems({
          menuList: [
            'menuItem:share:appMessage'
            'menuItem:share:timeline'
            'menuItem:share:qq'
            'menuItem:share:weiboApp'
            'menuItem:share:facebook'
          ]
        })

      setLink: (link, title="", desc="", moments="")=>

        @updateConfig ()=>

          wx?.onMenuShareTimeline({
            link: "#{window.location.origin}/courtzero/#{link}"
            title: moments
            imgUrl: "#{window.location.origin}/courtzero/#{@shareImg}"
            success: ()=>
              AnalyticsService.sendEvent 'shareTimeline', link
              @incrementShare()

          })

          wx?.onMenuShareAppMessage({
            link: "#{window.location.origin}/courtzero/#{link}"
            title: title
            desc: desc
            imgUrl: "#{window.location.origin}/courtzero/#{@shareImg}"
            success: ()=>
              AnalyticsService.sendEvent 'shareAppMessage', link
              @incrementShare()
          })

      setDefaultLink: ()=>

        @setLink(
          ""
          "你敢接招吗？"
          "与威少过招，Court Zero等你来挑战"
          "与威少过招，Court Zero等你来挑战"
        )


    window.ShareService = new ShareService()
]

