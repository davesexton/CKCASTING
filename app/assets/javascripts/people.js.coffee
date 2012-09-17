# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#ShowHide').click (e)->
    e.preventDefault
    if $(@).text() == 'Inactive'
      $(@).text('Active')
    else
      $(@).text('Inactive')
    $('.castTable tr').toggleClass('castHide castShow')
