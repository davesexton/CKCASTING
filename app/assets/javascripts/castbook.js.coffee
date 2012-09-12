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

#TODO add code for zero cast
castUpdate = () ->
  #$('.castThumb img').attr('src', '/assets/progress.gif')
  data = $('#castFilters').serialize()
  $('#castThumbs').load 'castbook/castlist', data, (e) ->
    $(".castThumb").hover(ctIn, ctOut)
    $('#castFilters input').parent().css('background-color', '#FFFFFF')
    $('#castFilters input:checked').parent().css('background-color', '#FF6666')
    $('#pageLinks a').show().css(pageLinkCold).slice($('#pages').val()).hide()
    page = $('#page').val()
    $("#pageLinks a:contains('#{page}')").css(pageLinkHot)

$ ->
  if $('.castbook').length > 0
    castUpdate()
    $('#castFilters input').change () ->
      $('#page').val(1)
      castUpdate()

    $('.reset').click (e) ->
      e.preventDefault
      $('#castFilters input[type=checkbox]').attr('checked', false)
      castUpdate()
    $('#pageLinks a').each () ->
      @.preventDeault
      $(@).attr('href', 'javascript:void(0);')
      $(@).click (e) ->
        $('#page').val @.innerHTML
        castUpdate()
