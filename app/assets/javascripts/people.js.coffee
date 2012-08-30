# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#ShowHide').click (e)->
    e.preventDefault
    if $(@).text() == 'Show Inactive'
      $(@).text('Show Active')
    else
      $(@).text('Show Inactive')
    $('.castTable tr').toggleClass('castHide castShow')
