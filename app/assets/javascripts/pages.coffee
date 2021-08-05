# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('.tooltip').tooltip()
  $('a[rel=tooltip]').tooltip()
  $('button[rel=tooltip]').tooltip()
  $('span[rel=tooltip]').tooltip()
