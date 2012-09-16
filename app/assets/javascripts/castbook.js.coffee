# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

pageLinkCold =
  'background-color': '#666666'
  'color': '#ffffff'

pageLinkHot =
  'background-color': '#ffffff'
  'color': '#666666'

ctIn = ()->
  $(".castThumb").stop().not(@).fadeTo('slow', 0.2)
  $(@).fadeTo('fast', 1)

ctOut = () ->
  $(".castThumb").stop().fadeTo('fast', 1)

updatePagination = (e) ->
  if e == undefined
    $('#page').val(1)
  if /Next/.test($(e).text())
    $('#page').val(parseInt($('#page').val()) + 1)
  if /Prev/.test($(e).text())
    $('#page').val(parseInt($('#page').val()) - 1)
  if /\d+/.test($(e).text())
    $('#page').val($(e).text())

   # Next →

  $('#castFilters input').parent().css('background-color', '#FFFFFF')
  $('#castFilters input:checked').parent().css('background-color', '#FF6666')
  data = $('#castFilters').serialize()
  $('#castThumbs').load 'castbook/castlist', data, () ->
    $(".castThumb").hover(ctIn, ctOut)
    $('.pagination a').click (e) ->
      e.preventDefault()
      updatePagination(@)

$ ->
  if $('.castbook').length > 0

    $('#castFilters input').parent().css('background-color', '#FFFFFF')
    $('#castFilters input:checked').parent().css('background-color', '#FF6666')

    $('#castFilters input').change () ->
      $('#page').val(1)
      updatePagination()

    $('.reset').click (e) ->
      e.preventDefault
      $('#castFilters input[type=checkbox]').attr('checked', false)
      updatePagination()

    $('.pagination a').click (e) ->
      e.preventDefault()
      updatePagination(@)




#
