# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
    if $('#carousel').length > 0     
        carousel = $('#carousel').get(0)
        ctx = carousel.getContext('2d')
        img = $('#pic').get(0)
        ctx.drawImage(img, 10, 10)
        #alert img.id
