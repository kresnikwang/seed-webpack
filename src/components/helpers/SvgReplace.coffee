module.exports = ["$http", ( $http )->
  {
    restrict: 'A'
    link: ( scope, element, attrs )->

      imgId = attrs.id
      imgClass = attrs.class
      imgUrl = attrs.src

      doReplace = ()->
        # Load svg content
        $http.get(imgUrl).success (data, status) ->
          svg = angular.element(data)
          i = svg.length - 1

          while i >= 0
            if svg[i].constructor.name is "SVGSVGElement"
              svg = angular.element(svg[i])
              break
            i--
          svg.attr "id", imgId  if typeof imgId isnt "undefined"
          svg.attr "class", imgClass  if typeof imgClass isnt "undefined"

          # Remove invalid attributes
          svg = svg.removeAttr("xmlns:a")
          element.replaceWith svg

      # doReplace()

      attrs.$observe "src", (newSrc)->
        imgUrl = attrs.src
        doReplace()

  }
]