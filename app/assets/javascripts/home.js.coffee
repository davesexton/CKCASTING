# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
imgs = []

$ ->
  if $('.home').length > 0
    $('#carouselImages').ready ->
      canvas = $("#carousel").get(0)
      
      context = canvas.getContext "2d" 
      canvasWidth = canvas.width
      canvasHeight = canvas.height
      radiusX = 375
      radiusY = 20
      centerX = (canvasWidth / 2) - 46
      centerY = (canvasHeight / 2) - 77
      speed = 0.015
      
      $(canvas).mousemove (e)->
        speed = (canvasWidth - centerX - e.pageX) / 10000
      
      class imgObj
        img: new Image()
        angle: 32
        nangle: 32
        id: 0
        x: ->
          Math.cos(@angle) * radiusX + centerX
        y: ->
          Math.sin(@angle) * radiusY + centerY
        ny: ->
          Math.sin(@nangle) * radiusY + centerY
        scale: ->
          ((70 + (15 * (@y() / (centerY + radiusY)))) / 100)
        nscale: ->
          ((70 + (15 * (@y() / (centerY + radiusY)))) / 100)
        height: ->
          @scale() * @img.height
        nheight: ->
          @nscale() * (@img.height - 45) - (@ny() - @y())
        width: ->
          @scale() * @img.width

        toString: ->
          @y()
        draw: (c, s)->
          c.globalCompositeOperation = 'source-atop'
          c.fillRect @x() - 10, @y(), 120, 138 - (@y() - @ny()) #, @width(), @height()
          c.globalCompositeOperation = 'source-over'
          c.drawImage @img, @x(), @y() #, @width(), @height()
          c.fillText @id, @x() + 10, @y() + 50
          #console.log "#{@angle} #{@nangle}" if @first == true
          console.log "#{@height()}}" if @id == 1
          @angle += s
          
      imgSet = $('#carouselImages img')
      totImgs = imgSet.length
      imgSet.each((i, e) ->
        img = new imgObj()
        img.img = e
        img.angle = i * ((Math.PI * 2) / totImgs)
        img.nangle = (i + 1) * ((Math.PI * 2) / totImgs)
        img.id = i
        imgs.push img
      )
      
      context.font = "24pt Arial"
      animate = ->
        context.clearRect 0, 0, canvasWidth, canvasHeight 
        
        context.fillStyle = "rgba(255, 0, 0, 0.8)"
        imgs.sort((a, b)-> a - b)
        for img, i in imgs
          img.draw context, speed
  
          if i == Math.round(totImgs / 2)
            context.fillStyle = "rgba(0, 0, 0, 1)"
            context.globalCompositeOperation = 'source-over'
            context.fillText 'CK', 325, 150
            context.fillStyle = "rgba(255, 0, 0, 0.8)"  
        setTimeout animate, 33
      animate()

      
      
