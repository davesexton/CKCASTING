# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
imgs = []

$ ->
  $('nav > div').click( (e) ->
    window.location.href =  $(@).children(0).get(0).href
  ).hover( (e) ->
    $(@).css('cursor','pointer')
  )

  if $('.home').length > 0
    $('#carouselImages').ready ->

#Global variables
#----------------------------------------
      canvas = $("#carousel").get(0)
      context = canvas.getContext "2d"
      canvasWidth = canvas.width
      canvasHeight = canvas.height
      radiusX = 375
      radiusY = 20
      mouseX = 0
      mouseY = 0
      showClick = false
      currentId = null
      centerX = (canvasWidth / 2) - 46
      centerY = (canvasHeight / 2) - 77
      speed = 0.015

#Elipse function
#----------------------------------------
      drawEllipse = (c, x, y, w, h) ->
        c.beginPath()
        c.moveTo x + w, y
        c.bezierCurveTo x + w, y + h, x - w, y + h, x - w, y
        c.bezierCurveTo x - w, y - h, x + w, y - h, x + w, y
        c.fill()
        c.closePath()

#Hover handler
#----------------------------------------
      $(canvas).mousemove (e)->
        mouseX = e.pageX - @offsetLeft
        mouseY = e.pageY - @offsetTop
        speed = ((canvasWidth / 2) - mouseX) / 10000
        currentId = null
        for img in imgs
          if mouseX > img.x() and
          mouseX < img.x() + img.width() and
          mouseY > img.y() and
          mouseY < img.y() + (img.height() * 0.75)
            currentId = img.id
            $(@).css('cursor','pointer')
            showClick = true
        if currentId == null
          $(@).css('cursor','auto')
          showClick = false


#Click handler
#----------------------------------------
      $(canvas).click (e)->
        showClick = false
        window.location.href = currentId

#Define image object
#----------------------------------------
      class imgObj
        constructor: (@img, @angle, @id) ->
        pangle: 0
        nangle: 0
        rawHeight: 156
        x: ->
          Math.cos(@angle) * radiusX + centerX
        y: ->
          Math.sin(@angle) * radiusY + centerY
        ny: ->
          Math.sin(@nangle) * radiusY + centerY
        py: ->
          Math.sin(@pangle) * radiusY + centerY
        scale: ->
          @y() / (centerY + radiusY) * @scale_factor
        scale_factor: 1
        nscale: ->
          @ny() / (centerY + radiusY)
        pscale: ->
          @py() / (centerY + radiusY)
        height: ->
          @rawHeight - 10 + (10 * @scale())
        nheight: ->
          ((@rawHeight - 10 + (10 * @nscale())) * 0.75) - 5 - (@y() - @ny())
        pheight: ->
          ((@rawHeight - 10 + (10 * @pscale())) * 0.75) - 5 - (@y() - @py())
        width: ->
          @height() / (@img.height / @img.width)
        toString: ->
          @y()
        draw: (c, s)->
          if @id == currentId
            @scale_factor += 0.2 unless @scale_factor > 2
          else
            @scale_factor -= 0.2 unless @scale_factor <= 1
          if @img.complete
            c.globalCompositeOperation = 'source-atop'
            c.fillRect @x() - 10, @ny() + 10, @width(), @nheight() - 10
            c.fillRect @x() + 10, @py() + 10, @width(), @pheight() - 10
            c.globalCompositeOperation = 'source-over'
          c.drawImage @img, @x(), @y() , @width(), @height()
          @angle += s
          @nangle = @angle + s
          @pangle = @angle - s

#initalise image objects
#----------------------------------------
      imgSet = $('#carouselImages img')
      totImgs = imgSet.length
      imgSet.each((i, e) ->
        regex = new RegExp(/(\d+)\./)
        id = '/castbook/cast/' + regex.exec(e.src)[1]
        angle = i * ((Math.PI * 2) / totImgs)
        img = new imgObj(e, angle, id)

        imgs.push img
      )

#animate function
#----------------------------------------
      context.font="12px Verdana"
      animate = ->
        context.clearRect 0, 0, canvasWidth, canvasHeight

        context.fillStyle = "rgba(0, 0, 0, 0.2)"
        imgs.sort((a, b)-> a - b)
        for img, i in imgs
          img.draw context, speed

          if i == Math.round(totImgs / 2)
            #context.fillStyle = "rgba(0, 0, 0, 1)"
            context.globalCompositeOperation = 'destination-over'
            #context.fillText 'click here', mouseX, moseY
            drawEllipse context, centerX, centerY + 110, radiusX, radiusY + 10
            #context.globalCompositeOperation = 'source-over'
            #context.fillStyle = "rgba(0, 0, 0, 0.2)"
        if showClick
          context.save()
          context.fillStyle = "rgba(255, 255, 255, 0.8)"
          context.fillRect mouseX + 15, mouseY - 25, 65, 20
          context.font = "12px Verdana"
          context.fillStyle = "rgba(0, 0, 0, 1)"
          context.fillText 'click here', mouseX + 20, mouseY - 10
          context.restore()
        setTimeout animate, 33
      animate()
