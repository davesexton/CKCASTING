# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

ctIn = () ->
  $(".castThumb").stop().not(@).fadeTo('slow', 0.50)
  $(@).fadeTo('fast', 1)
ctOut = () ->
  $(".castThumb").stop().fadeTo('fast', 1)
castUpdate = () ->
  data = $('#castFilters').serialize()
  $('#castThumbs').load 'castbook/castlist', data, (e) ->
    $(".castThumb").hover(ctIn, ctOut)
#  console.log $(".castThumb").length

$ ->
  if $('.castbook').length > 0
    castUpdate()
    $('#castFilters > input').change () ->
      castUpdate()
