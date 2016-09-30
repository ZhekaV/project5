$(document).on 'change', "input[name='viewed']", ->
  $.ajax
    url:        "/musics/#{@.value}"
    type:       'PATCH'
    dataType:   'text'
