# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#$ ->
#    if $('#carousel').length > 0     
#        carousel = $('#carousel').get(0)
#        ctx = carousel.getContext('2d')
#        img = $('#pic').get(0)
#        ctx.drawImage(img, 10, 10)
#        #alert img.id

imgs = []
#objName = (name) ->
#    this.name

$ ->
    if $('.home').length > 0
        $('#carouselImages').ready ->
            canvas = $("#carousel")
            context = canvas.get(0).getContext "2d" 
            canvasWidth = canvas.width()
            canvasHeight = canvas.height()
            radiusX = 375
            radiusY = 20
            centerX = (canvasWidth / 2) - 46
            centerY = (canvasHeight / 2) - 77
            speed = 0.015
            
            imgObj = ->
                this.img = new Image()
                this.angle = 32
            imgObj.prototype.x = ->
                Math.cos(this.angle) * radiusX + centerX
            imgObj.prototype.y = ->
                Math.sin(this.angle) * radiusY + centerY
            imgObj.prototype.scale = ->
                ((70 + (15 * (this.y() / (centerY + radiusY)))) / 100)
            imgObj.prototype.height = ->
                this.scale() * this.img.height
            imgObj.prototype.width = ->
                this.scale() * this.img.width    
            imgObj.prototype.toString = ->
                return this.y()
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

            
            
