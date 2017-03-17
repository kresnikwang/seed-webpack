#################################################
#
# AudioService
#
#################################################

module.exports = [
  "$rootScope",
  ($rootScope)->


    class AudioService

      name: "AudioService"

      constructor: ()->

      playAmbient: ()=>
        @ambient = new Howl({
          src: ['sound.mp3']
          autoplay: true
          loop: true
          volume: 1.0
        })

        @ambient.play()


    window.AudioService = new AudioService()
]