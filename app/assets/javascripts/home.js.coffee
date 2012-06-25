# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#$ ->
#  if $('#carousel').length > 0   
#    carousel = $('#carousel').get(0)
#    ctx = carousel.getContext('2d')
#    img = $('#pic').get(0)
#    ctx.drawImage(img, 10, 10)
#    #alert img.id

imgs = []
#objName = (name) ->
#  this.name

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
        x: ->
          Math.cos(@angle) * radiusX + centerX
        y: ->
          Math.sin(@angle) * radiusY + centerY
        scale: ->
          ((70 + (15 * (@y() / (centerY + radiusY)))) / 100)
        height: ->
          @scale() * @img.height
        width: ->
          @scale() * @img.width
        toString: ->
          @y()
      
      imgSet = $('#carouselImages img')
      totImgs = imgSet.length
      imgSet.each((i, e) ->
        img = new imgObj()
        img.img = e
        img.angle = i * ((Math.PI * 2) / totImgs)
        imgs.push img
      )
      
      animate = ->
        context.clearRect 0, 0, canvasWidth, canvasHeight 
        
        imgs.sort((a, b)-> a - b)
        for img in imgs  
          context.drawImage img.img, img.x(), img.y(), img.width(), img.height()
        setTimeout animate, 33
        img.angle += speed for img in imgs
      animate()

      
      
