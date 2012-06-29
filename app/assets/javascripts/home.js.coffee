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
      mouseX = 0
      mouseY = 0
      currentId = null
      centerX = (canvasWidth / 2) - 46
      centerY = (canvasHeight / 2) - 77
      speed = 0.015
      
      drawEllipse = (c, centerX, centerY, width, height) ->
        c.beginPath()
        c.moveTo centerX, centerY - height / 2 
        c.bezierCurveTo centerX + width / 2, centerY - height / 2, centerX + width / 2, centerY + height / 2, centerX, centerY + height / 2
        c.bezierCurveTo centerX - width / 2, centerY + height / 2, centerX - width / 2, centerY - height / 2, centerX, centerY - height / 2
        c.fill()
        c.closePath()	
      
      $(canvas).mousemove (e)->
        speed = (canvasWidth - centerX - e.pageX  - @offsetLeft) / 10000
        mouseX = e.pageX - @offsetLeft
        mouseY = e.pageY - @offsetTop
        currentId = null
        for img in imgs
          if mouseX > img.x() and 
          mouseX < img.x() + img.width() and 
          mouseY > img.y() and 
          mouseY < img.y() + img.height()
            currentId = img.id
            $(@).css('cursor','pointer')
        if currentId == null
          $(@).css('cursor','auto')
                    
      $(canvas).click (e)->
        console.log currentId
        #add navigation to cast
      
      class imgObj
        img: new Image()
        angle: 32
        nangle: 32
        pangle: 32
        id: 0
        x: ->
          Math.cos(@angle) * radiusX + centerX
        y: ->
          Math.sin(@angle) * radiusY + centerY
        ny: ->
          Math.sin(@nangle) * radiusY + centerY
        py: ->
          Math.sin(@pangle) * radiusY + centerY
        scale: ->
          @y() / (centerY + radiusY)
        nscale: ->
          @ny() / (centerY + radiusY)
        pscale: ->
          @py() / (centerY + radiusY)
        height: ->
          156 - 10 + (10 * @scale())  #* @img.height
        nheight: ->
          ((156 - 10 + (10 * @nscale())) * 0.75) - 5 - (@y() - @ny())
        pheight: ->
          ((156 - 10 + (10 * @pscale())) * 0.75) - 5 - (@y() - @py())

        width: ->
          @height() / 1.5333
        toString: ->
          @y()
        draw: (c, s)->
          if @img.complete
            c.globalCompositeOperation = 'source-atop'
            c.fillRect @x() - 10, @ny() + 10, @width(), @nheight() - 10
            c.fillRect @x() + 10, @py() + 10, @width(), @pheight() - 10 
            c.globalCompositeOperation = 'source-over'
          c.drawImage @img, @x(), @y() , @width(), @height()
          #c.font="30px Arial";
          #c.fillText @id, @x() + 10, @y() + 50
          #console.log "#{@angle} #{@nangle}" if @first == true
          #console.log mouseY if @id == 1
          @angle += s
          @nangle = @angle + s
          @pangle = @angle - s
          
      imgSet = $('#carouselImages img')
      totImgs = imgSet.length
      imgSet.each((i, e) ->
        img = new imgObj()
        img.img = e
        img.angle = i * ((Math.PI * 2) / totImgs)
        #regex to get cast url
        img.id = e.src
        imgs.push img
      )
      
      #context.font = "24pt Arial"
      animate = ->
        context.clearRect 0, 0, canvasWidth, canvasHeight 
        
        context.fillStyle = "rgba(0, 0, 0, 0.2)"
        imgs.sort((a, b)-> a - b)
        for img, i in imgs
          img.draw context, speed
  
          if i == Math.round(totImgs / 2)
            #context.fillStyle = "rgba(0, 0, 0, 1)"
            context.globalCompositeOperation = 'destination-over'
            #context.fillText 'CK', 325, 150
            drawEllipse context, centerX, centerY + 117, radiusX * 2, radiusY * 2
            #context.globalCompositeOperation = 'source-over'
            #context.fillStyle = "rgba(0, 0, 0, 0.2)"  
        setTimeout animate, 33
      animate()

      
      
